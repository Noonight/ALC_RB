//
//  LoadingCell.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 22/05/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    enum NibParams {
        static let nibName = "LoadingCell"
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
