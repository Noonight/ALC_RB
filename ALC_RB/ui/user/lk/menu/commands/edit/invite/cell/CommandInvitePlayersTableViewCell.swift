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
    
    static let ID = "command_invite_players_cell"

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerCommandNum: UILabel!
    
    var playerInviteStatus: TeamPlayerInviteStatus! {
        didSet {
            if let imagePath = self.playerInviteStatus.person?.getValue()?.photo {
                playerImage.kfLoadRoundedImage(path: imagePath)
            }
            playerName.text = self.playerInviteStatus.person?.getValue()?.getSurnameNP()
//            playerName.text = "\(self.playerInviteStatus.person!.getValue()!.name!) \(self.playerInviteStatus.status!)"
        }
    }
}
