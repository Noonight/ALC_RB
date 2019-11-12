//
//  ScheduleModelItem.swift
//  ALC_RB
//
//  Created by mac on 01.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class ScheduleModelItem {
    
    var match: Match
    var teamOne: Team?
    var teamTwo: Team?
    var clubOne: Club?
    var clubTwo: Club?
    
    init(match: Match, teamOne: Team?, teamTwo: Team?) {
        self.match = match
        self.teamOne = teamOne
        self.teamTwo = teamTwo
    }
    
    var score: String? {
        return match.score
    }
    
    var played: Bool {
        return match.played ?? false
    }
    
    var teamOneName: String {
        return teamOne?.name ?? Constants.Texts.TEAM_IS_NOT
    }
    
    var teamTwoName: String {
        return teamTwo?.name ?? Constants.Texts.TEAM_IS_NOT
    }
    
    var clubOneLogo: String? {
        return clubOne?.logo
    }
    
    var clubTwoLogo: String? {
        return clubTwo?.logo
    }
    
    var date: String? {
        return match.date?.toFormat(DateFormats.local.rawValue)
    }
    
    var time: String? {
        return match.date?.toFormat(DateFormats.localTime.rawValue)
    }
    
}
