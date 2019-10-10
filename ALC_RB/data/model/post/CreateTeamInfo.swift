//
//  CreateTeamInfo.swift
//  ALC_RB
//
//  Created by ayur on 29.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct CreateTeamInfo {
    var name = ""
    var _id = "" // tournament id
//    var club = ""
//    var creator = ""
    
    init(name: String, _id: String/*, club: String, creator: String*/) {
        self.name = name
        self._id = _id
//        self.club = club
//        self.creator = creator
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields.name.value() : self.name,
            Fields._id.value() : self._id//,
//            Fields.club.value() : self.club,
//            Fields.creator.value() : self.creator
        ]
    }
    
    enum Fields: String {
        case name = "name"
        case _id = "_id"
//        case creator = "creator"
//        case club = "club"
        
        func value() -> String {
            return self.rawValue
        }
    }
}
