//
//  Registration.swift
//  ALC_RB
//
//  Created by ayur on 28.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Registration {
    var type = ""
    var name = ""
    var surName = ""
    var lastName = ""
    var login = ""
    var password = ""
    
    init(type: String, name: String, surName: String, lastName: String, login: String, password: String) {
        self.type = type
        self.name = name
        self.surName = surName
        self.lastName = lastName
        self.login = login
        self.password = password
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields.type.value() : self.type,
            Fields.name.value() : self.name,
            Fields.surname.value() : self.surName,
            Fields.lastname.value() : self.lastName,
            Fields.login.value() : self.login,
            Fields.password.value() : self.password
        ]
    }
    
    enum Fields: String {
        case type = "type"
        case name = "name"
        case surname = "surname"
        case lastname = "lastname"
        case login = "login"
        case password = "password"
        
        func value() -> String {
            return self.rawValue
        }
    }
}
