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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        saveBarBtn_save.image = saveBarBtn_save.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
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
