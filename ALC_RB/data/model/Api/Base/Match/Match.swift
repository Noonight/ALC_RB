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
    
    var league: IdRefObjectWrapper<League>? = nil
    var teamOne: IdRefObjectWrapper<Team>? = nil
    var teamTwo: IdRefObjectWrapper<Team>? = nil
    
    var date: Date? = nil
    
    var stage: IdRefObjectWrapper<Stage>? = nil
    
    var round: String? = nil
    var tour: String? = nil
    var group: String? = nil
    
    var place: IdRefObjectWrapper<Stadium>? = nil
    
    var events: [Event]? = nil
    var playersList: [IdRefObjectWrapper<Person>]? = nil
    var referees: [Referee]? = nil
    
    var played: Bool? = nil
    var winner: String? = nil // teamOne, teamTwo, draw
    var score: String? = nil
    var fouls: String? = nil
    var autoGoals: String? = nil
    
    var createdAt: Date? = nil
    var updatedAt: Date? = nil
    var v: Int? = nil

    var postPlayersList: [String: Any] {
        get {
            var map = [CodingKeys : Any]()
            map[.playersList] = playersList?.map({ person -> String in
                return person.getId() ?? (person.getValue()?.id)!
            })
            
            return map.get()
        }
    }
    
    var patchReferees: [String: Any] {
        get {
            var map = [CodingKeys : Any]()
            map[.id] = id
            map[.referees] = referees.flatMap({ referees -> [[String : Any]] in
                var mArray = [[String:Any]]()
                for referee in referees {
                    var mMap = [Referee.CodingKeys: Any]()
//                    mMap[.id] = referee.id
                    mMap[.type] = referee.type?.rawValue
                    mMap[.person] = referee.person?.getId() ?? referee.person?.getValue()?.id
                    mArray.append(mMap.get())
                }
                return mArray
            })
            
            return map.get()
        }
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
    
    init(id: String, referees: [Referee]) {
        self.id = id
        self.referees = referees
    }
}

// MARK: - HELPERS

extension Match {
    
    func getPlaingTeamPlayers(team: TeamEnum) -> [IdRefObjectWrapper<Person>] {
        var resultArray = [IdRefObjectWrapper<Person>]()
        var mTeam: Team!
        guard let mPlayersList = self.playersList else { return [] }
        switch team {
        case .one:
            mTeam = (teamOne?.getValue())!
        case .two:
            mTeam = (teamTwo?.getValue())!
        }
        
        let playersOne = teamOne?.getValue()?.players?.map({ player -> String in
            return player.person?.getId() ?? (player.person?.getValue()?.id)!
        })
        Print.m("Match.teamOne.players: \(playersOne)")
        
        let playersTwo = teamTwo?.getValue()?.players?.map({ player -> String in
            return player.person?.getId() ?? (player.person?.getValue()?.id)!
        })
        Print.m("Match.teamTwo.players: \(playersTwo)")
        
        for player in mPlayersList {
            for teamPlayer in mTeam.players ?? [] {
                if player.getId() ?? player.getValue()?.id == teamPlayer.person?.getId() ?? teamPlayer.person?.getValue()?.id {
                    resultArray.append(player)
                }
            }
        }
        
        return resultArray
    }
    
    mutating func setPlaingTeamPlayers(team: Team, newTeamPlayers: [IdRefObjectWrapper<Person>]) {
        var newPlayers = [IdRefObjectWrapper<Person>]()
        
        var plaingTeamPlayers: [IdRefObjectWrapper<Person>]!
        
        if team.id == teamOne?.getId() ?? teamOne?.getValue()?.id {
            plaingTeamPlayers = getPlaingTeamPlayers(team: .two)
        } else
        if team.id == teamTwo?.getId() ?? teamTwo?.getValue()?.id {
            plaingTeamPlayers = getPlaingTeamPlayers(team: .one)
        } else {
            assertionFailure("NOT VALID TEAM")
        }
        
        newPlayers.append(contentsOf: plaingTeamPlayers)
        newPlayers.append(contentsOf: newTeamPlayers)
        
        playersList = newPlayers
    }
    
    mutating func setPlaingTeamPlayers(team: TeamEnum, newTeamPlayers: [String]) {
        var newPlayers = [IdRefObjectWrapper<Person>]()
        
        var plaingTeamPlayers: [IdRefObjectWrapper<Person>]!
        
        switch team {
        case .one:
            plaingTeamPlayers = getPlaingTeamPlayers(team: .two)
        case .two:
            plaingTeamPlayers = getPlaingTeamPlayers(team: .one)
        }
        
        newPlayers.append(contentsOf: plaingTeamPlayers)
        newPlayers.append(contentsOf: newTeamPlayers.map { IdRefObjectWrapper<Person>($0) })
        
        playersList = newPlayers
    }
    
}
