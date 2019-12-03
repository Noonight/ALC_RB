//
//  LeagueDetailModel.swift
//  ALC_RB
//
//  Created by ayur on 03.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct LeagueDetailModel {
    let tourney: Tourney
    let league: League
    
    init(tourney: Tourney, league: League) {
        self.tourney = tourney
        self.league = league
    }
}


