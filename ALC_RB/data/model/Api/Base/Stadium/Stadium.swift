//
//  Stadium.swift
//  ALC_RB
//
//  Created by mac on 14.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Stadium: Codable {
    
    var id: String
    
    var name: String?
    var address: String?
    var tourney: IdRefObjectWrapper<Tourney>?
    
    var createdAt: Date?
    var updatedAt: Date?
    
    var v: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        
        case name
        case address
        case tourney
        
        case createdAt
        case updatedAt
        
        case v = "__v"
        
    }
}
