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
    
    func showButtonHUD(btn: @escaping () -> ()) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        
        hud.label.text = Constants.Texts.REPEAT
        
//        hud.mode = .determinate
//
//        hud.button.addTarget(self, action: #selector(tapOnHud(closure: {
//            btn()
//        })), for: .touchUpInside)
//        hud.button.addTarget
        
        self.tapAction(action: btn)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnHud))
        hud.addGestureRecognizer(tap)
        
        return hud
    }
    
    @objc private func tapOnHud() {
        self.tapAction()
    }
    
    private func tapAction(action: (() -> ())? = nil) {
        struct __ { static var action :(() -> Void)? }
        if action != nil { __.action = action }
        else { __.action?() }
    }
    
    func showMessageHUD(message: String) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        
        hud.mode = MBProgressHUDMode.text
        hud.label.text = message
        
        return hud
    }
    
    func showLoadingViewHUD(with message: String? = Constants.Texts.LOADING) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = message
        
        return hud
    }
    
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }
        
        return lastIndexPath == indexPath
    }
    
}
