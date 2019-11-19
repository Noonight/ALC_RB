//
//  TeamPlayerInviteStatus.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct TeamPlayerInviteStatus: Codable {
    
    var id: String = ""
    
    var team: IdRefObjectWrapper<Team>? = nil
    var person: IdRefObjectWrapper<Person>? = nil
    
    var status: Status? = nil
    
    var v: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case team
        case person
        
        case v = "__v"
    }
    
    enum Status: String, Codable {
        case pending
        case accepted
        case rejected
        case blocked
        case canceled
    }
}
