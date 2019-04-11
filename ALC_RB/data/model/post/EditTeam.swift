//
//  EditTeam.swift
//  ALC_RB
//
//  Created by ayur on 11.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct EditTeam {
    
    var _id = ""
    var teamId = ""
    var players: [Player] = []
    
    init(_id: String, teamId: String, players: [Player]) {
        self._id = _id
        self.teamId = teamId
        self.players = players
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields._id.value() : self._id,
            Fields.teamId.value() : self.teamId,
            Fields.players.value() : self.players
        ]
    }

    enum Fields: String {
        case _id = "_id"
        case teamId = "teamId"
        case players = "players"
        
        func value() -> String {
            return self.rawValue
        }
    }
    
}
