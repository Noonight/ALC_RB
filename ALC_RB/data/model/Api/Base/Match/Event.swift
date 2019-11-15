//
//  Event.swift
//  ALC_RB
//
//  Created by mac on 14.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Event: Codable {
    
    var id: String

    var type: eType?

    var player: String? // there is can be played id or team id

    var time: Time?
    
    enum eType: String, Codable {
        case goal = "goal"
        case redCard = "redCard"
        case yellowCard = "yellowCard"
        case penalty = "penalty"
        case penaltyFailure = "penaltyFailure"
        case autoGoal = "autoGoal"
        case foul = "foul"
        case penaltySeriesSuccess = "penaltySeriesSuccess"
        case penaltySeriesFailure = "penaltySeriesFailure"
        
        func getTitle() -> String {
            switch self {
            case .goal:
                return "Гол"
            case .redCard:
                return "Красная карта"
            case .yellowCard:
                return "Желтая карта"
            case .penalty:
                return "Пенальти"
            case .penaltyFailure:
                return "Пенальти - "
            case .autoGoal:
                return "Автогол"
            case .foul:
                return "Фол"
            case .penaltySeriesSuccess:
                return "Серия пенальти"
            case .penaltySeriesFailure:
                return "Серия пенальти - "
            }
        }
    }
    
    enum Time: String, Codable {
        case firstHalf = "firstHalf"
        case secondHalf = "secondHalf"
        case extraTime = "extraTime"
        case penaltySeries = "penaltySeries"
    }
}
