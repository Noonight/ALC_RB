//
//  TournamentTableViewCell.swift
//  ALC_RB
//
//  Created by user on 27.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class TournamentTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var commandNum: UILabel!
    @IBOutlet weak var status: UILabel!
    
    static let ID = "cell_tournament"
    
    func configure(league: League) {
        if league.tourney?.contains(".") == true
        {
            self.title.text = league.tourney! + league.name!
        }
        else
        {
            self.title.text = league.tourney! + ". " + league.name!
        }
        
        self.commandNum.text = String(league.maxTeams!)
        if league.status == "Finished" {
            img?.image = UIImage(named: "ic_fin")
            status.isHidden = false
        } else {
            status.isHidden = true
        }
        
        guard let beginDate = league.beginDate?.toDate()?.toFormat(DateFormats.local.rawValue) else { return }
        guard let endDate = league.endDate?.toDate()?.toFormat(DateFormats.local.rawValue) else { return }
        self.date.text = (beginDate) + " - " + (endDate)
    }

}
