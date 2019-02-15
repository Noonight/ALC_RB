//
//  MenuLauncherCell.swift
//  ALC_RB
//
//  Created by mac on 13.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MenuLauncherCell: BaseCell {
    
    var setting: Menu? {
        didSet {
            nameLabel.text = setting?.name
        }
    }

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Menu 1-9"
        label.numberOfLines = 2
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 16))
        
        nameLabel.layoutIfNeeded()
        //backgroundColor = .blue
    }
    
}
