//
//  ScheduleMatchModelItem.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 17.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
 
final class MatchScheduleModelItem {
    
    let match: Match
    
    init(match: Match) {
        self.match = match
    }
    
    var date: String? {
        return match.date?.toFormat(DateFormats.local.rawValue)
    }
    var time: String? {
        return match.date?.toFormat(DateFormats.localTime.rawValue)
    }
    var score: String? {
        return match.score
    }
    var place: String? {
        return match.place?.getValue()?.name
    }
    var tour: String? {
        return match.tour
    }
    var winner: String? {
        return match.winner
    }
    var isPlayed: Bool {
        return match.played ?? false
    }
    var teamOneName: String? {
        return match.teamOne?.getValue()?.name
    }
    var teamTwoName: String? {
        return match.teamTwo?.getValue()?.name
    }
    
}
