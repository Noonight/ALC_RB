//
//  Advertising.swift
//  ALC_RB
//
//  Created by ayur on 28.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class Advertising: NSObject {
    
    let blackView = UIView()
    
    let adView = AdView()
    
    var adImage: UIImage?
    var adText: String?
    
    init (adImage: UIImage, adText: String) {
        self.adImage = adImage
        self.adText = adText
    }
    
    func showAd() {
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)

            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideAd)))
            window.addSubview(blackView)
            blackView.addSubview(adView)
            
            adView.setCenterFromParent()
            adView.containerView.setCenterFromParent()
            adView.closeFunction = hideAd
            
            adView.advertisingText.text = adText
            adView.advertisingImage.image = adImage
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
            }, completion: nil)
        }
    }
    
    @objc func hideAd() {
        Print.m("hide btn action")
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
//                window.isHidden = true
            }
        }
    }
    
}
