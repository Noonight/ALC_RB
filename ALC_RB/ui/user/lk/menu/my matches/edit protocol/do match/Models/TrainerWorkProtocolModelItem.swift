//
//  TrainerProtocolModelItem.swift
//  ALC_RB
//
//  Created by ayur on 17.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TrainerWorkProtocolModelItem {
    
    let person: Person
    let yellowCards: Int?
    let redCards: Int?
    
    init(trainer: Person, yellowCards: Int? = nil, redCards: Int? = nil) {
        self.person = trainer
        self.yellowCards = yellowCards
        self.redCards = redCards
    }
    
    var name: String? {
        return self.person.getSurnameNP()
    }
    
    var isYellowCard: Bool {
        return yellowCards ?? 0 > 0 ? true : false
    }
    
    var isRedCard: Bool {
        return redCards ?? 0 > 0 ? true : false
    }
    
    var countOfYellowCards: Int? {
        return self.yellowCards
    }
    
    var countOfRedCards: Int? {
        return self.redCards
    }
}
