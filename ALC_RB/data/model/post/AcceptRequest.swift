//
//  AcceptRequest.swift
//  ALC_RB
//
//  Created by ayur on 12.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct AcceptRequest {
    var idLeague = ""
    var idTeam = ""
    var status = ""
    
    init(idLeague: String, idTeam: String, status: Status) {
        self.idLeague = idLeague
        self.idTeam = idTeam
        self.status = status.rawValue
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields.idLeague.value() : self.idLeague,
            Fields.idTeam.value() : self.idTeam,
            Fields.status.value() : self.status
        ]
    }
    
    enum Status: String {
        case accpeted = "Accepted"
        case rejected = "Rejected"
    }
    
    enum Fields: String {
        case idLeague = "_id"
        case idTeam = "teamId"
        case status = "status"
        
        func value() -> String {
            return self.rawValue
        }
    }
}
