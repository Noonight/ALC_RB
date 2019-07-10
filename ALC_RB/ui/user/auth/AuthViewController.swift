//
//  AuthViewController.swift
//  ALC_RB
//
//  Created by ayur on 21.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let presenter = AuthPresenter()
    
    let userDefaultHelper = UserDefaultsHelper()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        if userDefaultHelper.userIsAuthorized() {
            replaceUserLKVC(authUser: userDefaultHelper.getAuthorizedUser()!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        
//        self.view.addGestureRecognizer(UIGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        
//        self.backgroundImage.addGestureRecognizer(UIGestureRecognizer(target: self.backgroundImage, action: Selector("endEditing:")))
    }
    
    // MARK: - Actions
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        signIn()
        //authorizationComplete(authUser: AuthUser())
    }

    // MARK: - logic
    
    func signIn() {
        if !fieldsIsEmpty() {
            presenter.signIn(userData: SignIn(
                login: loginTextField.text!,
                password: passwordTextField.text!)
            )
        } else {
            showToast(message: "Заполните все поля")
        }
        
    }
    
    func fieldsIsEmpty() -> Bool {
        if loginTextField.isEmpty() || passwordTextField.isEmpty() {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension AuthViewController: AuthView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
    
    func authorizationComplete(authUser: AuthUser) {
//
//        do {
//            try UserDefaults().set(object: authUser, forKey: "authUser")
//        } catch {
//            print("error with set data about user from UserDefaults")
//        }
        
        userDefaultHelper.deleteAuthorizedUser()
        userDefaultHelper.setAuthorizedUser(user: authUser)
        
        replaceUserLKVC(authUser: authUser)
    }
    
    func replaceUserLKVC(authUser: AuthUser) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "UserNC") as! UINavigationController
        
        let childViewController = viewController.children.first as! UserLKViewController
        childViewController.authUser = authUser
        
        let countOfViewControllers = tabBarController?.viewControllers?.count
        //        _ = tabBarController?.selectedViewController
        tabBarController?.viewControllers![countOfViewControllers! - 1] = viewController
    }
    
    func authorizationError(error: Error) {
        showAlert(message: error.localizedDescription)
//        showToast(message: "Неверные данные", seconds: 3.0)
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
//            if loginTextField.isEmpty() {
//                showToast(message: "Login field is empty", seconds: 1.0)
//            } else {
//                passwordTextField.becomeFirstResponder()
//            }
            textField.endEditing(true)
        case passwordTextField:
//            if passwordTextField.isEmpty() {
//                showToast(message: "Password field is empty", seconds: 1.0)
//            } else {
//                passwordTextField.resignFirstResponder()
//                signIn()
//                // start sign in function
//            }
            textField.endEditing(true)
        default:
            textField.endEditing(true)
        }
        return true
    }
}
