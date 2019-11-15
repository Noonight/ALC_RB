//
//  Team.swift
//  ALC_RB
//
//  Created by mac on 13.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Team: Codable {
    
//    var id: String
//
//    var creator: IdRefObjectWrapper<Person>?
//    var trainer: IdRefObjectWrapper<Person>?
//
//    var creatorPhone: String?
    
    var status: String // Pending Approved Rejected
    var place: Int
    var playoffPlace: Int?
    var madeToPlayoff: Bool
    var group: String?
    var goals, goalsReceived, wins, losses: Int
    var draws, groupScore: Int
    var id, name, creator: String
    var creatorPhone: String
    var players: [Player]
    var club: String?
    
    func getTeamStatus() -> TeamStatus {
        if status == TeamStatus.approved.rawValue {
            return TeamStatus.approved
        }
        if status == TeamStatus.rejected.rawValue {
            return TeamStatus.rejected
        }
        if status == TeamStatus.pending.rawValue {
            return TeamStatus.pending
        }
        
        return TeamStatus.fail
    }
    
    enum TeamStatus: String {
        case approved = "Approved"
        case pending = "Pending"
        case rejected = "Rejected"
        
        case fail = "Error"
    }
    
    enum CodingKeys: String, CodingKey {
        case status, place, playoffPlace, madeToPlayoff, group, goals, goalsReceived, wins, losses, draws, groupScore
        case id = "_id"
        case name, creator, players, club
        case creatorPhone
    }
}

extension Team {
    
    init() {
        status = ""
        place = -1
        playoffPlace = nil
        madeToPlayoff = false
        group = ""
        goals = -1
        goalsReceived = -1
        wins = -1
        losses = -1
        draws = -1
        groupScore = -1
        id = ""
        name = ""
        creator = ""
        players = []
        club = ""
        creatorPhone = ""
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Team.self, from: data)
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
        status: String? = nil,
        place: Int? = nil,
        playoffPlace: Int? = nil,
        madeToPlayoff: Bool? = nil,
        group: String? = nil,
        goals: Int? = nil,
        goalsReceived: Int? = nil,
        wins: Int? = nil,
        losses: Int? = nil,
        draws: Int? = nil,
        groupScore: Int? = nil,
        id: String? = nil,
        name: String? = nil,
        creator: String? = nil,
        players: [Player]? = nil,
        club: String? = nil
        ) -> Team {
        
        var team = Team()
        team.status = status ?? self.status
        team.place = place ?? self.place
        team.playoffPlace = playoffPlace ?? self.playoffPlace
        team.madeToPlayoff = madeToPlayoff ?? self.madeToPlayoff
        team.group = group ?? self.group
        team.goals = goals ?? self.goals
        team.goalsReceived = goalsReceived ?? self.goalsReceived
        team.wins = wins ?? self.wins
        team.losses = losses ?? self.losses
        team.draws = draws ?? self.draws
        team.groupScore = groupScore ?? self.groupScore
        team.id = id ?? self.id
        team.name = name ?? self.name
        team.creator = creator ?? self.creator
        team.players = players ?? self.players
        team.club = club ?? self.club
        
        //        return Team(
        //            status: status ?? self.status,
        //            place: place ?? self.place,
        //            playoffPlace: playoffPlace ?? self.playoffPlace,
        //            madeToPlayoff: madeToPlayoff ?? self.madeToPlayoff,
        //            group: group ?? self.group,
        //            goals: goals ?? self.goals,
        //            goalsReceived: goalsReceived ?? self.goalsReceived,
        //            wins: wins ?? self.wins,
        //            losses: losses ?? self.losses,
        //            draws: draws ?? self.draws,
        //            groupScore: groupScore ?? self.groupScore,
        //            id: id ?? self.id,
        //            name: name ?? self.name,
        //            creator: creator ?? self.creator,
        //            players: players ?? self.players,
        //            club: club ?? self.club
        //        )
        return team
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
