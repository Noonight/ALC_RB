//
//  NewsTableViewCell.swift
//  ALC_RB
//
//  Created by user on 29.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell { // 💩

    @IBOutlet weak var content: UILabel?
    @IBOutlet weak var date: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
