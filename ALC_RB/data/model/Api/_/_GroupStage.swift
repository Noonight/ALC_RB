//
//  GroupStage.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - _GroupStage
struct _GroupStage: Codable {
    let groups: [_Group]?
    let teamsCount: Int?
    let roundsCount: Int?

    enum CodingKeys: String, CodingKey {
        case groups = "groups"
        case teamsCount = "teamsCount"
        case roundsCount = "roundsCount"
    }
}
