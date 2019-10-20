//
//  LeagueDetailModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 20.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class _LeagueDetailModel {
    
    var league: LeagueModelItem?
    var matches: [MatchScheduleModelItem]?
    
    init(league: LeagueModelItem, matches: [MatchScheduleModelItem]?) {
        self.league = league
        self.matches = matches
    }
    
    init() {
        self.league = nil
        self.matches = nil
    }
    
}
