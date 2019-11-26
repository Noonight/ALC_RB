//
//  CommandInvitePlayersTableViewCellTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 05.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class CommandInvitePlayersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerCommandNum: UILabel!
    
    var playerInviteStatus: TeamPlayerInviteStatus! {
        didSet {
            playerImage.kfLoadRoundedImage(path: (self.playerInviteStatus.person?.getValue()?.photo)!)
            playerName.text = self.playerInviteStatus.person?.getValue()?.name
        }
    }
}
