//
//  ChooseRegionCell.swift
//  ALC_RB
//
//  Created by mac on 05.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ChooseRegionCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    static let ID = "choose_region_cell"
    
    var region: RegionMy! {
        didSet {
            self.nameLabel.text = region.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .blue
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
