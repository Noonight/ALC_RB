//
//  ChoosePersonCell.swift
//  ALC_RB
//
//  Created by ayur on 28.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ChoosePersonCell: UITableViewCell {

    static let ID = "choose_person_cell"
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    
    var personModelItem: PersonModelItem! {
        didSet {
            if let photo = self.personModelItem.photoPath {
                self.personImageView.kfLoadRoundedImage(path: photo)
            }
            self.nameLabel.text = self.personModelItem.fullName
            if let birthdate = self.personModelItem.birthDate {
                self.birthdateLabel.text = "\(birthdate) \(self.personModelItem.birthTime!)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
