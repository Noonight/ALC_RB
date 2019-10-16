//
//  MyTourneyCell.swift
//  ALC_RB
//
//  Created by ayur on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MyTourneyCell: UITableViewCell {

    static let ID = "my_tourney_cell"
    
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    
    var leagueModelItem: LeagueModelItem! {
        didSet {
            self.name_label.text = leagueModelItem.name
            self.date_label.text = (leagueModelItem.beginDate ?? "") + " - " + (leagueModelItem.endDate ?? "")
        }
    }
    
}
