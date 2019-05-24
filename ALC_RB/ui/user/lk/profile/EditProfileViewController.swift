//
//  ChangeProfileViewController.swift
//  ALC_RB
//
//  Created by ayur on 27.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileViewController: UIViewController {

    // MARK: - Variables
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var familyTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var patronymicTF: UITextField!
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var barSaveBtn: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let presenter = EditProfilePresenter()
    
    var imagePicker: ImagePicker?
    
    var authUser: AuthUser?
    
    let userDefaultHelper = UserDefaultsHelper()
    
    var profileInfoChanged = false
    
    // MARK: - Trash Variables
    var trashImageView: UIImage?
    var trashFamily: String?
    var trashName: String?
    var trashPatronymic: String?
    var trashLogin: String?
    var trashDatePicker: String?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initPresenter()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        self.familyTF.delegate = self
        self.nameTF.delegate = self
        self.patronymicTF.delegate = self
        self.loginTF.delegate = self
        
        prepareRxFields()
        
        scrollView.keyboardDismissMode = .onDrag
        
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
        
        datePicker.date = (authUser?.person.birthdate.getDateOfType(type: .GMT))!

        presenter.photoProfile(imagePath: authUser?.person.photo ?? "")
    }
    
    func prepareRxFields() {
//        datePicker.rx
//            .controlEvent(UIControlEvents.editingDidEnd)
//            .asObservable()
//            .subscribe(onNext: <#T##((()) -> Void)?##((()) -> Void)?##(()) -> Void#>, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//        nameTF.rx
//            .controlEvent(UIControlEvents.editingDidEnd)
//            .asObservable()
//            .subscribe { (onNext) in
//                self.profileInfoChanged = true
//            }
//
    }
    
    // MARK: - Actions
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        
        checkFieldsIsChanged()
        
        let dateOfBirth = datePicker.date.getStringOfType(type: .GMT)
        presenter.editProfile(token: (authUser?.token)!, profileInfo: EditProfile(
            name: nameTF.text!,
            surname: familyTF.text!,
            lastname: patronymicTF.text!,
            login: loginTF.text!,
            _id: (authUser?.person.id)!,
            birthdate: dateOfBirth), profileImage: imageView.image!)
        if profileInfoChanged {
            
        }
        
    }
    
    @IBAction func onImagePressed(_ sender: UITapGestureRecognizer) {
        imagePicker?.present(from: self.view)
    }
    
    func checkFieldsIsChanged() {
        
    }
}

// MARK: - Presenter view ex methods
extension EditProfileViewController: EditProfileView {
    func showLoadingProfileImage() {
        
    }
    
    func hideLoadingProfileImage() {
        
    }
    
    func getProfilePhotoSuccessful(image: UIImage) {
        self.imageView.image = image.af_imageRoundedIntoCircle()
    }
    
    func getProfilePhotoFailure(error: Error) {
        Print.d(error: error)
        if self.authUser?.person.photo == nil || self.authUser?.person.photo?.count ?? 0 < 2 {
            self.imageView.image = UIImage(named: "ic_add_photo")
        }
        
    }
    
    func changeProfileSuccessful(editedProfile: SoloPerson) {
        
        var user = self.userDefaultHelper.getAuthorizedUser()
        user?.person = editedProfile.person
        self.userDefaultHelper.setAuthorizedUser(user: user!)
        
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) {
            Print.d(message: "Dismiss complete")
        }
    }
    
    func changeProfileFailure(error: Error) {
        Print.d(error: error)
    }
    
    func initPresenter() {
        self.presenter.attachView(view: self)
    }
}

extension EditProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imageView.image = image?.af_imageRoundedIntoCircle()
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case familyTF:
//            if !familyTF.isEmpty() {
//                familyTF.resignFirstResponder()
//                break
//            }
//            showToast(message: "Family field is empty", seconds: 1.0)
//        case nameTF:
//            if !nameTF.isEmpty() {
//                nameTF.resignFirstResponder()
//                break
//            }
//            showToast(message: "First name field is empty", seconds: 1.0)
//        case patronymicTF:
//            if !patronymicTF.isEmpty() {
//                patronymicTF.resignFirstResponder()
//                break
//            }
//            showToast(message: "Patronymic field is empty", seconds: 1.0)
//        case loginTF:
//            if !loginTF.isEmpty() {
//                loginTF.resignFirstResponder()
//                break
//            }
//            showToast(message: "Login field is empty", seconds: 1.0)
//        default:
//            textField.endEditing(true)
//        }
        textField.endEditing(true)
        return true
    }
}
