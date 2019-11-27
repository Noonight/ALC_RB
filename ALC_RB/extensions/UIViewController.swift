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
    
    // MARK: Alert Controller
    
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
    
    // MARK: MBProgressHUD
    
    
    
    // MARK: TOAST
    
    func showToastHUD(message: String) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        
        hud.mode = MBProgressHUDMode.text
        hud.label.text = message
        
        hud.offset = CGPoint(x: 0.0, y: MBProgressMaxOffset)
        
        return hud
    }
    
    // MARK: LOADING
    
    func showLoadingViewHUD(with message: String? = Constants.Texts.LOADING, addTo: UIView? = nil) -> MBProgressHUD {
        var hud: MBProgressHUD!
        if addTo != nil {
            MBProgressHUD.hide(for: addTo!, animated: false)
            hud = MBProgressHUD.showAdded(to: addTo!, animated: true)
            
            // if view is tableview
            if let tableView = addTo as? UITableView {
                tableView.separatorStyle = .none
                hud = MBProgressHUD.showAdded(to: UIView(frame: tableView.frame), animated: true)
                hud.layer.zPosition = 100
            }
        } else {
            MBProgressHUD.hide(for: self.view, animated: false)
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            if let tableView = self.view as? UITableView {
                tableView.separatorStyle = .none
                hud.layer.zPosition = 100
            }
            
            // if some of subviews is tableview
            if let tableView = self.view.subviews.filter({ subView -> Bool in
                return subView is UITableView
            }).first as? UITableView {
                tableView.separatorStyle = .none
                hud.layer.zPosition = 100
            }
        }
        
        hud.mode = .indeterminate

        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = .white
        hud.bezelView.style = .solidColor
        hud.bezelView.color = hud.backgroundView.color
        
        hud.label.text = message
        
        return hud
    }
    
    // MARK: HIDE
    
    func hideHUD(forView: UIView? = nil) {
        if forView != nil {
            MBProgressHUD.hide(for: forView!, animated: true)
            
            if let tableView = forView as? UITableView {
//                tableView.isHidden = false
//                tableView.sectionHeaderHeight = 100
                tableView.separatorStyle = .singleLine
            }
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let tableView = self.view as? UITableView {
//                tableView.isHidden = false
//                tableView.sectionHeaderHeight = 100
                tableView.separatorStyle = .singleLine
            }

            if let tableView = self.view.subviews.filter({ subView -> Bool in
                return subView is UITableView
            }).first as? UITableView {
//                tableView.isHidden = false
//                tableView.sectionHeaderHeight = 100
                tableView.separatorStyle = .singleLine
            }
        }
    }
    // MARK: - SUCCESS -> CLOSURE
    
    func showSuccessViewHUD(addTo: UIView? = nil, message: String? = Constants.Texts.COMPLETED, seconds: Int, closure: @escaping () -> ()) {
        if let mView = addTo {
            let hud = MBProgressHUD.showAdded(to: mView, animated: true)
            
            hud.mode = .customView
            let successImage = UIImage(named: "hud_checkmark")
            hud.customView = UIImageView(image: successImage)
            
//            hud.isSquare = true
            
            hud.label.text = message
            
            hud.hideAfter(seconds: seconds) {
                closure()
            }
        }
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        hud.mode = .customView
        let successImage = UIImage(named: "hud_checkmark")
        hud.customView = UIImageView(image: successImage)
        
//        hud.isSquare = true
        
        hud.label.text = message
        
        hud.hideAfter(seconds: seconds) {
            closure()
        }
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
        MBProgressHUD.hide(for: self.view, animated: false)
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
    
    func showCustomViewHUD(cView: UIView, addTo: UIView, message: String? = Constants.Texts.NOTHING, detailMessage: String? = Constants.Texts.NOTHING) -> MBProgressHUD {
        MBProgressHUD.hide(for: addTo, animated: false)
        let hud = MBProgressHUD.showAdded(to: addTo, animated: true)
        
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
        
        imageView.widthAnchor.constraint(equalToConstant: Constants.Values.ALERT_SIZE).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.Values.ALERT_SIZE).isActive = true
        
        let hud = showCustomViewHUD(cView: imageView, message: message, detailMessage: detailMessage)
        
        hud.label.font = UIFont.systemFont(ofSize: 19)
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        //            hud.detailsLabel.textColor = .blue
        
        self.tapAction(action: tap)
        
        hud.bezelView.isUserInteractionEnabled = true
        hud.bezelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnHud)))
        
        return hud
    }
    
    func showFailureViewHUD(addTo: UIView, message: String? = "", detailMessage: String? = Constants.Texts.FAILURE, tap: @escaping () -> ()) -> MBProgressHUD
    {
        let image = #imageLiteral(resourceName: "ic_warning")
        let imageView = UIImageView(image: image)
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let hud = showCustomViewHUD(cView: imageView, addTo: addTo, message: message, detailMessage: detailMessage)
        
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
    
    func showEmptyViewHUD(addTo: UIView, message: String? = Constants.Texts.NOTHING, detailMessage: String? = Constants.Texts.TAP_FOR_REPEAT, tap: @escaping () -> ()) -> MBProgressHUD {
        let image = #imageLiteral(resourceName: "ic_empty")
        let imageView = UIImageView(image: image)
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let hud = showCustomViewHUD(cView: imageView, to: addTo, message: message, detailMessage: detailMessage)
        
        hud.label.font = UIFont.systemFont(ofSize: 19)
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.detailsLabel.textColor = .blue
        
        self.tapAction(action: tap)
        
        hud.bezelView.isUserInteractionEnabled = true
        hud.bezelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnHud)))
        
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
    // MARK: SCROLL VIEW KEYBOARD
    func registerForKeyboardWillShowNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: keyboardSize.height, right: scrollView.contentInset.right)

            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?(keyboardSize)
        })
    }

    func registerForKeyboardWillHideNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: 0, right: scrollView.contentInset.right)

            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?(keyboardSize)
        })
    }
}

extension UIViewController : BarButtonItemAddable {}
