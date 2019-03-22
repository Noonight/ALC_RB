//
//  ClubEditLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 19.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ClubEditLKViewController: UIViewController {

    // MARK: - Variables
    
    @IBOutlet weak var clubImage_image: UIImageView!
    @IBOutlet weak var clubTitle_label: UITextField!
    @IBOutlet weak var clubDescription_textView: UITextView!
    @IBOutlet weak var saveBarBtn_save: UIBarButtonItem!
    
    let presenter = ClubEditLKPresenter()
    
    var club: Club? {
        didSet {
            updateUI()
        }
    }
    
    var imagePicker: ImagePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        saveBarBtn_save.image = saveBarBtn_save.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
    }
    
    func updateUI() {
        if club != nil {
            
        } else {
            showToast(message: "Что-то пошло не так. Ошибка!")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func saveBarBtnPressed(_ sender: UIBarButtonItem) {
        
    }
}

extension ClubEditLKViewController : ClubEditLKView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

extension ClubEditLKViewController : ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        clubImage_image.image = image?.af_imageRoundedIntoCircle()
    }
}
