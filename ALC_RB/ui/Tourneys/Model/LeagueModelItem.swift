//
//  LeagueModelItem.swift
//  ALC_RB
//
//  Created by ayur on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension LeagueModelItem: CellModel {}

final class LeagueModelItem {
    
    let league: _League
    
    init(league: _League) {
        self.league = league
    }
    
    var name: String? {
        return league.name
    }
    var beginDate: String? {
        return league.beginDate?.toFormat(DateFormats.local.rawValue)
    }
    var endDate: String? {
        return league.endDate?.toFormat(DateFormats.local.rawValue)
    }
}
