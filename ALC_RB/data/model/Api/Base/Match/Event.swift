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
    
    var event: String? = nil // id of disable / enable event
    
    var time: Time? = nil
    
    var post_create: [String: Any] {
        get {
            var map = [CodingKeys: Any]()
            
            map[.type] = type?.rawValue
            map[.player] = player?.getId() ?? player?.getValue()?.id
            map[.team] = team?.getId() ?? team?.getValue()?.id
            map[.event] = event
            map[.time] = time?.rawValue
            
            return map.get()
        }
    }
    
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
    
    // type required {disable, enable}, event of enable disable event
    init(type: eType, event: String) {
        self.id = ""
        self.type = type
        self.event = event
    }
    
    // type {goal, yellowCard, redCard, penalty} event of player
    init(type: eType, player: IdRefObjectWrapper<Person>, team: IdRefObjectWrapper<Team>, time: Time) {
        self.id = ""
        self.type = type
        self.player = player
        self.team = team
        self.time = time
    }
    
    // type {autoGoal, foul, penaltySeriesSuccess, penaltySeriesFailure} event of team
    init(type: eType, team: IdRefObjectWrapper<Team>, time: Time) {
        self.id = ""
        self.type = type
        self.team = team
        self.time = time
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case type = "eventType"
        
        case player = "person"
        case team
        
        case event
        
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
        case disable = "disable"
        case enable = "enable"
        case matchEnd = "matchEnd"
        case matchStart = "matchStart"
        
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
            case .disable:
                return "Disable"
            case .enable:
                return "Enable"
            case .matchEnd:
                return "Match end"
            case .matchStart:
                return "Match start"
            }
        }
        
        func getImage() -> UIImage {
            var imagePath = String()
            switch self {
            case .goal:
                imagePath = "ic_green_footbal_with_background"
            case .redCard:
                imagePath = "ic_redCard"
            case .yellowCard:
                imagePath = "ic_yellowCard"
            case .penalty:
                imagePath = "ic_green_footbal_with_P"
            case .penaltyFailure:
                imagePath = "ic_gray_footbal_with_P"
            case .autoGoal:
                imagePath = "ic_autoGoal"
            case .foul:
                imagePath = "ic_foul"
            case .penaltySeriesSuccess:
                imagePath = "ic_green_footbal_with_P"
            case .penaltySeriesFailure:
                imagePath = "ic_gray_footbal_with_P"
            case .disable:
                assertionFailure("enable")
            case .enable:
                assertionFailure("disable")
            case .matchEnd:
                assertionFailure("match end")
            case .matchStart:
                assertionFailure("match start")
            }
            return UIImage(named: imagePath) ?? UIImage(named: "ic_warning")!
        }
    }
    
    enum Time: String, Codable {
        case firstHalf = "firstHalf"
        case secondHalf = "secondHalf"
        case extraTime = "extraTime"
        case penaltySeries = "penaltySeries"
        
        func ru() -> String {
            switch self {
            case .firstHalf:
                return "Первый тайм"
            case .secondHalf:
                return "Второй тайм"
            case .extraTime:
                return "Дополнительное время"
            case .penaltySeries:
                return "Серия пенальти"
            }
        }
    }
}
