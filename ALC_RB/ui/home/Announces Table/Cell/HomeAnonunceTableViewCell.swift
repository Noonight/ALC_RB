//
//  HomeAnonunceTableViewCell.swift
//  ALC_RB
//
//  Created by mac on 20.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class HomeAnonunceTableViewCell: UITableViewCell {
    
    static let ID = "home_announce_table_cell"
    
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var text_label: UILabel!
    
    func configure(_ item: AnnounceElement) {
        self.date_label.text = item.date.toDate()?.toFormat(DateFormats.local.rawValue)
        self.text_label.text = item.content
    }
    
}
