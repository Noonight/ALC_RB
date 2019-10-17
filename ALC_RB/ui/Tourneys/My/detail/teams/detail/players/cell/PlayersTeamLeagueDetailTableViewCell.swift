//
//  PlayersTeamLeagueDetailTableViewCell.swift
//  ALC_RB
//
//  Created by mac on 22.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class PlayersTeamLeagueDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var games: UILabel!
    @IBOutlet weak var goals: UILabel!
    @IBOutlet weak var yellow_cards: UILabel!
    @IBOutlet weak var disqualifications: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
