//
//  AuthViewController.swift
//  ALC_RB
//
//  Created by ayur on 21.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AuthViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var signInButton: UIButton!
    
    private var viewModel: AuthViewModel!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupBinds()
        
        checkUserAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
    }
    
}

// MARK: - SETUP

extension AuthViewController {
    
    func setupViewModel() {
        viewModel = AuthViewModel(dataManager: ApiRequests())
    }
    
    func setupBinds() {
        
        viewModel
            .authUser
//            .observeOn(MainScheduler.instance)
            .subscribe({ uUser in
                guard let user = uUser.element else { return }
                self.replaceUserLKVC(authUser: user)
            })
            .disposed(by: bag)
        
        signInButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .subscribe({ _ in
                if self.fieldsIsEmpty() == false {
                    let signIn = SignIn(
                        login: self.loginTextField.text!,
                        password: self.passwordTextField.text!)
                    self.viewModel.authorization(userData: signIn)
                } else {
                    self.viewModel.message.onNext(SingleLineMessage(message: Constants.Texts.FILL_ALL_FIELDS))
                }
            })
            .disposed(by: bag)
        
        viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.loading)
            .disposed(by: bag)
        
        viewModel
            .error
            .asDriver(onErrorJustReturn: nil)
            .drive(self.rx.error)
            .disposed(by: bag)
        
        viewModel
            .message
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.message)
            .disposed(by: bag)
    }
    
}

// MARK: - HELPER

extension AuthViewController {
    
    func checkUserAuthorization() {
        if viewModel.userDefaults.userIsAuthorized() == true {
            viewModel.authUser.onNext(viewModel.userDefaults.getAuthorizedUser()!)
        }
    }
    
    func replaceUserLKVC(authUser: AuthUser) {
        Print.m("replace")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "UserNC") as! UINavigationController
        
        let childViewController = viewController.children.first as! UserLKViewController
        childViewController.authUser = authUser
        
        let countOfViewControllers = tabBarController?.viewControllers?.count
        viewController.tabBarItem = tabBarController?.viewControllers![countOfViewControllers! - 1].tabBarItem

        tabBarController?.viewControllers![countOfViewControllers! - 1] = viewController
    }
    
    func fieldsIsEmpty() -> Bool {
        if loginTextField.isEmpty() || passwordTextField.isEmpty() {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - REACTIVE

extension Reactive where Base: AuthViewController {
    
    internal var loading: Binder<Bool> {
        return Binder(self.base) { vc, isLoading in
            if isLoading == true {
                if vc.hud != nil {
                    vc.hud?.setToLoadingView(message: Constants.Texts.AUTHORIZATION, detailMessage: "")
                } else {
                    vc.hud = vc.showLoadingViewHUD(with: Constants.Texts.AUTHORIZATION)
                }
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
        }
    }
    
}
