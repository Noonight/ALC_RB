//
//  AppDelegate.swift
//  ALC_RB
//
//  Created by user on 21.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setupIQKeyboardManager()
        self.setupKingfisher()
        return true
    } // for xcode 10+
    
    func setupKingfisher() {
//        ImageCache.default.memoryStorage.config.expiration = .seconds(30)
//        ImageCache.default.memoryStorage.config
    }
    
    func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        return true
//    }
}

