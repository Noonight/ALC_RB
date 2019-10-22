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
import Kingfisher

class EditProfileViewController: UIViewController {

    // MARK: - Variables
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var familyTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var patronymicTF: UITextField!
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var barSaveBtn: UIBarButtonItem!
    @IBOutlet weak var regionPicker: UIPickerView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Var & Let
    let presenter = EditProfilePresenter()
    
    var imagePicker: ImagePicker?
    
    var authUser: AuthUser?
    
    let userDefaultHelper = UserDefaultsHelper()
    
    var profileInfoChanged = false
    
    var choosedImage: UIImage? {
        didSet {
            self.imageView.image = self.choosedImage?.af_imageRoundedIntoCircle()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initPresenter()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        self.familyTF.delegate = self
        self.nameTF.delegate = self
        self.patronymicTF.delegate = self
        self.loginTF.delegate = self
        
        scrollView.keyboardDismissMode = .onDrag
        
//        firstInit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        barSaveBtn.image = barSaveBtn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
        
        self.firstInit()
    }
    
    // MARK: - First init
    
    func firstInit() {
        self.nameTF.text = authUser?.person.name
        self.familyTF.text = authUser?.person.surname
        self.patronymicTF.text = authUser?.person.lastname
        self.loginTF.text = authUser?.person.login
        
        datePicker.date = (authUser?.person.birthdate.getDateOfType(type: .GMT))!

        presenter.photoProfile(imagePath: authUser?.person.photo ?? "")
//        if let image = authUser?.person.photo {
//            let url = ApiRoute.getImageURL(image: image)
//            let processor = CroppingImageProcessorCustom(size: self.imageView.frame.size)
//                .append(another: RoundCornerImageProcessor(cornerRadius: self.imageView.getHalfWidthHeight()))
//
//            self.imageView.kf.indicatorType = .activity
//            self.imageView.kf.setImage(
//                with: url,
//                placeholder: UIImage(named: "ic_logo"),
//                options: [
//                    .processor(processor),
//                    .scaleFactor(UIScreen.main.scale),
//                    .transition(.fade(1)),
//                    .cacheOriginalImage
//                ])
//        }
    }
    
    // MARK: - Actions
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        
        let dateOfBirth = datePicker.date.getStringOfType(type: .GMT)
        presenter.editProfile(token: (authUser?.token)!, profileInfo: EditProfile(
            name: nameTF.text!,
            surname: familyTF.text!,
            lastname: patronymicTF.text!,
            login: loginTF.text!,
            _id: (authUser?.person.id)!,
            birthdate: dateOfBirth), profileImage: choosedImage)
        
    }
    
    @IBAction func onImagePressed(_ sender: UITapGestureRecognizer) {
        imagePicker?.present(from: self.view)
    }
}

// MARK: - Presenter view ex methods
extension EditProfileViewController: EditProfileView {
    func showLoadingProfileImage() {
        
    }
    
    func hideLoadingProfileImage() {
        
    }
    
    func getProfilePhotoSuccessful(image: UIImage) {
        self.choosedImage = image.af_imageRoundedIntoCircle()
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
        self.choosedImage = image
//        self.imageView.image = image?.af_imageRoundedIntoCircle()
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
