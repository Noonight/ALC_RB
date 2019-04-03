//
//  CommandPlayersTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CommandPlayersTableViewCell: UITableViewCell {

    struct CellModel {
        var player: Player?
        var person: Person?
        var playerImage: UIImage?
        
        init(player: Player, playerImage: UIImage, person: Person) {
            self.player = player
            self.playerImage = playerImage
            self.person = person
        }
        
        init() {
            player = Player()
            person = Person()
            playerImage = UIImage(named: "ic_logo2")
        }
    }
    
    var cellModel: CellModel? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerNumberTextField: UITextField!
    @IBOutlet weak var playerCommandNumLabel: UILabel!
    @IBOutlet weak var playerDeleteBtn: UIButton!
    
    private func updateCell() {
        playerImage.image = cellModel?.playerImage?.af_imageRoundedIntoCircle()
        playerNameLabel.text = cellModel?.person?.getFullName()
        playerNumberTextField.text = cellModel?.player?.number
    }

    @IBAction func onPlayerDeleteBtnPressed(_ sender: UIButton) {
        Print.m("on Delete btn pressed!!!")
    }
}
