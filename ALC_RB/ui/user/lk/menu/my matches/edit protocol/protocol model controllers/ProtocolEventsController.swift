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
    var lastDeletedEvent: LIEvent?
    
    init(events: [LIEvent]) {
        self.events = events
    }
    
    func prepareNotAutoGoalFoulEvents() -> [LIEvent] {
        return events.filter({ event -> Bool in
            return event.getSystemEventType() != .autoGoal || event.getSystemEventType() != .foul
        })
    }
    
    func prepareAutoGoalEvents() -> [LIEvent] {
        return events.filter({ event -> Bool in
            return event.getSystemEventType() == .autoGoal
        })
    }
    
    func prepareFoulEvents() -> [LIEvent] {
        return events.filter({ event -> Bool in
            return event.getSystemEventType() == .foul
        })
    }
    
    func add(_ event: LIEvent) {
        events.append(event)
        lastAddedEvent = event
    }
    
    func removeFirstWith(event: EventMaker.DeleteEvent) -> Bool {
        for i in 0...events.count - 1
        {
            if events[i].player == event.playerId && events[i].getSystemEventType() == event.eventType
            {
                events.remove(at: i)
                return true
            }
        }
        return false
    }
    
    func restoreLastDeleted() {
        if lastDeletedEvent != nil
        {
            self.events.append(lastDeletedEvent!)
        }
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
        self.events.removeAll()
        self.events.append(contentsOf: events)
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
