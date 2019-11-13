//
//  Stage.swift
//  ALC_RB
//
//  Created by mac on 13.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

// MARK: - _Stage
struct Stage: Codable {
    
    enum sType: String, Codable {
        case groupStage = "group_stage"
        case stage = "stage"
    }
    
    let id: String?
    
    var league: IdRefObjectWrapper<League>?
    var sheduleIsCreated: Bool?
    
    let t: sType?
    
    let teamsCount: Int?
    let roundsCount: Int?
    let toNextStage: Int?
    
    let groups: [Group]?
    
    let createdAt: Date?
    let updatedAt: Date?
    
    let v: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        
        case league = "league"
        case sheduleIsCreated = "sheduleIsCreated"
        
        case t = "__t"
        
        case teamsCount = "teamsCount"
        case roundsCount = "roundsCount"
        case toNextStage = "toNextStage"
        
        case groups = "groups"
        
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        
        case v = "__v"
    }
}
