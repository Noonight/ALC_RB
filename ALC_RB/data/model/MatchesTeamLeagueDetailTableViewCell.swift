//
//  MatchesTeamLeagueDetailTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 30.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MatchesTeamLeagueDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var mDate: UILabel!
    @IBOutlet weak var mTime: UILabel!
    @IBOutlet weak var mTour: UILabel!
    @IBOutlet weak var mPlace: UILabel!
    @IBOutlet weak var mImageTeam1: UIImageView!
    @IBOutlet weak var mTitleTeam1: UILabel!
    @IBOutlet weak var mScore: UILabel!
    @IBOutlet weak var mTitleTeam2: UILabel!
    @IBOutlet weak var mImageTeam2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
