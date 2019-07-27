//
//  RefereeProtocolPlayersCellModel.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class RefereeProtocolPlayerEventsModel {
    
    var goals = 0
    var successfulPenaltyGoals = 0
    var failurePenaltyGoals = 0
    var yellowCards = 0
    var redCard = false
    
    init(goals: Int, successfulPenaltyGoals: Int, failurePenaltyGoals: Int, yellowCards: Int, redCard: Bool) {
        self.goals = goals
        self.successfulPenaltyGoals = successfulPenaltyGoals
        self.failurePenaltyGoals = failurePenaltyGoals
        self.yellowCards = yellowCards
        self.redCard = redCard
    }
    
    init() { }
    
}
