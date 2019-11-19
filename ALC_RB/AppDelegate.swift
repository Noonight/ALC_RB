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
import RealmSwift

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
//        LocalTourneys().deleteLocalTourneys()
//        UserDefaultsHelper().deleteAuthorizedUser()
//        let realm = DBHelper().getRealm()
//        let realm = try! Realm()
//        if realm.isEmpty == false {
//            let tourneys = realm.objects(TourneyRealm.self)
//
//            if tourneys.count != 0 {
//                tourneys.elements.forEach({ Print.m($0) })
//            }
//        }
//
//        var tourneyDB = TourneyRealm()
//        tourneyDB.players.append(IdRefObjectWrapper<Person>(Person()).toData())
////        tourneyDB.players.append("id id")
//        try! realm.write {
//            realm.add(tourneyDB)
//        }
//
////        if tourneys.count != 0 {
//            realm.objects(TourneyRealm.self).elements.forEach({ Print.m($0) })
////        }
        
        let tourneyApi = TourneyApi()
        tourneyApi.get_tourney(params: ParamBuilder<Tourney.CodingKeys>().populate(.creator).get()) { result in
            switch result {
            case .success(let tourneys):
                dump(tourneys)
                let en = try! JSONEncoder.init().encode(tourneys)
                Print.m(en)
                Print.m(try! JSONDecoder().decode([Tourney].self, from: en))
//                for i in tourneys {
//                    Print.m(i.toTourneyRealm())
//                }
                
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

