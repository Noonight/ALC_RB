//
//  GroupPenaltyState.swift
//  ALC_RB
//
//  Created by ayur on 13.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct GroupPenaltyState {
    var firstItem: PenaltyState = .none
    var secondItem: PenaltyState = .none
    var thirdItem: PenaltyState = .none
    
    init(first: PenaltyState, second: PenaltyState, third: PenaltyState) {
        self.firstItem = first
        self.secondItem = second
        self.thirdItem = third
    }
}

enum PenaltyState: Int {
    case success = 1
    case failure = -1
    case none = 0
}

enum PenaltyTurn: Int {
    case one = -1 // left
    case two = 1 // right
    case none = 0 // need to tap
}
