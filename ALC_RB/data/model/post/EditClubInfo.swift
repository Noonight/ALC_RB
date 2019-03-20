//
//  ChangeProfile.swift
//  ALC_RB
//
//  Created by ayur on 01.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct EditClubInfo {
    var name = ""
    var _id = ""
    var info = ""
    
    init(name: String, _id: String, info: String) {
        self.name = name
        self._id = _id
        self.info = info
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields.name.value() : self.name,
            Fields._id.value() : self._id,
            Fields.info.value() : self.info
        ]
    }
    
    enum Fields: String {
        case name = "name"
        case _id = "_id"
        case info = "info"
        
        func value() -> String {
            return self.rawValue
        }
    }
}
