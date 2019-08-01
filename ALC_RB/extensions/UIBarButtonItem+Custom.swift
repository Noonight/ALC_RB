//
//  UIBarButtonItem+Custom.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 01/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    enum  BarButtonItemType:Int {
        case info
        case document
//        case back
//        case backOrange
//        case next
//        case nextOrange
//        case restore
    }
    
        convenience init(type:BarButtonItemType, target:Any, action:Selector)
        {
            var imageName:String = ""
            
            switch type {
            case .info:
                imageName = "ic_info"
            case .document:
                imageName = "ic_document"
            }
            
            let button = UIButton()
            
            if let image = UIImage(named: imageName) {
                var curImage = image
                curImage = curImage.af_imageAspectScaled(toFit: Constants.Sizes.NAV_BAR_ICON_SIZE)
                button.setImage(curImage, for: UIControl.State.normal)
            }
//            print("\(#line)")
//            button.addTarget(target, action: action, for: .touchUpInside)
            button.sizeToFit()
            
            button.addTarget(target, action: action, for: .touchUpInside)
            
            self.init(customView:button)
        }
    
    
//    static func q_infoButton(action: Selector) -> UIBarButtonItem {
//        let btn = UIBarButtonItem(image: Constants.Images.Q_INFO, style: .plain, target: self, action: action)
//        btn.image = btn.image?.af_imageAspectScaled(toFit: Constants.Sizes.NAV_BAR_ICON_SIZE)
//        return btn
//    }
}

protocol BarButtonItemAddable {}

extension BarButtonItemAddable where Self:NSObject {
    
    func barButtonItem(type: UIBarButtonItem.BarButtonItemType, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(type: type, target: self, action: action)
    }
}
