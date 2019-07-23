//
//  ClubCreateViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 24/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ClubCreateViewController: BaseStateViewController
{
    enum Variables {
        static let successfulMessage = "Клуб создан!"
    }
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var imagePicker: ImagePicker?
    private let userDefaults = UserDefaultsHelper()
    private var presenter = ClubCreatePresenter(dataManager: ApiRequests())
    
    // image holder, hidden
    private var tmpImage: UIImage?
    private var choosedImage: UIImage? {
        didSet {
            self.logoImage.image = self.choosedImage?.af_imageRoundedIntoCircle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        nameLabel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }
    
    @IBAction func setImageTap(_ sender: Any) {
        imagePicker?.present(from: self.view)
    }
    
    @IBAction func onSavePressed(_ sender: UIBarButtonItem) {
        presenter.create(
            token: userDefaults.getAuthorizedUser()!.token,
            createClub: CreateClub(
                name: nameLabel.text ?? "",
                info: descriptionText.text ?? "",
                owner: userDefaults.getAuthorizedUser()?.person.id ?? ""
            ),
            image: choosedImage
        )
    }
}

// MARK: - MVP Protocol
extension ClubCreateViewController: ClubCreateProtocol {
    func fieldsIsEmpty() {
        showAlert(message: "Заполните все поля")
    }
    
    func responseCreateClubSuccessful(soloClub: SoloClub) {
        var user = userDefaults.getAuthorizedUser()
        user?.person.club = soloClub.club.id
        userDefaults.setAuthorizedUser(user: user!)
//        showToast(message: Variables.successfulMessage)
        self.showAlert(title: Variables.successfulMessage, message: "")
//        navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true) {
            Print.m("View controller no anymore")
        }
    }
    
    func responseCreateClubMessageSuccessful(message: SingleLineMessage) {
        showAlert(message: message.message)
    }
    
    func responseCreateClubFailure(error: Error) {
        Print.m(error)
        showRepeatAlert(message: error.localizedDescription) {
            self.presenter.create(
                token: (self.userDefaults.getAuthorizedUser()?.token)!,
                createClub: (self.presenter.createClubCache!.createClub)!,
                image: self.choosedImage)
        }
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
//        presenter = ClubCreatePresenter(dataManager: ApiRequests())
    }
}

extension ClubCreateViewController {
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
    }
}

extension ClubCreateViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension ClubCreateViewController : ImagePickerDelegate
{
    func didSelect(image: UIImage?) {
        if let image = image {
//            self.logoImage.image = image
//            self.logoImage.cropAndRound()
//            self.tmpImage = image
            self.choosedImage = image
        }
    }
}
