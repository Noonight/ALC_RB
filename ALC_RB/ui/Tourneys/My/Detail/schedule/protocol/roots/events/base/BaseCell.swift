//
//  BaseCell.swift
//  ALC_RB
//
//  Created by ayur on 14.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not be implemented")
    }
}
