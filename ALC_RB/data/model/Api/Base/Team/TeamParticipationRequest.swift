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
    
    var team: IdRefObjectWrapper<Team>? = nil
    
    var league: IdRefObjectWrapper<League>? = nil
    
    var status: Status? = nil
    
    init(id: String, team: IdRefObjectWrapper<Team>, league: IdRefObjectWrapper<League>, status: Status) {
        self.id = id
        self.team = team
        self.league = league
        self.status = status
    }
    
    var postMap: [String: Any] {
        get {
            var map = [CodingKeys: Any]()
            map[.team] = team?.getId() ?? team?.getValue()?.id
            map[.league] = league?.getId() ?? league?.getValue()?.id
            return map.get()
        }
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        team = try container.decode(IdRefObjectWrapper<Team>.self, forKey: .team)
//        league = try container.decode(IdRefObjectWrapper<League>.self, forKey: .league)
//        status = try! container.decode(Status.self, forKey: .status)
//    }
    
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
