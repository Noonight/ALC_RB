//
//  CommandPlayersTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Alamofire

class CommandPlayersTableViewCell: UITableViewCell {

    struct CellModel {
        var player: Player?
        var person: Person?
        var playerImagePath: String?
        var number: Int = 0
        
        init(player: Player, playerImagePath: String, person: Person) {
            self.player = player
            self.playerImagePath = playerImagePath
            self.person = person
        }
        
        init() {
            player = Player()
            person = Person()
            playerImagePath = ""
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
//    @IBOutlet weak var playerDeleteBtn: UIButton!
    
    private func updateCell() {
        playerImage.af_setImage(withURL: ApiRoute.getImageURL(image: (cellModel?.playerImagePath)!))
        playerImage.image = playerImage.image?.af_imageRoundedIntoCircle()
//        playerImage.image = cellModel?.playerImage?.af_imageRoundedIntoCircle()
        playerNameLabel.text = cellModel?.person?.getFullName()
        playerNumberTextField.text = cellModel?.player?.number
        let strNumber: String = String(cellModel!.number)
        playerCommandNumLabel.text = strNumber
    }
}
