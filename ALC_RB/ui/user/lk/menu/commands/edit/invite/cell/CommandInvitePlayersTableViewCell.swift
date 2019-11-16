//
//  CommandInvitePlayersTableViewCellTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 05.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Alamofire

class CommandInvitePlayersTableViewCell: UITableViewCell {

    struct CellModel {
//        var player: DEPRECATED?
        var person: Person?
        var playerImagePath: String?
        var number: Int = 0
        
        init(person: Person, playerImagePath: String) {
            self.person = person
            self.playerImagePath = playerImagePath
        }
        
        init() {
            person = Person()
            playerImagePath = ""
            number = 0
        }
    }
    
    var cellModel: CellModel? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
//    @IBOutlet weak var playerDeleteBtn: UIButton!
    @IBOutlet weak var playerCommandNum: UILabel!
    
    func updateCell() {
        playerImage.af_setImage(withURL: ApiRoute.getImageURL(image: (cellModel?.playerImagePath)!))
        playerImage.image = playerImage.image?.af_imageRoundedIntoCircle()
        playerName.text = cellModel?.person?.getFullName()
        playerCommandNum.text = String(cellModel!.number)
    }
}
