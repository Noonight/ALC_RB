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
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionText: UITextView!

    private var imagePicker: ImagePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func setImageTap(_ sender: Any) {
        showRefreshAlert(message: "Tyt rabotaet") {
            // tyt tozhe
        }
    }
    

}

extension ClubCreateViewController : ImagePickerDelegate
{
    func didSelect(image: UIImage?) {
        if let image = image {
            self.logoImage.image = image
            self.logoImage.cropAndRound()
        }
    }
}
