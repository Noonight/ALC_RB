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
    
    @IBOutlet weak var player_image: UIImageView!
    @IBOutlet weak var player_name: UILabel!
    @IBOutlet weak var player_date_of_birth: UILabel!
    @IBOutlet weak var cell_loading_indicator: UIActivityIndicatorView!
    @IBOutlet weak var cell_loadMore_btn: UIButton!
    @IBOutlet weak var cell_add_player_btn: UIButton!
    
    var usedPlayers: [Player] = []
    
    var person: Person?
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cell_loading_indicator.hidesWhenStopped = true
//        cell_loading_indicator.startAnimating()
    }
    
    func configure(with person: Person?) {
        self.person = person
        if let person = person {
//            if usedPlayers.contains(where: { player -> Bool in
//                return player.playerID == person.id
//            }) {
//                isHidden = true
//            } else {
            player_image.alpha = 1
            player_name.alpha = 1
            player_date_of_birth.alpha = 1
            cell_loadMore_btn.isEnabled = false
            cell_loadMore_btn.alpha = 0
            cell_add_player_btn.alpha = 1
            cell_add_player_btn.isEnabled = true
            //            cell_loading_indicator.stopAnimating()
            if person.photo != nil {
                player_image.af_setImage(withURL: ApiRoute.getImageURL(image: (person.photo)!))
                player_image.image = player_image.image?.af_imageRoundedIntoCircle()
            } else {
                player_image.image = #imageLiteral(resourceName: "ic_logo")
            }
            player_name.text = person.getFullName()
            player_date_of_birth.text = person.birthdate.UTCToLocal(from: .utc, to: .local)
//            }
        } else {
            cell_add_player_btn.alpha = 0
            cell_add_player_btn.isEnabled = false
            player_image.alpha = 0
            player_name.alpha = 0
            player_date_of_birth.alpha = 0
            cell_loadMore_btn.isEnabled = true
            cell_loadMore_btn.alpha = 1
//            cell_loading_indicator.startAnimating()
        }
    }
    
}
