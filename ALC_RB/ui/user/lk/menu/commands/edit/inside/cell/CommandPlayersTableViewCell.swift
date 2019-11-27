//
//  CommandPlayersTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class CommandPlayersTableViewCell: UITableViewCell {
    
    static let ID = "command_player_cell"
    
    var playerNumberTextDidEndProtocol: TeamPlayerEditProtocol?
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerNumberTextField: UITextField!
    @IBOutlet weak var playerCommandNumLabel: UILabel!
    
    var playerStatus: TeamPlayersStatus! {
        didSet {
            if let imagePath = self.playerStatus.person?.getValue()?.photo {
                playerImage.kfLoadRoundedImage(path: imagePath)
            }
            playerNameLabel.text = self.playerStatus.person?.getValue()?.name
            if let number = self.playerStatus.number {
                playerNumberTextField.text = String(number)
            }
        }
    }
    
    @IBAction func onPlayerNumberTextEditComplete(_ sender: UITextField) {
        playerNumberTextDidEndProtocol?.onEditNumberComplete(model: playerStatus)
    }
    
}
