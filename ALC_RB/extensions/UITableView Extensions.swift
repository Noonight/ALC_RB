//
//  UITableView Extensions.swift
//  ALC_RB
//
//  Created by ayur on 28.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UITableView {
    
    func showLoadingViewHUD(with message: String? = Constants.Texts.LOADING) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = message
        
        return hud
    }
    
}
