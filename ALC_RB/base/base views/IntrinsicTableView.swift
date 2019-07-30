//
//  IntrinsicTableView.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 30/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class IntrinsicTableView : UITableView {
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
