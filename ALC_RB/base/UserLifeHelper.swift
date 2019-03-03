//
//  UserLifeHelper.swift
//  ALC_RB
//
//  Created by ayur on 03.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class UserLifeHelper {
    static let userDefaults = UserDefaultsHelper()
    
    static func userIsAuthorized() -> Bool {
        return userDefaults.userIsAuthorized()
    }
    
    static func initView(authUser: @escaping () -> (), notAuthUser: @escaping () -> () ) {
        if userIsAuthorized() {
            authUser()
        } else {
            notAuthUser()
        }
    }
    
}
