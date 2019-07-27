//
//  UIViewController.swift
//  ALC_RB
//
//  Created by ayur on 22.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showToast(message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func showToast(message : String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            alert.dismiss(animated: true)
        }
    }
    
    func showLoadingViewHUD(with message: String? = Constants.Texts.LOADING) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.5)
        
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = message
        
        return hud
    }
    
    func hideLoadingHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
