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

    var type: eType? = nil

    var player: IdRefObjectWrapper<Person>? = nil // there is can be played id or team id
    var team: IdRefObjectWrapper<Team>? = nil
    
    var time: Time? = nil
    
    func toDictionary() -> [String: Any] {
        var map = [CodingKeys: Any]()
        
        map[.id] = id
        map[.type] = type?.rawValue
        map[.player] = player?.getId() ?? player?.getValue()?.id
        map[.team] = team?.getId() ?? team?.getValue()?.id
        map[.time] = time?.rawValue
        
        return map.get()
    }
    
    init(id: String, type: eType, player: IdRefObjectWrapper<Person>?, team: IdRefObjectWrapper<Team>?, time: Time) {
        self.id = id
        self.type = type
        self.player = player
        self.team = team
        self.time = time
    }
    
    init(type: eType, player: IdRefObjectWrapper<Person>?, team: IdRefObjectWrapper<Team>?, time: Time) {
        self.id = ""
        self.type = type
        self.player = player
        self.team = team
        self.time = time
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case type
        
        case player
        case team
        
        case time
    }
    
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
