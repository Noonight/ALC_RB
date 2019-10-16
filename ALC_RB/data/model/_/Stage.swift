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
    let groupStage: _GroupStage?
    let id: String?
    let stageType: _StageType?
    let toNextStage: Int?

    enum CodingKeys: String, CodingKey {
        case groupStage = "groupStage"
        case id = "_id"
        case stageType = "stageType"
        case toNextStage = "toNextStage"
    }
}
