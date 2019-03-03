//
//  ChangeProfileViewController.swift
//  ALC_RB
//
//  Created by ayur on 27.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ChangeProfileViewController: UIViewController {

    // MARK: - Variables
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var familyTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var patronymicTF: UITextField!
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var barSaveBtn: UIBarButtonItem!
    
    let presenter = ChangeProfilePresenter()
    
    var imagePicker: ImagePicker?
    
    var authUser: AuthUser?
    
    let userDefaultHelper = UserDefaultsHelper()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initPresenter()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        self.familyTF.delegate = self
        self.nameTF.delegate = self
        self.patronymicTF.delegate = self
        self.loginTF.delegate = self
        
        firstInit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        barSaveBtn.image = barSaveBtn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
        
        
    }
    
    // MARK: - First init
    
    func firstInit() {
        self.nameTF.text = authUser?.person.name
        self.familyTF.text = authUser?.person.surname
        self.patronymicTF.text = authUser?.person.lastname
        self.loginTF.text = authUser?.person.login
        presenter.photoProfile(imagePath: (authUser?.person.photo!)!)
    }
    
    // MARK: - Actions
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        presenter.editProfile(token: (authUser?.token)!, profileInfo: EditProfile(
            name: nameTF.text!,
            surname: familyTF.text!,
            lastname: patronymicTF.text!,
            login: loginTF.text!,
            _id: (authUser?.person.id)!), profileImage: imageView.image!)
        print("Save change")
    }
    
    @IBAction func onImagePressed(_ sender: UITapGestureRecognizer) {
        imagePicker?.present(from: self.view)
    }
    
}

extension ChangeProfileViewController: ChangeProfileView {
    func getProfilePhotoSuccessful(image: UIImage) {
        self.imageView.image = image.af_imageRoundedIntoCircle()
    }
    
    func getProfilePhotoFailure(error: Error) {
        Print.d(error)
    }
    
    func changeProfileSuccessful(soloUser: SoloPerson) {
        Print.l()
        var user = self.userDefaultHelper.getAuthorizedUser()
        user?.person = soloUser.person
        self.userDefaultHelper.setAuthorizedUser(user: user!)
        
        self.dismiss(animated: true) {
            Print.d("Dismiss complete")
        }
    }
    
    func changeProfileFailure(error: Error) {
        Print.d(error)
    }
    
    func initPresenter() {
        self.presenter.attachView(view: self)
    }
}

extension ChangeProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imageView.image = image?.af_imageRoundedIntoCircle()
    }
}

extension ChangeProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case familyTF:
            if !familyTF.isEmpty() {
                familyTF.resignFirstResponder()
                break
            }
            showToast(message: "Family field is empty", seconds: 1.0)
        case nameTF:
            if !nameTF.isEmpty() {
                nameTF.resignFirstResponder()
                break
            }
            showToast(message: "First name field is empty", seconds: 1.0)
        case patronymicTF:
            if !patronymicTF.isEmpty() {
                patronymicTF.resignFirstResponder()
                break
            }
            showToast(message: "Patronymic field is empty", seconds: 1.0)
        case loginTF:
            if !loginTF.isEmpty() {
                loginTF.resignFirstResponder()
                break
            }
            showToast(message: "Login field is empty", seconds: 1.0)
        default:
            textField.endEditing(true)
        }
        return true
    }
}
