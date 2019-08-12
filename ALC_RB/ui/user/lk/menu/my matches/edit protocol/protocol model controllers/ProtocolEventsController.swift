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
    
    func deleteLastFoulsBeforeCount(_ count: Int) {
        let oldCount = events.count
        
        var counter = 0
        var forDeleteEvents: [LIEvent] = []
        
        if oldCount < count
        {
            for event in events
            {
                if event.getEventType() == .team(.foul)
                {
                    counter += 1
                    Print.m(counter)
                    if counter > oldCount && counter <= count
                    {
                        Print.m(counter)
                        Print.m(event.getEventType().getTitle())
                        forDeleteEvents.append(event)
                    }
                }
                
            }
        }
        Print.m(forDeleteEvents)
    }
    
    // for view model, protocol for all users
    func getLastTime() -> String {
        if events.contains(where: { event -> Bool in
            return event.time == "Дополнительное время"
        }) == true
        {
            return "в дополнительное время"
        }
        else
        {
            return "в основное время"
        }
    }
    
    func preparePlayerEvents() -> [LIEvent] {
        return events.filter({ event -> Bool in
            return event.getEventType() == .player(.goal) || event.getEventType() == .player(.penalty) || event.getEventType() == .player(.penaltyFailure) || event.getEventType() == .player(.redCard) || event.getEventType() == .player(.yellowCard)
        })
    }
    
    func preparePlayerEventsInTime(time: EventTime) -> [LIEvent] {
        return events.filter({ event -> Bool in
            return (event.getEventType() == .player(.goal) || event.getEventType() == .player(.penalty) || event.getEventType() == .player(.penaltyFailure) || event.getEventType() == .player(.redCard) || event.getEventType() == .player(.yellowCard)) && event.getEventTime() == time
        })
    }
    
    func prepareTeamEvents() -> [LIEvent] {
        return events.filter({ event -> Bool in
            return event.getEventType() == .team(.autoGoal) || event.getEventType() == .team(.foul) || event.getEventType() == .team(.penaltySeriesSuccess) || event.getEventType() == .team(.penaltySeriesFailure)
        })
    }
    
    func prepareTeamEventsInTime(time: EventTime) -> [LIEvent] {
        var resultArray: [LIEvent] = []
        for event in events
        {
            if event.getEventTime() == time
            {
                if event.getEventType() == .team(.autoGoal)
                {
                    resultArray.append(event)
                }
                if event.getEventType() == .team(.foul)
                {
                    resultArray.append(event)
                }
                if event.getEventType() == .team(.penaltySeriesSuccess)
                {
                    resultArray.append(event)
                }
                if event.getEventType() == .team(.penaltySeriesFailure)
                {
                    resultArray.append(event)
                }
            }
        }
        return resultArray
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
            if events[i].player == event.playerId && events[i].getEventType() == event.eventType
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
