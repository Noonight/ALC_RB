//
//  ModalPenaltySeriesVM.swift
//  ALC_RB
//
//  Created by ayur on 13.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class ModalPenaltySeriesVM {
    
    // MARK: VAR & LET
    
    var teamOneCountOfPenalties = 0
    var teamTwoCountOfPenalties = 0
    var teamOneData: [GroupPenaltyState] = []
    var teamTwoData: [GroupPenaltyState] = []
    var currentTurn: PenaltyTurn = .none
    
    // MARK: PREPARE
    
    func prepareTeamCountOfPenaltiesFor(team: TeamEnum) -> Int {
        if team == .one
        {
            return teamOneCountOfPenalties
        }
        if team == .two
        {
            return teamTwoCountOfPenalties
        }
        return 0
    }
    
    func prepareTableDataFor(team: TeamEnum) -> [GroupPenaltyState] {
        if team == .one
        {
            return teamOneData
        }
        if team == .two
        {
            return teamTwoData
        }
        return []
    }
    
}
