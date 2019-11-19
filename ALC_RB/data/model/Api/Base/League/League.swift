//
//  League.swift
//  ALC_RB
//
//  Created by mac on 13.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

extension League: CellModel {}

struct League: Codable {
    
    enum Status: String, Codable {
        case pending = "pending"
        case started = "started"
        case finished = "finished"
        
        func ru() -> String {
            switch self {
            case .pending:
                return "В ожидании"
            case .started:
                return "Началась"
            case .finished:
                return "Завершилась"
            }
        }
    }
    
    var id: String
    
    var creator: IdRefObjectWrapper<Person>? = nil
    var tourney: IdRefObjectWrapper<Tourney>? = nil
    var name: String? = nil
    
    var transferBegin: Date? = nil
    var transferEnd: Date? = nil
    var beginDate: Date? = nil
    var endDate: Date? = nil
    var drawDateTime: Date? = nil
    
    var mainReferee: IdRefObjectWrapper<Person>? = nil
    
    var yellowCardsToDisqual: Int? = nil
    var ageAllowedMin: Int? = nil
    var ageAllowedMax: Int? = nil
    var playersMin: Int? = nil
    var playersMax: Int? = nil
    
    var maxTeams: Int? = nil
    var maxPlayersInMatch: Int? = nil
    
    // TODO: check it later mb its deprecated
    var teams: [Team]? = nil // virtual
    
    var status: Status? = nil
    
    var matches: [Match]? = nil // virtual
    var stages: [Stage]? = nil // virtual
    
    func betweenBeginEndDate() -> Bool {
        guard let firstDate = beginDate?.date else { return false }
        guard let lastDate = endDate?.date else { return false }
        return Date().isBetween(firstDate, and: lastDate)
    }
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        
        case creator = "creator"
        case tourney = "tourney"
        case name = "name"
        
        case transferBegin = "transferBegin"
        case transferEnd = "transferEnd"
        case beginDate = "beginDate"
        case endDate = "endDate"
        case drawDateTime = "drawDateTime"
        
        case mainReferee
        
        case yellowCardsToDisqual = "yellowCardsToDisqual"
        case ageAllowedMin = "ageAllowedMin"
        case ageAllowedMax = "ageAllowedMax"
        case playersMin = "playersMin"
        case playersMax = "playersMax"
        
        case maxTeams = "maxTeams"
        case maxPlayersInMatch = "maxPlayersInMatch"
        
//        case teams = "teams"
        
        case status = "status"
        
        case matches = "matches"
        case stages = "stages"
    }
}

extension League {
    
    init() {
        id = ""
        tourney = nil
        name = nil
        beginDate = nil
        endDate = nil
        transferBegin = nil
        transferEnd = nil
        playersMin = nil
        playersMax = nil
        yellowCardsToDisqual = nil
        ageAllowedMin = nil
        ageAllowedMax = nil
        maxTeams = nil
        teams = nil
        
        status = nil
        
        matches = nil
        stages = nil
        
    }
}
