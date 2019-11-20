//
//  TeamParticipationRequest.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 20.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TeamParticipationRequest: Codable {
    
    var id: String
    
    var team: IdRefObjectWrapper<Team>?
    
    var league: IdRefObjectWrapper<League>?
    
    var status: Status?
    
    var postMap: [String: Any] {
        get {
            var map = [CodingKeys: Any]()
            map[.team] = team?.getId() ?? team?.getValue()?.id
            map[.league] = league?.getId() ?? league?.getValue()?.id
            return map.get()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case team
        
        case league
        
        case status
    }
    
    enum Status: String, Codable {
        case pending
        case accepted
        case rejected
        case canceled
    }
}
