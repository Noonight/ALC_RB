//
//  TeamLeagueTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TeamLeagueTableViewCell: UITableViewCell {

    @IBOutlet weak var position_label: UILabel!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var games_label: UILabel!
    @IBOutlet weak var rm_label: UILabel!
    @IBOutlet weak var score_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
