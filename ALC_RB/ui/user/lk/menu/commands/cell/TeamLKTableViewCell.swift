//
//  CommandsLKTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 25.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TeamLKTableViewCell: UITableViewCell {

    static let ID = "commands_lk_cell"
    
    @IBOutlet weak var tournamentTitle_label: UILabel!
    @IBOutlet weak var commandTitle_label: UILabel!
    @IBOutlet weak var status_label: UILabel!
    @IBOutlet weak var tournamentDate_label: UILabel!
    @IBOutlet weak var tournamentTransfer_label: UILabel!
    @IBOutlet weak var countOfPlayers_label: UILabel!
    
    var teamModelItem: TeamModelItem {
        didSet {
            self.commandTitle_label.text = self.teamModelItem.name
        }
    }
}
