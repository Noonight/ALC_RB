//
//  RegistrationViewController.swift
//  ALC_RB
//
//  Created by ayur on 21.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    // MARK: - Variables
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var familyTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var barCompleteButton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imagePicker: ImagePicker?
    
    let presenter = RegistrationPresenter()
    
    var authUser: AuthUser?
    
    let userDefaultsHelper = UserDefaultsHelper()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        familyTextField.delegate = self
        nameTextField.delegate = self
        patronymicTextField.delegate = self
        loginTextField.delegate = self
        passwordTF.delegate = self
        
        scrollView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        barCompleteButton.image =  barCompleteButton.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
        
        self.view.addGestureRecognizer(UIGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    // MARK: - Actions
    
    @IBAction func completeRegistration(_ sender: UIBarButtonItem) {
        if (!self.fieldsIsEmpty()) {
            let dateOfBirth = birthdayPicker.date.getStringOfType(type: .GMT)
            presenter.registration(userData: Registration(
                type: "player",
                name: nameTextField.getTextOrEmptyString(),
                surName: familyTextField.getTextOrEmptyString(),
                lastName: patronymicTextField.getTextOrEmptyString(),
                login: loginTextField.text!,
                password: passwordTF.text!,
                birthdate: dateOfBirth), profileImage: photoImageView.image ?? UIImage())
        } else {
            showToast(message: "Заполните все поля")
        }
    }
    
    @IBAction func imageTap(_ sender: UITapGestureRecognizer) {
        imagePicker!.present(from: self.view)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Helpers

    func fieldsIsEmpty() -> Bool {
        if familyTextField.isEmpty() || nameTextField.isEmpty() || patronymicTextField.isEmpty() || loginTextField.isEmpty() || passwordTF.isEmpty() {
            return true
        }
        return false
    }

}

// MARK: - Presenter init

extension RegistrationViewController: RegistrationView {
    func registrationMessage(message: SingleLineMessage) {
        showAlert(title: message.message, message: "")
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
    
    func registrationComplete(authUser: AuthUser) {
        self.userDefaultsHelper.deleteAuthorizedUser()
        self.userDefaultsHelper.setAuthorizedUser(user: authUser)
        
        Print.d(object: authUser)
        
        replaceUserLKVC(authUser: authUser)
    }
    
    func registrationError(error: Error) {
        showAlert(message: error.localizedDescription)
        Print.d(object: error)
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
}

// MARK: - Image picker delegate

extension RegistrationViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        photoImageView.image = image?.af_imageRoundedIntoCircle()
    }
}

// MARK: - Text field delegate

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case familyTextField:
//            if !familyTextField.isEmpty() {
//                nameTextField.becomeFirstResponder()
//                break
//            }
//            showToast(message: "Family field is empty", seconds: 1.0)
//        case nameTextField:
//            if !nameTextField.isEmpty() {
//                patronymicTextField.becomeFirstResponder()
//                break
//            }
//            showToast(message: "First name field is empty", seconds: 1.0)
//        case patronymicTextField:
//            if !patronymicTextField.isEmpty() {
//                loginTextField.becomeFirstResponder()
//                break
//            }
//            showToast(message: "Patronymic field is empty", seconds: 1.0)
//        case loginTextField:
//            if !loginTextField.isEmpty() {
//                passwordTF.becomeFirstResponder()
//                break
//            }
//            showToast(message: "Login field is empty", seconds: 1.0)
//        case passwordTF:
//            if !passwordTF.isEmpty() {
//                passwordTF.resignFirstResponder()
//                break
//            }
//            showToast(message: "Password field is empty", seconds: 1.0)
//        default:
//            textField.endEditing(true)
//        }
        textField.endEditing(true)
        return true
    }
}
