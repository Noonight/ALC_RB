//
//  RefereePerson.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct ParticipationMatch: Codable {
    var id, date: String
    var stage: Int
    var played: Bool
    var round: String
    var tour: String
    var group: String
    var playersList: [String]
    var place: String
    var winner: String
    var autoGoals: String
    var fouls: String
    var score: String
    var league: String
    var teamOne, teamTwo: String
    var events: [LIEvent]
    var referees: [Referee]
    var createdAt, updatedAt: String
    var v: Int
    var leagueID: String
    
    func convertToLIMatch() -> LIMatch {
        return LIMatch(date: date, stage: stage, played: played, tour: tour, playersList: playersList, place: place, winner: winner, score: score, fouls: fouls, autoGoals: autoGoals, id: id, league: league, teamOne: teamOne, teamTwo: teamTwo, events: events, referees: referees.map({ referee -> LIReferee in
            return LIReferee(id: referee.id, person: referee.person, type: referee.type)
        }), createdAt: createdAt, updatedAt: updatedAt, v: v)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
        self.stage = try container.decodeIfPresent(Int.self, forKey: .stage) ?? 0
        self.played = try container.decodeIfPresent(Bool.self, forKey: .played) ?? false
        self.round = try container.decodeIfPresent(String.self, forKey: .tour) ?? ""
        self.group = try container.decodeIfPresent(String.self, forKey: .tour) ?? ""
        self.tour = try container.decodeIfPresent(String.self, forKey: .tour) ?? ""
        self.playersList = try container.decodeIfPresent([String].self, forKey: .playersList) ?? []
        self.place = try container.decodeIfPresent(String.self, forKey: .place) ?? ""
        self.winner = try container.decodeIfPresent(String.self, forKey: .winner) ?? ""
        self.fouls = try container.decodeIfPresent(String.self, forKey: .fouls) ?? ""
        self.autoGoals = try container.decodeIfPresent(String.self, forKey: .autoGoals) ?? ""
        self.score = try container.decodeIfPresent(String.self, forKey: .score) ?? ""
        self.league = try container.decodeIfPresent(String.self, forKey: .league) ?? ""
        self.teamOne = try container.decodeIfPresent(String.self, forKey: .teamOne) ?? ""
        self.teamTwo = try container.decodeIfPresent(String.self, forKey: .teamTwo) ?? ""
        self.events = try container.decodeIfPresent([LIEvent].self, forKey: .events) ?? []
        self.referees = try container.decodeIfPresent([Referee].self, forKey: .referees) ?? []
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        self.v = try container.decodeIfPresent(Int.self, forKey: .v) ?? -1
        self.leagueID = try container.decodeIfPresent(String.self, forKey: .leagueID) ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date, stage, played, round, group, tour, playersList, place, winner, score, fouls, autoGoals, league, teamOne, teamTwo, events, referees, createdAt, updatedAt
        case v = "__v"
        case leagueID = "leagueId"
    }
    
    init() {
        id = ""
        date = ""
        stage = -1
        played = false
        tour = ""
        playersList = []
        place = ""
        winner = ""
        score = ""
        fouls = ""
        autoGoals = ""
        league = ""
        teamOne = ""
        teamTwo = ""
        events = []
        referees = []
        createdAt = ""
        updatedAt = ""
        v = -1
        leagueID = ""
        round = ""
        group = ""
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(ParticipationMatch.self, from: data)
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
        stage: Int? = nil,
        played: Bool? = nil,
        tour: String? = nil,
        playersList: [String]? = nil,
        place: String? = nil,
        winner: String? = nil,
        score: String? = "",
        fouls: String? = "",
        autoGoals: String? = nil,
        league: String? = nil,
        teamOne: String? = nil,
        teamTwo: String? = nil,
        events: [LIEvent]? = nil,
        referees: [Referee]? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        v: Int? = nil,
        leagueID: String? = nil
        ) -> ParticipationMatch {
        var match = ParticipationMatch()
        match.id = id ?? self.id
        match.date = date ?? self.date
        match.stage = stage ?? self.stage
        match.played = played ?? self.played
        match.tour = tour ?? self.tour
        match.playersList = playersList ?? self.playersList
        match.place = place ?? self.place
        match.winner = winner ?? self.winner
        match.score = score ?? self.score
        match.fouls = fouls ?? self.fouls
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
        return match
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
