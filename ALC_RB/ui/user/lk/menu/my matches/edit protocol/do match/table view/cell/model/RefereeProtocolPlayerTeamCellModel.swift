//
//  RefereeProtocolPlayerTeamCellModel.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class RefereeProtocolPlayerTeamCellModel {
    
    // DEPRECATED: player is deprecated
//    var player: DEPRECATED?
    var person: Person?
    var eventsModel: RefereeProtocolPlayerEventsModel?
    
    init(person: Person, eventsModel: RefereeProtocolPlayerEventsModel) {
        self.person = person
        self.eventsModel = eventsModel
    }
    
    init() { } 
    
}

extension RefereeProtocolPlayerTeamCellModel : CellModel { }
