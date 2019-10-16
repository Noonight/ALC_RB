//
//  TourneyModelItem.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 15.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension TourneyModelItem : CellModel {}

final class TourneyModelItem {
    
    private let tourney: Tourney
    var leagues: [LeagueModelItem]?
    
    init(tourney: Tourney, leagues: [LeagueModelItem]?) {
        self.tourney = tourney
        self.leagues = leagues
    }
    
    var name: String? {
        return tourney.name
    }
    var beginDate: String? {
        return tourney.beginDate?.toFormat(DateFormats.local.rawValue)
    }
    var endDate: String? {
        return tourney.endDate?.toFormat(DateFormats.local.rawValue)
    }
    
}
