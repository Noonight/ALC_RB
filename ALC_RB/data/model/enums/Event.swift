//
//  Time.swift
//  ALC_RB
//
//  Created by ayur on 05.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

enum EventTime: String, Equatable {
    case oneHalf = "1 half"
    case twoHalf = "2 half"
    case extraTime = "extra time"
    case penaltySeries = "penalty series"
    
    static func ==(lhs: EventTime, rhs: EventTime) -> Bool
    {
        switch (lhs, rhs) {
        case (.oneHalf, .oneHalf):
            return true
        case (.twoHalf, .twoHalf):
            return true
        case (.extraTime, .extraTime):
            return true
        case (.penaltySeries, .penaltySeries):
            return true
        default:
            return false
        }
    }
}

enum EventAllTypes: Equatable {
    case player(EventPlayerType)
    case team(EventTeamType)
    case none
    
    static func getInstance(eventType: String) -> EventAllTypes {
        switch eventType {
        case EventPlayerType.goal.rawValue:
            return EventAllTypes.player(EventPlayerType.goal)
        case EventPlayerType.redCard.rawValue:
            return EventAllTypes.player(EventPlayerType.redCard)
        case EventPlayerType.yellowCard.rawValue:
            return EventAllTypes.player(EventPlayerType.yellowCard)
        case EventPlayerType.penalty.rawValue:
            return EventAllTypes.player(EventPlayerType.penalty)
        case EventPlayerType.penaltyFailure.rawValue:
            return EventAllTypes.player(EventPlayerType.penaltyFailure)
            
        // team
        case EventTeamType.autoGoal.rawValue:
            return EventAllTypes.team(EventTeamType.autoGoal)
        case EventTeamType.foul.rawValue:
            return EventAllTypes.team(EventTeamType.foul)
        case EventTeamType.penaltySeriesSuccess.rawValue:
            return EventAllTypes.team(EventTeamType.penaltySeriesSuccess)
        case EventTeamType.penaltySeriesFailure.rawValue:
            return EventAllTypes.team(EventTeamType.penaltySeriesFailure)
        default:
            return EventAllTypes.none
        }
    }
    
    static func ==(lhs: EventAllTypes, rhs: EventAllTypes) -> Bool
    {
        switch (lhs, rhs) {
        case (let .player(one), let .player(two)):
            return one == two
        case (let .team(one), let .team(two)):
            return one == two
        case (.none, .none):
            return true
        default:
            return false
        }
    }
    
    func getAbbreviation() -> String {
        switch self {
        case (let .player(inType)):
            return inType.getAbbreviation()
        case (let .team(inType)):
            return inType.getAbbreviation()
        case (.none):
            return ""
        }
    }
    
    func getImage() -> UIImage {
        var imageName = ""
        switch self {
        case .player(.goal):
            imageName = "ic_green_footbal"
        case .player(.redCard):
            imageName = "ic_redCard"
        case .player(.yellowCard):
            imageName = "ic_yellowCard"
        case .player(.penalty):
            imageName = "ic_green_footbal_with_P"
        case .player(.penaltyFailure):
            imageName = "ic_gray_footbal_with_P"
        // team
        case .team(.autoGoal):
            imageName = "ic_con"
        case .team(.foul):
            imageName = "ic_faul"
        case .team(.penaltySeriesSuccess):
            imageName = "ic_goal"
        case .team(.penaltySeriesFailure):
            imageName = "ic_penalty"
        case .none:
            imageName = "ic_empty"
        }
        return UIImage(named: imageName)!
    }
}

enum EventPlayerType: String, Equatable {
    case goal = "goal"
    case redCard = "redCard"
    case yellowCard = "yellowCard"
    case penalty = "penalty"
    case penaltyFailure = "penaltyFailure"
    
    func getAbbreviation() -> String {
        switch self {
        case .goal:
            return "Г"
        case .yellowCard:
            return "ЖК"
        case .redCard:
            return "КК"
        case .penalty:
            return "П"
        case .penaltyFailure:
            return "ПН"
        }
    }
    
    static func ==(lhs: EventPlayerType, rhs: EventPlayerType) -> Bool
    {
        switch (lhs, rhs) {
        case (.goal, .goal):
            return true
        case (.redCard, .redCard):
            return true
        case (.yellowCard, .yellowCard):
            return true
        case (.penalty, .penalty):
            return true
        case (.penaltyFailure, .penaltyFailure):
            return true
        default:
            return false
        }
    }
}

enum EventTeamType: String, Equatable {
    case autoGoal = "autoGoal"
    case foul = "foul"
    case penaltySeriesSuccess = "penaltySeriesSuccess"
    case penaltySeriesFailure = "penaltySeriesFailure"
    
    func getAbbreviation() -> String {
        switch self {
        case .autoGoal:
            return "А"
        case .foul:
            return "Ф"
        case .penaltySeriesSuccess:
            return "П"
        case .penaltySeriesFailure:
            return "ПН"
        }
    }
    
    static func ==(lhs: EventTeamType, rhs: EventTeamType) -> Bool
    {
        switch (lhs, rhs) {
        case (.autoGoal, .autoGoal):
            return true
        case (.foul, .foul):
            return true
        case (.penaltySeriesSuccess, .penaltySeriesSuccess):
            return true
        case (.penaltySeriesFailure, .penaltySeriesFailure):
            return true
        default:
            return false
        }
    }
}
