//
//  TeamPlayerStatus.swift
//  ALC_RB
//
//  Created by ayur on 16.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct TeamPlayersStatus: Codable {
    
    var id: String
    
    var team: IdRefObjectWrapper<Team>? = nil
    var person: IdRefObjectWrapper<Person>? = nil
    var league: IdRefObjectWrapper<League>? = nil
    
    // player number
    var number: Int? = nil
    var played: Bool? = nil
    var activeYellowCards: Int? = nil
    var activeDisquals: Int? = nil
    
    var postMap: [String: Any] {
        get {
            var map = [CodingKeys: Any]()
            map[.id] = id
            map[.team] = team?.getId() ?? team?.getValue()?.id
            map[.person] = person?.getId() ?? person?.getValue()?.id
            map[.league] = league?.getId() ?? league?.getValue()?.id
            map[.number] = number
            map[.played] = played
            map[.activeYellowCards] = activeYellowCards
            map[.activeDisquals] = activeDisquals
            return map.get()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case team
        case person
        case league
        
        case number
        case played
        case activeYellowCards
        case activeDisquals
    }
    
}
