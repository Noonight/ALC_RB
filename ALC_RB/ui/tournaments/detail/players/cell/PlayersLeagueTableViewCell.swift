//
//  PlayersLeagueTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 06.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class PlayersLeagueTableViewCell: UITableViewCell {

    @IBOutlet weak var photo_img: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var games_label: UILabel!
    @IBOutlet weak var goals_label: UILabel!
    @IBOutlet weak var yellow_cards_label: UILabel!
    @IBOutlet weak var red_cards_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
