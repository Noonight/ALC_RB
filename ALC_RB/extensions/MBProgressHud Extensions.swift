//
//  MBProgressHud Extensions.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import MBProgressHUD

extension MBProgressHUD {
    
    func setToSuccessWith(message: String? = Constants.Texts.SUCCESS, detailMessage: String? = "")// -> MBProgressHUD
    {
        self.setToCustomView(with: UIImageView(image: UIImage(named: "hud_checkmark")), message: message)
        
        self.detailsLabel.text = detailMessage
    }
    
    func setToFailureWith(message: String? = Constants.Texts.FAILURE, detailMessage: String? = "")// -> MBProgressHUD
    {
        self.setToCustomView(with: UIImageView(image: UIImage(named: "hud_cross")), message: message)
        
        if let curDetailMessage = detailMessage {
            self.detailsLabel.text = curDetailMessage
        } else {
            self.detailsLabel.text = nil
        }
    }
    
    func setDetailMessage(with detailMessage: String)
    {
        self.detailsLabel.text = detailMessage
    }
    
    func hideAfter(seconds: Int = 1)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds), execute: {
            self.hide(animated: true)
        })
    }
    // -------------
    func showSuccessAfterAndHideAfter(showAfter: Int = 1, hideAfter: Int = 1, withMessage: String? = Constants.Texts.SUCCESS)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(showAfter), execute: {
            self.setToSuccessWith(message: withMessage)
            self.hideAfter(seconds: hideAfter)
        })
    }
    // -------------
    func setToCustomView(with view: UIView, message: String? = "", detailMessage: String? = "")// -> MBProgressHUD
    {
        mode = .customView
        
        customView = view
        backgroundView.style = .solidColor
        bezelView.style = .solidColor
        
        backgroundView.backgroundColor = .white//cView.backgroundColor ?? .white
        bezelView.backgroundColor = .white//cView.backgroundColor ?? .white
        
        label.text = message
        detailsLabel.text = detailMessage
        
    }
    
    func setToEmptyView(message: String? = Constants.Texts.NOTHING, detailMessage: String? = Constants.Texts.TAP_FOR_REPEAT, tap: @escaping () -> ())
    {
        let image = #imageLiteral(resourceName: "ic_empty")
        let imageView = UIImageView(image: image)
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        setToCustomView(with: imageView)
        
        label.font = UIFont.systemFont(ofSize: 19)
        detailsLabel.font = UIFont.systemFont(ofSize: 15)
        detailsLabel.textColor = .blue
        
        self.tapAction(action: tap)
        
        bezelView.isUserInteractionEnabled = true
        bezelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnHud)))
        
    }
    
    func setToLoadingView(message: String? = Constants.Texts.LOADING, detailMessage: String? = "")
    {
        mode = .indeterminate
        
        backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        backgroundView.color = .white
        bezelView.style = .solidColor
        bezelView.color = backgroundView.color
        
        label.text = message
        detailsLabel.text = detailMessage
    }
    
    func setToFailureView(message: String? = "", detailMessage: String? = Constants.Texts.FAILURE, tap: @escaping () -> ())
    {
        let image = #imageLiteral(resourceName: "ic_warning")
        let imageView = UIImageView(image: image)
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        setToCustomView(with: imageView)
        
        label.font = UIFont.systemFont(ofSize: 19)
        detailsLabel.font = UIFont.systemFont(ofSize: 15)
//        detailsLabel.textColor = .blue
        
        self.tapAction(action: tap)
        
        bezelView.isUserInteractionEnabled = true
        bezelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnHud)))
        
    }
    
    // also hide after 1 second
    
    func setToButtonHUD(message: String? = Constants.Texts.REPEAT, detailMessage: String? = "", btn: @escaping () -> ()) {
        self.backgroundView.style = .solidColor
        self.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        
        self.label.text = message
        self.detailsLabel.text = detailMessage
        
        self.tapAction(action: btn)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnHud))
        self.addGestureRecognizer(tap)
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
