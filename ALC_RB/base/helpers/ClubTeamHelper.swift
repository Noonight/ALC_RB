//
//  ClubTeamHelper.swift
//  ALC_RB
//
//  Created by mac on 08.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

enum TeamEnum: Int {
    case one = 1
    case two = 2
}

class ClubTeamHelper {
    static func getClubIdByTeamId(_ teamId: String, league: League) -> String {
        return league.teams?.filter({ (team) -> Bool in
            return team.id == teamId
        }).first?.id ?? "club id \n not found"
    }
    
//    static func getTeamTitle(league: League, match: Match, team: TeamEnum) -> String {
//        switch team {
//        case .one:
//            return league.teams?.filter({ (team) -> Bool in
//                return team.id == match.teamOne?.getId() ?? match.teamOne?.getValue()?.id ?? ""
//            }).first?.name ?? "Team name \n one not found"
//        case .two:
//            return league.teams?.filter({ (team) -> Bool in
//                return team.id == match.teamTwo ?? match.teamTwo?.getValue()?.id ?? ""
//            }).first?.name ?? "Team name \n two not found"
//        }
//    }
    
//    static func getClubIdByTeamId(_ teamId: String, league: League) -> String {
//        return league.teams?.filter({ (team) -> Bool in
//            return team.id == teamId
//        }).first?.id ?? "club id \n not found"
//    }
//
//    static func getTeamTitle(league: League, match: Match, team: TeamEnum) -> String {
//        switch team {
//        case .one:
//            return league.teams?.filter({ (team) -> Bool in
//                return team.id == match.teamOne
//            }).first?.name ?? "Team name \n one not found"
//        case .two:
//            return league.teams?.filter({ (team) -> Bool in
//                return team.id == match.teamTwo
//            }).first?.name ?? "Team name \n two not found"
//        }
//    }
    
}
