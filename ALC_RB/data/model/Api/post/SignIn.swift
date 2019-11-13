//
//  PostModels.swift
//  ALC_RB
//
//  Created by ayur on 26.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct SignIn {
    var login = " "
    var password = " "
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
    
    enum Fields: String {
        case login = "login"
        case password = "password"
        
        func value() -> String {
            return self.rawValue
        }
    }
}
