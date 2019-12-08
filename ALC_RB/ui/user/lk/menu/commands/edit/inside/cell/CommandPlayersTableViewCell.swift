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
    
    var playerStatus: Player! {
        didSet {
            if let imagePath = self.playerStatus.person?.getValue()?.photo {
                playerImage.kfLoadRoundedImage(path: imagePath)
            }
            if let name = self.playerStatus.person?.getValue()?.getSurnameNP() {
                playerNameLabel.text = name
            }
            if let number = self.playerStatus.number {
                playerNumberTextField.text = String(number)
            }
        }
    }
    
//    @IBAction func onPlayerNumberTextEdit(_ sender: UITextField) {
//        guard let newNumber = sender.text else { return }
//        playerStatus.number = Int(newNumber)
//        playerNumberTextDidEndProtocol?.onEditNumberComplete(model: playerStatus)
//    }
    @IBAction func onPlayerNumberDidEndChanged(_ sender: UITextField) {
//        Print.m("did end changed")
//        guard let newNumber = sender.text else { return }
//        playerStatus.number = Int(newNumber)
//        playerNumberTextDidEndProtocol?.onEditNumberComplete(model: playerStatus)
    }
    
    @IBAction func onPlayerNumberDidEnd(_ sender: UITextField) {
//        Print.m("did end")
        guard let newNumber = sender.text else { return }
        playerStatus.number = Int(newNumber)
        playerNumberTextDidEndProtocol?.onEditNumberComplete(model: playerStatus)
    }
}
