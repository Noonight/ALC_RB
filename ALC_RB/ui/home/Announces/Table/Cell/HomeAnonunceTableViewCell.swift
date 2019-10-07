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
    
    @IBOutlet weak var text_label: UILabel!
    
    func configure(_ item: Announce) {
        self.text_label.text = item.content
    }
    
}
