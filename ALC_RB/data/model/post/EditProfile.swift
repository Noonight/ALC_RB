//
//  ChangeProfile.swift
//  ALC_RB
//
//  Created by ayur on 01.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct EditProfile {
    var name = ""
    var surname = ""
    var lastname = ""
    var login = ""
    var _id = ""
    var birthdate = ""
    
    init(name: String, surname: String, lastname: String, login: String, _id: String, birthdate: String) {
        self.name = name
        self.surname = surname
        self.lastname = lastname
        self.login = login
        self._id = _id
        self.birthdate = birthdate
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields.name.value() : self.name,
            Fields.surname.value() : self.surname,
            Fields.lastname.value() : self.lastname,
            Fields.login.value() : self.login,
            Fields._id.value() : self._id,
            Fields.birthdate.value() : self.birthdate
        ]
    }
    
    enum Fields: String {
        case name = "name"
        case surname = "surname"
        case lastname = "lastname"
        case login = "login"
        case _id = "_id"
        case birthdate = "birthdate"
        
        func value() -> String {
            return self.rawValue
        }
    }
}
