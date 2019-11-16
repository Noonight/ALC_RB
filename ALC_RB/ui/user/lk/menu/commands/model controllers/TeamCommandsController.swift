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
    // DEPRECATED team does not contains players
//    func setPlayersByTeamId(id: String, players: [Person]) {
//        for i in 0..<teams.count {
//            if teams[i].id == id {
//                teams[i].players = players
//            }
//        }
//    }
//    func getTeamById(id: String) -> Team? {
//        return teams.filter({ team -> Bool in
//            return team.id == id
//        }).first
//    }
//    func addPlayerById(id: String, player: Person) {
//        for i in 0..<teams.count {
//            if teams[i].id == id {
//                teams[i].players.append(Person)
//            }
//        }
//    }
}
