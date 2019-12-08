//
//  TeamProtocolTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 11.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

protocol EditTeamProtocolPlayerSwitchValueChanged {
    func switchValueChanged(model: PlayerSwitchModelItem)
}

class EditTeamProtocolCell: UITableViewCell {

    static let ID = "team_protocol_cell"
    
    @IBOutlet weak var photo_image: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var position_label: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    var switchChangedProtocol: EditTeamProtocolPlayerSwitchValueChanged?
    
    var playerSwitchModel: PlayerSwitchModelItem! {
        didSet {
            if let imagePath = self.playerSwitchModel.person.photoPath {
                self.photo_image.kfLoadRoundedImage(path: imagePath)
            }
            self.name_label.text = self.playerSwitchModel.person.fullNameNP
//            self.position_label.text = String(self.playerSwitchModel.player)
            self.switcher.isOn = self.playerSwitchModel.isRight
            
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        Print.m("switch value changed \(sender.isOn)")
        self.playerSwitchModel.isRight = sender.isOn
        self.switchChangedProtocol?.switchValueChanged(model: self.playerSwitchModel)
    }
    
}
