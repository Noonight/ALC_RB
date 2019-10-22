//
//  RegistrationViewController.swift
//  ALC_RB
//
//  Created by ayur on 21.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController {
    enum Texts {
        static let FILL_ALL_FIELDS = "Заполните все поля"
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var familyTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var barCompleteButton: UIBarButtonItem!
    @IBOutlet weak var regionPicker: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var imagePicker: ImagePicker?
    private let viewModel = RegistrationViewModel(dataManager: ApiRequests())
    private let bag = DisposeBag()
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorAction = {
            Print.m("У нас тут еррор такто")
            self.viewModel.error.onNext(nil)
        }
        emptyAction = {
            Print.m("Баг тут такого не должно быть")
        }
        
        setupBinds()
        setupImagePicker()
        
        self.viewModel.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setupNavController()
        self.setupScrollKeyboard()
    }
    
    @IBAction func imageTap(_ sender: UITapGestureRecognizer) {
        imagePicker!.present(from: self.view)
    }

}

// MARK: SETUP

extension RegistrationViewController {
    
    func setupBinds() {
        
        viewModel
            .regions
            .bind(to: regionPicker.rx.itemTitles) { _, item in
                return "\(item.name)"
            }
            .disposed(by: bag)
        
        viewModel
            .regions
            .subscribe({ elements in
                guard let regions = elements.element else { return }
                if self.viewModel.choosedRegion.value == nil {
                    self.viewModel.choosedRegion.accept(regions.first)
                }
            })
            .disposed(by: bag)
        
        regionPicker
            .rx
            .modelSelected(RegionMy.self)
            .subscribe({ event in
                guard let regions = event.element else { return }
                self.viewModel.choosedRegion.accept(regions.first)
            })
            .disposed(by: bag)
        
        barCompleteButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .subscribe({ event in
                if !self.fieldsIsEmpty() {
                    let dateOfBirth = self.birthdayPicker.date.getStringOfType(type: .iso8601)
                    let region = self.viewModel.choosedRegion.value!._id
                    let regData = Registration(
                        type: "player",
                        name: self.nameTextField.getTextOrEmptyString(),
                        surName: self.familyTextField.getTextOrEmptyString(),
                        lastName: self.patronymicTextField.getTextOrEmptyString(),
                        login: self.loginTextField.text!,
                        password: self.passwordTF.text!,
                        birthdate: dateOfBirth,
                        region: region)
                    self.viewModel.registration(userData: regData)
                } else {
                    self.viewModel.message.onNext(SingleLineMessage(message: "Заполните все поля"))
                }
            })
            .disposed(by: bag)
        
        viewModel
            .choosedImage
            .observeOn(MainScheduler.instance)
            .subscribe({ element in
                guard let image = element.element else {
                    self.photoImageView.image = UIImage(named: "ic_add_photo")
                    return
                }
                self.photoImageView.image = image?.af_imageRoundedIntoCircle()
            })
            .disposed(by: bag)
        
        viewModel
            .authorizedUser
            .asObserver()
            .subscribeOn(MainScheduler.instance)
            .subscribe({ user_event in
                guard let user = user_event.element else { return }
                self.replaceUserLKVC(authUser: user)
            })
            .disposed(by: bag)
        
        viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.loading)
            .disposed(by: bag)
        
        viewModel
            .error
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.error)
            .disposed(by: bag)
        
        viewModel
            .message
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.message)
            .disposed(by: bag)
    }
    
    func setupImagePicker() {
        self.photoImageView.image = UIImage(named: "ic_add_photo")
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }
    
    func setupScrollKeyboard() {
        scrollView.keyboardDismissMode = .onDrag
        self.view.addGestureRecognizer(UIGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    func setupNavController() {
        self.navigationController?.isNavigationBarHidden = false
        self.barCompleteButton.image =  barCompleteButton.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
    }
    
}

// MARK: HELPER

extension RegistrationViewController {
    
    func fieldsIsEmpty() -> Bool {
        if familyTextField.isEmpty() || nameTextField.isEmpty() || patronymicTextField.isEmpty() || loginTextField.isEmpty() || passwordTF.isEmpty() || viewModel.choosedRegion.value == nil {
            return true
        }
        return false
    }
    
    func replaceUserLKVC(authUser: AuthUser) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "UserNC") as! UINavigationController
        
        let childViewController = viewController.children.first as! UserLKViewController
        childViewController.authUser = authUser
        
        let countOfViewControllers = tabBarController?.viewControllers?.count
        viewController.tabBarItem = tabBarController?.viewControllers![countOfViewControllers! - 1].tabBarItem
        
        tabBarController?.viewControllers![countOfViewControllers! - 1] = viewController
    }
    
}

// MARK: IMAGE PICKER

extension RegistrationViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.viewModel.choosedImage.accept(image)
    }
}

// MARK: - REACTIVE

extension Reactive where Base: RegistrationViewController {
    
    
    
}
