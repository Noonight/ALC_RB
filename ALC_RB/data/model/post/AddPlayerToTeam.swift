//
//  AddPlayerToTeam.swift
//  ALC_RB
//
//  Created by ayur on 11.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct AddPlayerToTeam {
    
    var _id = ""
    var teamId = ""
    var playerId = ""
    
    init(_id: String, teamId: String, playerId: String) {
        self._id = _id
        self.teamId = teamId
        self.playerId = playerId
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields._id.value() : self._id,
            Fields.teamId.value() : self.teamId,
            Fields.playerId.value() : self.playerId
        ]
    }
    
    enum Fields: String {
        case _id = "_id"
        case teamId = "teamId"
        case playerId = "playerId"
        
        func value() -> String {
            return self.rawValue
        }
    }
}
