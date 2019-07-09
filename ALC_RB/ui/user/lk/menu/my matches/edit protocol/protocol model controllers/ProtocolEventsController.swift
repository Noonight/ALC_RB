//
//  ProtocolEventsController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 08/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class ProtocolEventsController {
    var events: [LIEvent] = []
    init(events: [LIEvent]) {
        self.events = events
    }
    
    func add(_ event: LIEvent) {
        events.append(event)
    }
    
    func removeFirst(_ event: LIEvent) {
        let index = events.index(of: event)!
        events.remove(at: index)
    }
}

extension LIEvent: Equatable {
    static func ==(lhs: LIEvent, rhs: LIEvent) -> Bool {
        return lhs.id == rhs.id && lhs.eventType == rhs.eventType && lhs.player == rhs.player && lhs.time == rhs.time
    }
}
