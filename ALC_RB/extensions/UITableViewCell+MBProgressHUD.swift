//
//  UITableViewCell Extensions.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 30/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UITableViewCell {
    func showLoadingViewHUD() -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
//        hud.bezelView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
//        hud.bezelView.
        hud.mode = MBProgressHUDMode.indeterminate
//        hud.bezelView.frame = CGRect(x: 0, y: 0, width: frame.width / 2, height: frame.height / 2)

        return hud
    }
}
