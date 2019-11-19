//
//  CommandModelItem.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension TeamModelItem: CellModel {}

final class TeamModelItem {
    
    var team: Team!
    
    init(team: Team) {
        self.team = team
    }
    
    var name: String? {
        return team.name
    }
    
    var creatorName: String? {
        return team.creator?.getValue()?.name
    }
    
    var tourneyLeagueName: String? {
        return "\(team.league?.getValue()?.tourney?.getValue()?.name). \(team.league?.getValue()?.name)"
    }
    
    var leagueBeginEndDate: String? {
        return "\(team.league?.getValue()?.beginDate!.toFormat(.local)) - \(team.league?.getValue()?.endDate!.toFormat(.local))"
    }
    
    var leagueTransferBeginEndDate: String? {
        return "\(team.league?.getValue()?.transferBegin!.toFormat(.local)) - \(team.league?.getValue()?.transferEnd!.toFormat(.local))"
    }
    
    var leagueStatus: String? {
        return "\(team.league?.getValue()?.status!.ru())"
    }
    
    var maxCountOfPlayers: String? {
        return "\(team.league?.getValue()?.playersMax)"
    }
    
}
