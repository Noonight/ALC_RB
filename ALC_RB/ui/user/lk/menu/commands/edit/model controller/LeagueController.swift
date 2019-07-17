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
}
