//
//  CreateClub.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 25/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct CreateClub {
    var name = ""
    var info = ""
    var owner = ""
    // logo: image
    
    init(name: String, info: String, owner: String) {
        self.name = name
        self.info = info
        self.owner = owner
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields.name.value() : self.name,
            Fields.info.value() : self.info,
            Fields.owner.value() : self.owner
        ]
    }
    
    func fieldsIsEmpty() -> Bool {
        if (name.isEmpty || info.isEmpty || owner.isEmpty) {
            return true
        }
        return false
    }
    
    enum Fields: String {
        case name = "name"
        case info = "info"
        case owner = "owner"
        
        func value() -> String {
            return self.rawValue
        }
    }
}

