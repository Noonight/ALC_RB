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
    }
    
    var id: String?
    
    var creator: IdRefObjectWrapper<Person>?
    var tourney: String? // TODO: IdRefObjectWrapper<Tourney>?
    var name: String?
    
    var transferBegin: String? // TODO: Date?
    var transferEnd: String? // TODO: Date?
    var beginDate: String? // TODO: Date?
    var endDate: String? // TODO: Date?
    var drawDateTime: Date?
    
    var mainReferee: IdRefObjectWrapper<Person>?
    
    var yellowCardsToDisqual: Int?
    var ageAllowedMin: Int?
    var ageAllowedMax: Int?
    var playersMin: Int?
    var playersMax: Int?
    
    var maxTeams: Int?
    var maxPlayersInMatch: Int?
    
    var teams: [Team]? // virtual
    
    var status: Status?
    
    var matches: [Match]? // virtual
    var stages: [Stage]? // virtual
    
    func betweenBeginEndDate() -> Bool {
        //        let firstDate = beginDate?.toDateCustom(type: .leagueDate)!
        //        let lastDate = endDate?.toDateCustom(type: .leagueDate)!
        guard let firstDate = beginDate?.toDate()?.date else { return false }//.toFormat(DateFormats.leagueDate.rawValue) else { return false }
        guard let lastDate = endDate?.toDate()?.date else { return false }//.toFormat(DateFormats.leagueDate.rawValue) else { return false }
        return Date().isBetween(firstDate, and: lastDate)
    }
    
//    func getStatus() -> Statuses {
//        if status == Statuses.finished.rawValue {
//            return Statuses.finished
//        } else if status == Statuses.playoff.rawValue {
//            return Statuses.playoff
//        } else if status == Statuses.groups.rawValue {
//            return Statuses.groups
//        } else {
//            return Statuses.pending
//        }
//    }
//
//    enum Statuses : String {
//        case finished = "Finished"
//        case playoff = "Playoff"
//        case groups = "Groups"
//        case pending = "Pending"
//    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? nil
        
        self.status = try container.decodeIfPresent(Status.self, forKey: .status) ?? .pending
        self.tourney = try container.decodeIfPresent(String.self, forKey: .tourney) ?? nil
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? nil
        self.beginDate = try container.decodeIfPresent(String.self, forKey: .beginDate) ?? nil
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate) ?? nil
        self.transferBegin = try container.decodeIfPresent(String.self, forKey: .transferBegin) ?? nil
        self.transferEnd = try container.decodeIfPresent(String.self, forKey: .transferEnd) ?? nil
        self.playersMin = try container.decodeIfPresent(Int.self, forKey: .playersMin) ?? nil
        self.playersMax = try container.decodeIfPresent(Int.self, forKey: .playersMax) ?? nil
        //        self.playersCapacity = try container.decodeIfPresent(Int.self, forKey: .playersCapacity) ?? 0
        self.yellowCardsToDisqual = try container.decodeIfPresent(Int.self, forKey: .yellowCardsToDisqual) ?? nil
        self.ageAllowedMin = try container.decodeIfPresent(Int.self, forKey: .ageAllowedMin) ?? nil
        self.ageAllowedMax = try container.decodeIfPresent(Int.self, forKey: .ageAllowedMax) ?? nil
        self.maxTeams = try container.decodeIfPresent(Int.self, forKey: .maxTeams) ?? nil
        self.teams = try container.decodeIfPresent([Team].self, forKey: .teams) ?? nil
        self.matches = try container.decodeIfPresent([Match].self, forKey: .matches) ?? nil
        self.stages = try container.decodeIfPresent([Stage].self, forKey: .stages) ?? nil
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
        
        case yellowCardsToDisqual = "yellowCardsToDisqual"
        case ageAllowedMin = "ageAllowedMin"
        case ageAllowedMax = "ageAllowedMax"
        case playersMin = "playersMin"
        case playersMax = "playersMax"
        
        case maxTeams = "maxTeams"
        case maxPlayersInMatch = "maxPlayersInMatch"
        
        case teams = "teams"
        
        case status = "status"
        
        case matches = "matches"
        case stages = "stages"
    }
}

extension League {
    
    init() {
        id = ""
        
        tourney = ""
        name = ""
        beginDate = ""
        endDate = ""
        transferBegin = ""
        transferEnd = ""
        playersMin = -1
        playersMax = -1
        yellowCardsToDisqual = -1
        ageAllowedMin = -1
        ageAllowedMax = -1
        maxTeams = -1
        teams = []
        
        status = .pending
        
        matches = []
        stages = []
        
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(League.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        status: Status? = nil,
        matches: [Match]? = nil,
        id: String? = nil,
        tourney: String? = nil,
        name: String? = nil,
        beginDate: String? = nil,
        endDate: String? = nil,
        transferBegin: String? = nil,
        transferEnd: String? = nil,
        playersMin: Int? = nil,
        playersMax: Int? = nil,
        playersCapacity: Int? = nil,
        yellowCardsToDisqual: Int?? = nil,
        ageAllowedMin: Int? = nil,
        ageAllowedMax: Int? = nil,
        maxTeams: Int? = nil,
        teams: [Team]? = nil,
        stages: [Stage]? = nil
        ) -> League {
        var league = League()
        league.status = status ?? self.status
        league.matches = matches ?? self.matches
        league.id = id ?? self.id
        league.tourney = tourney ?? self.tourney
        league.name = name ?? self.name
        league.beginDate = beginDate ?? self.beginDate
        league.endDate = endDate ?? self.endDate
        league.transferBegin = transferBegin ?? self.transferBegin
        league.transferEnd = transferEnd ?? self.transferEnd
        league.playersMin = playersMin ?? self.playersMin
        league.playersMax = playersMax ?? self.playersMax
        //        league.playersCapacity = playersCapacity ?? self.playersCapacity
        league.yellowCardsToDisqual = yellowCardsToDisqual ?? self.yellowCardsToDisqual
        league.ageAllowedMin = ageAllowedMin ?? self.ageAllowedMin
        league.ageAllowedMax = ageAllowedMax ?? self.ageAllowedMax
        league.maxTeams = maxTeams ?? self.maxTeams
        league.teams = teams ?? self.teams
        league.stages = stages ?? self.stages
        
        return league
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
