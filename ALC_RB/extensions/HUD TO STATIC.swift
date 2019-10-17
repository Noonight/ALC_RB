//
//  UIViewController + static var.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 17.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    private struct HUD {
        static var _hud = [String: MBProgressHUD]()
    }
    
    var hud: MBProgressHUD? {
        get {
            return HUD._hud[self.debugDescription]
        }
        set(newValue) {
            HUD._hud[self.debugDescription] = newValue
        }
    }
    
}

extension UIView {
    
    private struct HUD {
        static var _hud = [String: MBProgressHUD]()
    }
    
    var hud: MBProgressHUD? {
        get {
            return HUD._hud[self.debugDescription]
        }
        set(newValue) {
            HUD._hud[self.debugDescription] = newValue
        }
    }
    
}
