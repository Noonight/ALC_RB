//
//  ActiveMatch.swift
//  ALC_RB
//
//  Created by ayur on 11.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

struct ActiveMatches: Codable {
    var matches: [ActiveMatch]
    var count: Int
}

extension ActiveMatches {
    init() {
        matches = []
        count = 0
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(ActiveMatches.self, from: data)
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
        matches: [ActiveMatch]? = nil,
        count: Int? = nil
        ) -> ActiveMatches {
        return ActiveMatches(
            matches: matches ?? self.matches,
            count: count ?? self.count
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try JSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseActiveMatches(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ActiveMatches>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}

struct ActiveMatch: Codable {
    var id: String
    var date: String
    var stage: String
    var played: Bool
    var tour: String?
    var playersList: [String]
    var place: String
    
    var winner: String? // delete
    var fouls: String?
    
    var autoGoals: String?
    
    var score: String
    var league: String
    var teamOne, teamTwo: Team
    var events: [LIEvent]
    var referees: [Referee]
    var penalty: String?
    var createdAt: String
    var updatedAt: String
    var leagueID: String
    var v: Int
    
    func convertToParticipationMatch() -> ParticipationMatch {
        return ParticipationMatch().with(id: id, date: date, stage: stage, played: played, tour: tour, playersList: playersList, place: place, winner: winner, score: score, fouls: fouls, autoGoals: autoGoals, league: league, teamOne: teamOne.id, teamTwo: teamTwo.id, events: events, referees: referees, createdAt: createdAt, updatedAt: updatedAt, v: v, leagueID: leagueID)
    }
    
    init(id: String, date: String, stage: String, played: Bool, tour: String, playersList: [String], place: String, autoGoals: String, score: String, league: String, teamOne: Team, teamTwo: Team, events: [LIEvent], referees: [Referee], penalty: String, createdAt: String, updatedAt: String, v: Int, leagueID: String, winner: String, fouls: String) {
        self.id = id
        self.date = date
        self.stage = stage
        self.played = played
        self.tour = tour
        self.playersList = playersList
        self.place = place
        self.autoGoals = autoGoals
        self.score = score
        self.league = league
        self.teamOne = teamOne
        self.teamTwo = teamTwo
        self.events = events
        self.referees = referees
        self.penalty = penalty
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
        self.leagueID = leagueID
        self.winner = winner
        self.fouls = fouls
        
        self.v = v
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
        self.stage = try container.decodeIfPresent(String.self, forKey: .stage) ?? ""
        self.played = try container.decodeIfPresent(Bool.self, forKey: .played) ?? false
        self.tour = try container.decodeIfPresent(String.self, forKey: .tour) ?? ""
        self.playersList = try container.decodeIfPresent([String].self, forKey: .playersList) ?? []
        self.place = try container.decodeIfPresent(String.self, forKey: .place) ?? ""
        
        self.winner = try container.decodeIfPresent(String.self, forKey: .winner) ?? ""
        self.winner = try container.decodeIfPresent(String.self, forKey: .fouls) ?? ""
        
        self.autoGoals = try container.decodeIfPresent(String.self, forKey: .autoGoals) ?? ""
        self.score = try container.decodeIfPresent(String.self, forKey: .score) ?? ""
        self.league = try container.decodeIfPresent(String.self, forKey: .league) ?? ""
        self.teamOne = try container.decodeIfPresent(Team.self, forKey: .teamOne) ?? Team()
        self.teamTwo = try container.decodeIfPresent(Team.self, forKey: .teamTwo) ?? Team()
        self.events = try container.decodeIfPresent([LIEvent].self, forKey: .events) ?? []
        self.referees = try container.decodeIfPresent([Referee].self, forKey: .referees) ?? []
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        self.v = try container.decodeIfPresent(Int.self, forKey: .v) ?? -1
        
        self.leagueID = try container.decodeIfPresent(String.self, forKey: .leagueID) ?? ""
        
        self.penalty = try container.decodeIfPresent(String.self, forKey: .penalty)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date, stage, played, tour, playersList, place, winner, score, fouls, autoGoals, league, teamOne, teamTwo, events, referees, createdAt, updatedAt
        case leagueID
        case v = "__v"
        //        case leagueID = "leagueId"
        case penalty
    }
}

extension ActiveMatch {
    
    init() {
        id = ""
        date = ""
        stage = ""
        played = false
        tour = ""
        playersList = []
        place = ""
        winner = ""
        score = ""
                fouls = ""
        autoGoals = nil
        league = ""
        teamOne = Team()
        teamTwo = Team()
        //        teamOne = ""
        //        teamTwo = ""
        events = []
        referees = []
        createdAt = ""
        updatedAt = ""
        v = -1
                leagueID = ""
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(ActiveMatch.self, from: data)
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
        id: String? = nil,
        date: String? = nil,
        stage: String? = nil,
        played: Bool? = nil,
        tour: String? = nil,
        playersList: [String]? = nil,
        place: String? = nil,
        
        winner: String? = nil,
        fouls: String? = nil,
        leagueID: String? = nil,
        
        score: String? = "",
//        fouls: JSONNull?? = nil,
        autoGoals: String? = nil,
        league: String? = nil,
        teamOne: Team? = nil,
        teamTwo: Team? = nil,
        events: [LIEvent]? = nil,
        referees: [Referee]? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        v: Int? = nil,
        penalty: String? = ""
        ) -> ActiveMatch {
        var match = ActiveMatch()
        match.id = id ?? self.id
        match.date = date ?? self.date
        match.stage = stage ?? self.stage
        match.played = played ?? self.played
        match.tour = tour ?? self.tour
        match.playersList = playersList ?? self.playersList
        match.place = place ?? self.place
//        match.winner = winner ?? self.winner
        match.score = score ?? self.score
        match.autoGoals = autoGoals ?? self.autoGoals
        match.league = league ?? self.league
        match.teamOne = teamOne ?? self.teamOne
        match.teamTwo = teamTwo ?? self.teamTwo
        match.events = events ?? self.events
        match.referees = referees ?? self.referees
        match.createdAt = createdAt ?? self.createdAt
        match.updatedAt = updatedAt ?? self.updatedAt
        match.v = v ?? self.v
        
        match.leagueID = leagueID ?? self.leagueID
        match.winner = winner ?? self.winner
        match.fouls = fouls ?? self.fouls
        
        return match
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
