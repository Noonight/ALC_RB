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
        let strBuilder = StrBuilder<Team.CodingKeys>()
            .setSeparatorMode(.independently)
            .add(team.league?.getValue()?.tourney?.getValue()?.name)
            .add(.dot)
            .add(.space)
            .add(team.league?.getValue()?.name)
        return strBuilder.getStr()
    }
    
    var leagueBeginEndDate: String? {
        let strBuilder = StrBuilder<Team.CodingKeys>()
            .setSeparatorMode(.independently)
            .add(team.league?.getValue()?.beginDate!.toFormat(.local))
            .add(" - ")
            .add(team.league?.getValue()?.endDate!.toFormat(.local))
        return strBuilder.getStr()
    }
    
    var leagueTransferBeginEndDate: String? {
        let strBuilder = StrBuilder<Team.CodingKeys>()
            .setSeparatorMode(.independently)
            .add(team.league?.getValue()?.transferBegin!.toFormat(.local))
            .add(" - ")
            .add(team.league?.getValue()?.transferEnd!.toFormat(.local))
        return strBuilder.getStr()
    }
    
    var leagueStatus: String? {
        let strBuilder = StrBuilder<Team.CodingKeys>()
            .setSeparatorMode(.independently)
            .add(team.league?.getValue()?.status!.ru())
        return strBuilder.getStr()
    }
    
    var maxCountOfPlayers: String? {
        if let maxPlayers = team.league?.getValue()?.playersMax {
            return String(maxPlayers)
        }
        return nil
    }
    
}
