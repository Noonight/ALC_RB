//
//  LeagueController.swift
//  ALC_RB
//
//  Created by ayur on 18.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class LeagueController {
    var league: League
    init(league: League) {
        self.league = league
    }
    func addPlayerToTeamById(id: String, player: Player) {
        for i in 0...self.league.teams!.count {
            if self.league.teams![i].id == id {
                self.league.teams![i].players.append(player)
            }
        }
    }
    func editTeamPlayersById(teamId: String, players: [Player]) {
        for i in 0...self.league.teams!.count - 1 {
            Print.m("index i = \(i) || count of players = \(self.league.teams!.count) \n team id is \(self.league.teams![i].id) == param team id is \(teamId)")
            if self.league.teams![i].id == teamId {
                self.league.teams![i].players = players
            }
        }
    }
    func setTeamPlayersById(teamId: String, players: [Player]) {
        guard let teams = league.teams else { return }
        for i in 0..<teams.count {
            if teams[i].id == teamId {
                league.teams![i].players = players
            }
        }
    }
    func setTeamPlayerById(playerId: String, player: Player) {
        guard let teams = league.teams else { return }
        for i in 0..<teams.count {
            for j in 0..<teams[i].players.count {
                if playerId == teams[i].players[j].playerID {
                    league.teams![i].players[j] = player
                }
            }
        }
    }
    
    func getPlayerById(_ id: String) -> Player? {
        let team = league.teams!.filter { team -> Bool in
            return team.players.contains(where: { player -> Bool in
                return player.playerID == id
            })
        }.first
        return team?.players.filter({ player -> Bool in
            return player.playerID == id
        }).first
    }
    
    func getTeamByPlayerId(_ id: String) -> Team? {
        return league.teams!.filter({ team -> Bool in
            return team.players.contains(where: { player -> Bool in
                return player.playerID == id
            })
        }).first
    }
}
