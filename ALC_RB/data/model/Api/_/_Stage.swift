//
//  Stage.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

enum _StageType: String, Codable {
    case group = "group"
    case playoff = "playoff"
}

// MARK: - _Stage
struct _Stage: Codable {
    let sheduleIsCreated: Bool?
    let t: String?
    let groups: [_Group]?
    let id: String?
    let teamsCount: Int?
    let roundsCount: Int?
    let league: String?
    let toNextStage: Int?
    let createdAt: Date?
    let updatedAt: Date?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case sheduleIsCreated = "sheduleIsCreated"
        case t = "__t"
        case groups = "groups"
        case id = "_id"
        case teamsCount = "teamsCount"
        case roundsCount = "roundsCount"
        case league = "league"
        case toNextStage = "toNextStage"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }
}
