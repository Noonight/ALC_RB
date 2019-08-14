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
    
    init() {
        self.firstItem = .none
        self.secondItem = .none
        self.thirdItem = .none
    }
    
    mutating func addState(_ state: PenaltyState) -> Bool {
        if firstItem == .none
        {
            firstItem = state
            return true
        }
        if secondItem == .none
        {
            secondItem = state
            return true
        }
        if thirdItem == .none
        {
            thirdItem = state
            return true
        }
        return false
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
