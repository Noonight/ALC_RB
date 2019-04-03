//
//  ClubEditLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 19.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ClubEditLKViewController: BaseStateViewController {

    // MARK: - Variables
    
    @IBOutlet weak var clubImage: UIImageView!
    @IBOutlet weak var clubTitle_label: UITextField!
    @IBOutlet weak var clubDescription_textView: UITextView!
    @IBOutlet weak var saveBarBtn_save: UIBarButtonItem!
    
    let presenter = ClubEditLKPresenter()
    
    var club: Club?
    
    var imagePicker: ImagePicker?
    
    let userDefaults = UserDefaultsHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        updateUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        saveBarBtn_save.image = saveBarBtn_save.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
    }
    
    @objc func onImagePressed() {
        
    }
    
    func updateUI() {
        if let club = club {
            clubTitle_label.text = club.name
            clubDescription_textView.text = club.info
            presenter.getClubLogo(byPath: club.logo ?? "")
        } else {
            showToast(message: "Что-то пошло не так. Ошибка!")
        }
//        if club != nil {
//            clubTitle_label.text = club?.name
//            clubDescription_textView.text = club?.info
//            presenter.getClubLogo(byPath: club?.logo ?? "")
//        } else {
//            showToast(message: "Что-то пошло не так. Ошибка!")
//        }
    }
    
    // MARK: - Actions
    
    @IBAction func saveBarBtnPressed(_ sender: UIBarButtonItem) {
//        Print.m("save btn pressed yeah!!")
        presenter.editClubInfo(
            token: (userDefaults.getAuthorizedUser()?.token)!,
            clubInfo: EditClubInfo(
                name: clubTitle_label.text!,
                _id: (userDefaults.getAuthorizedUser()?.person.club!)!,
                info: clubDescription_textView.text!),
            image: clubImage.image!)
    }

    @IBAction func onImageAreaPressed(_ sender: UITapGestureRecognizer) {
//        Print.m("image pressed")
        imagePicker?.present(from: self.view)
    }
    
}

extension ClubEditLKViewController : ClubEditLKView {
    func editClubInfoSuccess(soloClub: SoloClub) {
        self.club = soloClub.club
        updateUI()
        dismiss(animated: true) {
            Print.m("Dismiss view controller")
        }
    }
    
    func editClubInfoFailure(error: Error) {
        Print.m(error)
        showToast(message: "Ошибка что - то пошло не так!")
    }
    
    func getClubLogoSuccess(image: UIImage) {
        clubImage.image = image.af_imageRoundedIntoCircle()
    }
    
    func getClubLogoFailure(error: Error) {
        Print.d(error: error)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

extension ClubEditLKViewController : ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        clubImage.image = image?.af_imageRoundedIntoCircle()
    }
}