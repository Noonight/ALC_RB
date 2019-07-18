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
        for i in 0...self.league.teams.count {
            if self.league.teams[i].id == id {
                self.league.teams[i].players.append(player)
            }
        }
    }
    func editTeamPlayersById(teamId: String, players: [Player]) {
        for i in 0...self.league.teams.count - 1 {
            Print.m("index i = \(i) || count of players = \(self.league.teams.count) \n team id is \(self.league.teams[i].id) == param team id is \(teamId)")
            if self.league.teams[i].id == teamId {
                self.league.teams[i].players = players
            }
        }
    }
}
