//
//  UIView + MBProgressHUD.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 24.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIView {
    
    // MARK: TOAST
    
    func showToastHUD(message: String) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        
        hud.mode = MBProgressHUDMode.text
        hud.label.text = message
        
        hud.offset = CGPoint(x: 0.0, y: MBProgressMaxOffset)
        
        return hud
    }
    
    // MARK: LOADING
    
    func showLoadingViewHUD(with message: String? = Constants.Texts.LOADING) -> MBProgressHUD {
        MBProgressHUD.hide(for: self, animated: false)
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        
        hud.mode = MBProgressHUDMode.indeterminate
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.bezelView.style = .solidColor
        hud.backgroundView.color = .white
        hud.bezelView.color = .white
        
        hud.label.text = message
        
        return hud
    }
    // MARK: HIDE
    func hideHUD() {
        MBProgressHUD.hide(for: self, animated: true)
    }
    
    // MARK: CUSTOM
    func showCustomViewHUD(cView: UIView, to: UIView, message: String? = Constants.Texts.NOTHING, detailMessage: String? = Constants.Texts.NOTHING) -> MBProgressHUD {
        MBProgressHUD.hide(for: to, animated: false)
        let hud = MBProgressHUD.showAdded(to: to, animated: true)
        
        hud.mode = .customView
        hud.customView = cView
        hud.backgroundView.style = .solidColor
        hud.bezelView.style = .solidColor
        
        hud.backgroundView.backgroundColor = .white//cView.backgroundColor ?? .white
        hud.bezelView.backgroundColor = .white//cView.backgroundColor ?? .white
        
        hud.label.text = message
        hud.detailsLabel.text = detailMessage
        
        return hud
    }
    
    func showCustomViewHUD(cView: UIView, message: String? = Constants.Texts.NOTHING, detailMessage: String? = Constants.Texts.NOTHING) -> MBProgressHUD {
        MBProgressHUD.hide(for: self, animated: false)
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        
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
    
    
    // MARK: FAILURE
    func showFailureViewHUD(message: String? = "", detailMessage: String? = Constants.Texts.FAILURE, tap: @escaping () -> ()) -> MBProgressHUD
    {
        let image = #imageLiteral(resourceName: "ic_warning")
        let imageView = UIImageView(image: image)
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let hud = showCustomViewHUD(cView: imageView, message: message, detailMessage: detailMessage)
        
        hud.label.font = UIFont.systemFont(ofSize: 19)
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        //            hud.detailsLabel.textColor = .blue
        
        self.tapAction(action: tap)
        
        hud.bezelView.isUserInteractionEnabled = true
        hud.bezelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnHud)))
        
        return hud
    }
    
    
    // MARK: EMPTY
    func showEmptyViewHUD(addTo: UIView, message: String? = "", detailMessage: String? = "") -> MBProgressHUD {
        let image = #imageLiteral(resourceName: "ic_empty")
        let imageView = UIImageView(image: image)
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let hud = showCustomViewHUD(cView: imageView, to: addTo, message: message, detailMessage: detailMessage)
        
        hud.label.font = UIFont.systemFont(ofSize: 19)
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.detailsLabel.textColor = .blue
        
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
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.detailsLabel.textColor = .blue
        
        self.tapAction(action: tap)
        
        hud.bezelView.isUserInteractionEnabled = true
        hud.bezelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnHud)))
        
        return hud
    }
     // MARK: HELPER ACTIONS
     @objc private func tapOnHud() {
         self.tapAction()
     }
     
     private func tapAction(action: (() -> ())? = nil) {
         struct __ { static var action :(() -> Void)? }
         if action != nil { __.action = action }
         else { __.action?() }
     }
    
}

