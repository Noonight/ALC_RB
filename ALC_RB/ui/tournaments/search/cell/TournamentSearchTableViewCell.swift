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
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var count_of_teams_label: UILabel!
    
    static let ID = "tournament_search_cell_id"
    
    var tourneyModelItem: TourneyModelItem! {
        didSet {
            self.title_label.text = tourneyModelItem?.name
            if tourneyModelItem.beginDate?.toFormat(DateFormats.local.rawValue) != nil && tourneyModelItem.endDate?.toFormat(DateFormats.local.rawValue) != nil
            {
                self.date_label.text = (tourneyModelItem.beginDate?.toFormat(DateFormats.local.rawValue) ?? "") + " - " + (tourneyModelItem.endDate?.toFormat(DateFormats.local.rawValue) ?? "")
            }
            else
            {
                self.date_label.text = ""
            }
            self.count_of_teams_label.text = String(tourneyModelItem.countOfTeams ?? 0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.accessoryType = selected ? .checkmark : .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.accessoryType = self.tourneyModelItem.isSelected ? .checkmark : .none
    }
}
