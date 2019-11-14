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
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.makeKeyAndVisible()
//        self.window?.backgroundColor = .white
//
//        let rootViewController = MainTabBarViewController()
//        self.window?.rootViewController = rootViewController
        
//        let leagueApi = LeagueApi()
//
//        leagueApi.get_league(
//            params: ParamBuilder<League.CodingKeys>()
//                .select(
//                    StrBuilder()
//                        .add(.id)
//                )
//                .add(key: .status, value: League.Status.started.ck)
//                .get()
//        ) { result in
//            switch result {
//            case .success(let leagues):
//                dump(leagues)
//            case .message(let message):
//                Print.m(message.message)
//            case .failure(.error(let error)):
//                Print.m(error)
//            case .failure(.notExpectedData):
//                Print.m("not expected data")
//            }
//        }
        
        let matchApi = MatchApi()

        matchApi.get_upcomingMatches { result in
            switch result {
            case .success(let upcomingMatches):
                dump(upcomingMatches)
            case .message(let message):
                Print.m(message.message)

            case .failure(.error(let error)):
                Print.m(error)

            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
        
        return true
    } // for xcode 10+
    
    func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
}

