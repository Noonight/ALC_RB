//
//  CommandAddPlayerTableViewCell.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 24/04/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import AlamofireImage
//import SwiftDate
import Kingfisher

class CommandAddPlayerTableViewCell: UITableViewCell {
    
    enum Status {
        case invitedIn(String)
        case plyedIn(String)
        case notUsed
    }
    
    @IBOutlet weak var player_image: UIImageView!
    @IBOutlet weak var player_name: UILabel!
    @IBOutlet weak var player_date_of_birth: UILabel!
    @IBOutlet weak var player_status: UILabel!
    
    @IBOutlet weak var cell_add_player_btn: UIButton!
    
    var usedPlayers: [Person] = []
    
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
            
            if let image = person.photo {
                
                let url = ApiRoute.getImageURL(image: image)
                let processor = CroppingImageProcessorCustom(size: self.player_image.frame.size)
                    .append(another: RoundCornerImageProcessor(cornerRadius: self.player_image.getHalfWidthHeight()))
                
                self.player_image.kf.indicatorType = .activity
                self.player_image.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "ic_logo"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
            } else {
                self.player_image.image = UIImage(named: "ic_logo")
            }
            player_name.text = person.getSurnameNP()
            
            self.setupPlayerDateOfBirth(player: person)
            
            self.setStatus(player: person, status: status)
            
        } else {
            cell_add_player_btn.alpha = 0
            cell_add_player_btn.isEnabled = false
            player_image.alpha = 0
            player_name.alpha = 0
            player_date_of_birth.alpha = 0
        }
    }
    
    func setStatus(player: Person, status: Status) {
        switch status {
        case .invitedIn(let string):
            self.player_status.textColor = UIColor.green
            
            self.player_status.text = string
            self.player_date_of_birth.text = ""
            
        case .plyedIn(let string):
            self.player_status.textColor = UIColor.blue
            self.player_status.text = string
            self.player_date_of_birth.text = ""
        case .notUsed:
            self.setupPlayerDateOfBirth(player: player)
            self.player_status.text = ""
        }
    }
    
    func setupPlayerDateOfBirth(player: Person) {
        self.player_date_of_birth.text = player.birthdate!.toFormat(DateFormats.local.rawValue)
    }
}
