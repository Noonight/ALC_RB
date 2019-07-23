//
//  RegistrationViewController.swift
//  ALC_RB
//
//  Created by ayur on 21.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    enum Texts {
        static let FILL_ALL_FIELDS = "Заполните все поля"
    }
    
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
    
    // MARK: Var & Let
    
    var choosedImage: UIImage? {
        didSet {
            self.photoImageView.image = self.choosedImage?.af_imageRoundedIntoCircle()
        }
    }
    
    var imagePicker: ImagePicker?
    
    let presenter = RegistrationPresenter()
    
    var authUser: AuthUser?
    
    let userDefaultsHelper = UserDefaultsHelper()
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPresenter()
        self.setupScrollKeyboard()
        self.setupTextFields()
        self.setupImagePicker()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setupNavController()
        self.setupScrollKeyboard()
    }
    
    // MARK: SETUP
    
    func setupTextFields() {
        self.familyTextField.delegate = self
        self.nameTextField.delegate = self
        self.patronymicTextField.delegate = self
        self.loginTextField.delegate = self
        self.passwordTF.delegate = self
    }
    func setupImagePicker() {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }
    func setupPresenter() {
        self.initPresenter()
    }
    func setupScrollKeyboard() {
        scrollView.keyboardDismissMode = .onDrag
        self.view.addGestureRecognizer(UIGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    func setupNavController() {
        self.navigationController?.isNavigationBarHidden = false
        self.barCompleteButton.image =  barCompleteButton.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
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
                birthdate: dateOfBirth), profileImage: self.choosedImage)
        } else {
            showAlert(message: Texts.FILL_ALL_FIELDS)
        }
    }
    
    @IBAction func imageTap(_ sender: UITapGestureRecognizer) {
        imagePicker!.present(from: self.view)
    }
    
    // MARK: - Helpers

    func fieldsIsEmpty() -> Bool {
        if familyTextField.isEmpty() || nameTextField.isEmpty() || patronymicTextField.isEmpty() || loginTextField.isEmpty() || passwordTF.isEmpty() {
            return true
        }
        return false
    }

}

// MARK: - PRESENTER

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
        viewController.tabBarItem = tabBarController?.viewControllers![countOfViewControllers! - 1].tabBarItem
        
        tabBarController?.viewControllers![countOfViewControllers! - 1] = viewController
    }
}

// MARK: IMAGE PICKER

extension RegistrationViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
//        photoImageView.image = image?.af_imageRoundedIntoCircle()
        self.choosedImage = image
    }
}

// MARK: TEXT FIELDS

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
