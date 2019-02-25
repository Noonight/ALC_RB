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
    
    let presenter = AuthPresenter()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension AuthViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            if loginTextField.isEmpty() {
                showToast(message: "Login field is empty", seconds: 1.0)
            } else {
                passwordTextField.becomeFirstResponder()
            }
        case passwordTextField:
            if passwordTextField.isEmpty() {
                showToast(message: "Password field is empty", seconds: 1.0)
            } else {
                passwordTextField.resignFirstResponder()
                // start sign in function
            }
        default:
            textField.endEditing(true)
        }
        return true
    }
}
