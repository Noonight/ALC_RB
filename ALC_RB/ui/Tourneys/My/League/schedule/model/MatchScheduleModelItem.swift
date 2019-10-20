//
//  ScheduleMatchModelItem.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 17.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
 
final class MatchScheduleModelItem {
    
    let match: _Match
    var teamOne: _Team?
    var teamTwo: _Team?
    
    init(match: _Match, teamOne: _Team?, teamTwo: _Team?) {
        self.match = match
        self.teamOne = teamOne
        self.teamTwo = teamTwo
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
        return match.place
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
    
}
