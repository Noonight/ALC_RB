//
//  ScheduleMatchModelItem.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 17.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension MatchScheduleModelItem: CellModel {}

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
    
    var dateTime: String? {
        return "\(date ?? "") : \(time ?? "")"
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
    
    var firstRefereeName: String? {
        return match.referees?.filter { $0.type == Referee.rType.firstReferee }.first?.person?.getValue()?.getFullName()
    }
    
    var secondRefereeName: String? {
        return match.referees?.filter { $0.type == Referee.rType.secondReferee }.first?.person?.getValue()?.getFullName()
    }
    
    var thirdRefereeName: String? {
        return match.referees?.filter { $0.type == Referee.rType.thirdReferee }.first?.person?.getValue()?.getFullName()
    }
    
    var timekeeperRefereeName: String? {
        return match.referees?.filter { $0.type == Referee.rType.timekeeper }.first?.person?.getValue()?.getFullName()
    }
    
    var leagueName: String? {
        return match.league?.getValue()?.name
    }
    
}
