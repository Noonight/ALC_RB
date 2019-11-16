//
//  Team.swift
//  ALC_RB
//
//  Created by mac on 13.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Team: Codable {
    
    var id: String

    var name: String? = nil
    
    var league: IdRefObjectWrapper<League>? = nil

    var creator: IdRefObjectWrapper<Person>? = nil
    var trainer: IdRefObjectWrapper<Person>? = nil

    var creatorPhone: String? = nil
    
    var players: [TeamPlayersStatus]? = nil // TODO: m.b. it's have to work with IdRefObjectWrapper
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case name
        
        case league
        
        case creator
        case trainer
        
        case creatorPhone
        
        case players
    }
}

extension Team {
    
    init() {
        id = ""
        league = nil
        creator = nil
        trainer = nil
        creatorPhone = nil
        players = nil
    }
}
