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
    var lastAddedEvent: LIEvent?
    
    init(events: [LIEvent]) {
        self.events = events
    }
    
    func add(_ event: LIEvent) {
        events.append(event)
        lastAddedEvent = event
    }
    
    func removeLastAdded() {
        if lastAddedEvent != nil
        {
            self.events.removeAll { event -> Bool in
                return event == lastAddedEvent!
            }
        }
    }
    
    func removeFirst(_ event: LIEvent) {
        let index = events.index(of: event)!
        events.remove(at: index)
    }
    
    func updateEvents(events: [LIEvent]) {
        if isNeedUpdate(events: events)
        {
            self.events = events
        }
    }
    
    // MARK: HELPERS
    
    private func isNeedUpdate(events: [LIEvent]) -> Bool {
        for i in self.events
        {
            for j in events
            {
                if i != j {
                    return true
                }
            }
        }
        return false
    }
}

extension LIEvent: Equatable {
    static func ==(lhs: LIEvent, rhs: LIEvent) -> Bool {
        return lhs.id == rhs.id && lhs.eventType == rhs.eventType && lhs.player == rhs.player && lhs.time == rhs.time
    }
    static func !=(lhs: LIEvent, rhs: LIEvent) -> Bool {
        return lhs.id != rhs.id
                || lhs.eventType != rhs.eventType
                || lhs.player != rhs.player
                || lhs.time != rhs.time
    }
}
