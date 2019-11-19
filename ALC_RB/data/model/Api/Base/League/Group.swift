//
//  Group.swift
//  ALC_RB
//
//  Created by mac on 13.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Group: Codable {
    
    var id: String?
    
    var teams: [IdRefObjectWrapper<Team>]?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        
        case teams = "teams"
        case name = "name"
    }
}
