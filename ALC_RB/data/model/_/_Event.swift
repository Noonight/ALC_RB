//
//  Event.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 18.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

enum _EventType: String, Codable {
    case goal = "goal"
    case redCard = "redCard"
    case yellowCard = "yellowCard"
    case penalty = "penalty"
    case penaltyFailure = "penaltyFailure"
    case autoGoal = "autoGoal"
    case foul = "foul"
    case penaltySeriesSuccess = "penaltySeriesSuccess"
    case penaltySeriesFailure = "penaltySeriesFailure"
}

enum _EventTime: String, Codable {
    case firstHalf = "1 half"
    case secondHalf = "2 half"
    case extraTime = "extra time"
    case penaltySeries = "penaltySeries"
}

struct _Event: Codable {
    let id: String?
    let eventType: _EventType?
    let player: String?
    let time: _EventTime?
}
