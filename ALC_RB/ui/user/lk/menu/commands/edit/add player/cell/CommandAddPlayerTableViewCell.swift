//
//  CommandAddPlayerTableViewCell.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 24/04/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import AlamofireImage

class CommandAddPlayerTableViewCell: UITableViewCell {
    
    enum Status {
        case invited(String)
        case notUsed
    }
    
    @IBOutlet weak var player_image: UIImageView!
    @IBOutlet weak var player_name: UILabel!
    @IBOutlet weak var player_date_of_birth: UILabel!
    @IBOutlet weak var player_status: UILabel!
    
    @IBOutlet weak var cell_add_player_btn: UIButton!
    
    var usedPlayers: [Player] = []
    
    var person: Person?
    var status: Status?
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with person: Person?, status: Status) {
        self.person = person
        if let person = person {
            player_image.alpha = 1
            player_name.alpha = 1
            player_date_of_birth.alpha = 1
            cell_add_player_btn.alpha = 1
            cell_add_player_btn.isEnabled = true
            if person.photo != nil {
                player_image.af_setImage(withURL: ApiRoute.getImageURL(image: (person.photo)!))
                player_image.image = player_image.image?.af_imageRoundedIntoCircle()
            } else {
                player_image.image = #imageLiteral(resourceName: "ic_logo")
            }
            player_name.text = person.getFullName()
            if person.birthdate.count != 0 {
                player_date_of_birth.text = person.birthdate.UTCToLocal(from: .GMT, to: .local)
            } else {
                player_date_of_birth.text = ""
            }
            
//            player_date_of_birth.text = person.birthdate.to
            self.setStatus(status: status)
            
        } else {
            cell_add_player_btn.alpha = 0
            cell_add_player_btn.isEnabled = false
            player_image.alpha = 0
            player_name.alpha = 0
            player_date_of_birth.alpha = 0
        }
    }
    
    func setStatus(status: Status) {
        switch status {
        case .invited(let string):
            if string == "В вашей команде" {
                self.player_status.textColor = UIColor.green
            } else {
                self.player_status.textColor = UIColor.blue
            }
            self.player_status.text = string
        case .notUsed:
            self.player_status.text = ""
        }
    }
    
}
