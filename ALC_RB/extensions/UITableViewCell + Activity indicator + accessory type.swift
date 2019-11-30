//
//  UITableViewCell + Activity indicator + accessory type.swift
//  ALC_RB
//
//  Created by ayur on 01.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    func showAccessoryLoading(indicatorStyle: UIActivityIndicatorView.Style = .gray) {
        let activityIndicator = UIActivityIndicatorView(style: indicatorStyle)
        activityIndicator.startAnimating()
        accessoryType = .none
        accessoryView = activityIndicator
    }
    
    func hideAccessoryLoading(accessoryType: AccessoryType = .none) {
        accessoryView = nil
        self.accessoryType = accessoryType
    }
    
}
