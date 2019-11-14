//
//  Match.swift
//  ALC_RB
//
//  Created by mac on 14.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Match: Codable {
    
    var id: String
    
    var league: IdRefObjectWrapper<League>?
    var teamOne: IdRefObjectWrapper<Team>?
    var teamTwo: IdRefObjectWrapper<Team>?
    
    var date: Date?
    
    var stage: IdRefObjectWrapper<Stage>?
    
    var round: String?
    var tour: String?
    var group: String?
    
    var place: IdRefObjectWrapper<Stadium>?
    
    var events: [Event]?
    var playersList: [IdRefObjectWrapper<Person>]?
    var referees: [Referee]?
    
    var played: Bool?
    var winner: String? // teamOne, teamTwo, draw
    var score: String?
    var fouls: String?
    var autoGoals: String?
    
    var createdAt: Date?
    var updatedAt: Date?
    var v: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        
        self.league = try container.decodeIfPresent(IdRefObjectWrapper<League>.self, forKey: .league) ?? nil
        self.teamOne = try container.decodeIfPresent(IdRefObjectWrapper<Team>.self, forKey: .teamOne) ?? nil
        self.teamTwo = try container.decodeIfPresent(IdRefObjectWrapper<Team>.self, forKey: .teamTwo) ?? nil
        
        self.date = try container.decodeIfPresent(Date.self, forKey: .date) ?? nil
        
        self.stage = try container.decodeIfPresent(IdRefObjectWrapper<Stage>.self, forKey: .stage) ?? nil
        
        self.round = try container.decodeIfPresent(String.self, forKey: .round) ?? nil
        self.tour = try container.decodeIfPresent(String.self, forKey: .tour) ?? nil
        self.group = try container.decodeIfPresent(String.self, forKey: .group) ?? nil
        
        self.place = try container.decodeIfPresent(IdRefObjectWrapper<Stadium>.self, forKey: .place) ?? nil
        
        self.events = try container.decodeIfPresent([Event].self, forKey: .events) ?? nil
        self.playersList = try container.decodeIfPresent([IdRefObjectWrapper<Person>].self, forKey: .playersList) ?? nil
        self.referees = try container.decodeIfPresent([Referee].self, forKey: .referees) ?? []
        
        self.played = try container.decodeIfPresent(Bool.self, forKey: .played) ?? nil
        self.winner = try container.decodeIfPresent(String.self, forKey: .winner) ?? nil
        self.score = try container.decodeIfPresent(String.self, forKey: .score) ?? nil
        self.fouls = try container.decodeIfPresent(String.self, forKey: .fouls) ?? nil
        self.autoGoals = try container.decodeIfPresent(String.self, forKey: .autoGoals) ?? nil
        
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? nil
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? nil
        self.v = try container.decodeIfPresent(Int.self, forKey: .v) ?? nil
    }
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        
        case league
        case teamOne
        case teamTwo
        
        case date
        
        case stage
        
        case round
        case tour
        case group
        
        case place
        
        case events
        case playersList
        case referees
        
        case played
        case winner
        case score
        case fouls
        case autoGoals
        
        case createdAt
        case updatedAt
        case v = "__v"
    }
}

extension Match {
    
    init() {
        id = ""
        
        league = nil
        teamOne = nil
        teamTwo = nil
        
        date = nil
        
        stage = nil
        
        round = nil
        tour = nil
        group = nil
        
        place = nil
        
        events = nil
        playersList = nil
        referees = nil
        
        played = nil
        winner = nil
        score = nil
        fouls = nil
        autoGoals = nil
        
        createdAt = nil
        updatedAt = nil
        v = nil
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Match.self, from: data)
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
    
//    func with(
//        id: String? = nil,
//        date: Date? = nil,
//        stage: String? = nil,
//        played: Bool? = nil,
//        tour: String? = nil,
//        //        playersList: [JSONAny]? = nil,
//        playersList: [String]? = nil,
//
//        place: String? = nil,
//        //        winner: JSONNull?? = nil,
//        winner: String? = nil,
//
//        //score: JSONNull?? = nil,
//        score: String? = "",
//        fouls: String? = "",
//        //        autoGoals: JSONNull?? = nil,
//        autoGoals: String? = nil,
//
//        league: String? = nil,
//        //        teamOne: Team? = nil,
//        //        teamTwo: Team? = nil,
//        teamOne: Team? = nil,
//        teamTwo: Team? = nil,
//
//        //        events: [JSONAny]? = nil,
//        //        referees: [JSONAny]? = nil,
//        events: [LIEvent]? = nil,
//        referees: [Referee]? = nil,
//
//        createdAt: String? = nil,
//        updatedAt: String? = nil,
//        v: Int? = nil,
//        leagueID: String? = nil
//        ) -> Match {
//
//        var match = Match()
//        match.id = id ?? self.id
//        match.date = date ?? self.date
//        match.stage = stage ?? self.stage
//        match.played = played ?? self.played
//        match.tour = tour ?? self.tour
//        match.playersList = playersList ?? self.playersList
//        match.place = place ?? self.place
//        match.winner = winner ?? self.winner
//        match.score = score ?? self.score
//        match.fouls = fouls ?? self.fouls
//        match.autoGoals = autoGoals ?? self.autoGoals
//        match.league = league ?? self.league
//        match.teamOne = teamOne ?? self.teamOne
//        match.teamTwo = teamTwo ?? self.teamTwo
//        match.events = events ?? self.events
//        match.referees = referees ?? self.referees
//        match.createdAt = createdAt ?? self.createdAt
//        match.updatedAt = updatedAt ?? self.updatedAt
//        match.v = v ?? self.v
//        match.leagueID = leagueID ?? self.leagueID
//
//        //        return Match(
//        //            id: id ?? self.id,
//        //            date: date ?? self.date,
//        //            stage: stage ?? self.stage,
//        //            played: played ?? self.played,
//        //            tour: tour ?? self.tour,
//        //            playersList: playersList ?? self.playersList,
//        //            place: place ?? self.place,
//        //            winner: winner ?? self.winner,
//        //            score: score ?? self.score,
//        //            fouls: fouls ?? self.fouls,
//        //            autoGoals: autoGoals ?? self.autoGoals,
//        //            league: league ?? self.league,
//        //            teamOne: teamOne ?? self.teamOne,
//        //            teamTwo: teamTwo ?? self.teamTwo,
//        //            events: events ?? self.events,
//        //            referees: referees ?? self.referees,
//        //            createdAt: createdAt ?? self.createdAt,
//        //            updatedAt: updatedAt ?? self.updatedAt,
//        //            v: v ?? self.v,
//        //            leagueID: leagueID ?? self.leagueID
//        //        )
//        return match
//    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
