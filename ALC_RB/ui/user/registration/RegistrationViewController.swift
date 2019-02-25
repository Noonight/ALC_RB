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
    
    var imagePicker: ImagePicker?
    
    let presenter = RegistrationPresenter()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        barCompleteButton.image =  barCompleteButton.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
        
//        nameTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    // MARK: - Actions
    
    @IBAction func completeRegistration(_ sender: UIBarButtonItem) {
        print("complete registration button pressed")
    }
    
    @IBAction func imageTap(_ sender: UITapGestureRecognizer) {
        imagePicker!.present(from: self.view)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}

// MARK: - Presenter init

extension RegistrationViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
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
        switch textField {
        case familyTextField:
            if !familyTextField.isEmpty() {
                nameTextField.becomeFirstResponder()
                break
            }
            showToast(message: "Family field is empty", seconds: 1.0)
        case nameTextField:
            if !nameTextField.isEmpty() {
                patronymicTextField.becomeFirstResponder()
                break
            }
            showToast(message: "First name field is empty", seconds: 1.0)
        case patronymicTextField:
            if !patronymicTextField.isEmpty() {
                loginTextField.becomeFirstResponder()
                break
            }
            showToast(message: "Patronymic field is empty", seconds: 1.0)
        case loginTextField:
            if !loginTextField.isEmpty() {
                passwordTF.becomeFirstResponder()
                break
            }
            showToast(message: "Login field is empty", seconds: 1.0)
        case passwordTF:
            if !passwordTF.isEmpty() {
                passwordTF.resignFirstResponder()
                break
            }
            showToast(message: "Password field is empty", seconds: 1.0)
        default:
            textField.endEditing(true)
        }
        return true
    }
}
