//
//  PlayerTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 19.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mBirthDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
