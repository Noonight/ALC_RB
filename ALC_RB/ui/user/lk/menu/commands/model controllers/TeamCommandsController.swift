//
//  TeamCommandsController.swift
//  ALC_RB
//
//  Created by ayur on 10.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class TeamCommandsController {
    var teams: [Team]!
    init(teams: [Team]) {
        self.teams = teams
    }
    func setPlayersByTeamId(id: String, players: [Player]) {
        for i in 0..<teams.count {
            if teams[i].id == id {
                teams[i].players = players
            }
        }
    }
}
