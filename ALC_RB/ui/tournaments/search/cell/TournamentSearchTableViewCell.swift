//
//  TournamentSearchTableViewCell.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 04/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

class TournamentSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var status_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var count_of_teams_label: UILabel!
    
    static let ID = "tournament_search_cell_id"
    
    func configure(tournament: Tournaments) {
//        self.title_label.text = tournament.name
//        if tournament.status ==
        
//        guard let beginDate = tournament.beginDate.toDate()?.toFormat(DateFormats.local.rawValue) else { return }
//        guard let endDate = tournament.endDate.toDate()?.toFormat(DateFormats.local.rawValue) else { return }
//        self.date_label.text = beginDate + " - " + endDate
//        self.count_of_teams_label.text = String(tournament.maxTeams)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
