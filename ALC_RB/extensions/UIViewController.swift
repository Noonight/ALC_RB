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
    
    func showToastHUD(message: String) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        
        hud.mode = MBProgressHUDMode.text
        hud.label.text = message
        
        hud.offset = CGPoint(x: 0.0, y: MBProgressMaxOffset)
        
        return hud
    }
    
    func showLoadingViewHUD(with message: String? = Constants.Texts.LOADING, addTo: UIView) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: addTo, animated: true)
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.backgroundColor = .white
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = hud.backgroundView.backgroundColor
        
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = message
        
        return hud
    }
    
    func showLoadingViewHUD(with message: String? = Constants.Texts.LOADING) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        hud.bezelView.style = .solidColor
        hud.bezelView.color = hud.backgroundView.color
        
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = message
        
        return hud
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showCustomViewHUD(cView: UIView, message: String? = Constants.Texts.NOTHING, detailMessage: String? = Constants.Texts.NOTHING) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        hud.mode = .customView
        hud.customView = cView
        hud.backgroundView.style = .solidColor
        hud.bezelView.style = .solidColor
        
        hud.backgroundView.backgroundColor = .white//cView.backgroundColor ?? .white
        hud.bezelView.backgroundColor = .white//cView.backgroundColor ?? .white
        
        hud.label.text = message
        hud.detailsLabel.text = detailMessage
//        hud.detailsLabel.textColor = .blue
        
        return hud
    }
    
    func showEmptyViewHUD(message: String? = Constants.Texts.NOTHING, detailMessage: String? = Constants.Texts.TAP_FOR_REPEAT, tap: @escaping () -> ()) -> MBProgressHUD {
        let image = #imageLiteral(resourceName: "ic_empty")
        let imageView = UIImageView(image: image)
        if UIDevice.current.orientation.isLandscape {
            imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        else
        {
            imageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        }
        
        let hud = showCustomViewHUD(cView: imageView, message: message, detailMessage: detailMessage)
        
        hud.label.font = UIFont.systemFont(ofSize: 19)
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 17)
        hud.detailsLabel.textColor = .blue
        
        self.tapAction(action: tap)
        
        hud.bezelView.isUserInteractionEnabled = true
        hud.bezelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnHud)))
        
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
}

extension UIViewController : BarButtonItemAddable {}
