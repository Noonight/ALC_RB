//
//  ProtocolEventsController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 08/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class ProtocolEventsController {
    
    var events: [Event] = []
    var lastAddedEvent: Event?
    var lastDeletedEvent: Event?
    
    init(events: [Event]) {
        self.events = events
    }
    
    func deletePenaltySeriesEvents() {
        self.events.removeAll { event -> Bool in
            return event.time == .penaltySeries
        }
    }
    
    func addPenaltySeriesEvents(penaltySeriesEvents: [Event]) {
        self.events.append(contentsOf: penaltySeriesEvents)
    }
    
    func deleteLastFoulsBeforeCount(_ count: Int) {
        let oldCount = events.count
        
        var counter = 0
        var forDeleteEvents: [Event] = []
        
        if oldCount < count
        {
            for event in events
            {
//                if event.type == .foul
                if event.type == .foul
                {
                    counter += 1
                    Print.m(counter)
                    if counter > oldCount && counter <= count
                    {
                        Print.m(counter)
                        Print.m(event.type?.getTitle())
                        forDeleteEvents.append(event)
                    }
                }
                
            }
        }
        Print.m(forDeleteEvents)
    }
    
    // for view model, protocol for all users
    func getLastTime() -> String {
        if events.contains(where: { $0.time == .extraTime }) == true {
            return "в дополнительное время"
        } else if events.contains(where: { $0.time == .penaltySeries }) == true {
            return "во время серии пенальти"
        } else {
            return "в основное время"
        }
    }
    
    func preparePlayerEvents() -> [Event] {
        return events.filter({ event -> Bool in
            return event.type == .goal || event.type == .penalty || event.type == .penaltyFailure || event.type == .redCard || event.type == .yellowCard
        })
    }
    
    func preparePlayerEventsInTime(time: Event.Time) -> [Event] {
        return events.filter({ event -> Bool in
            return (event.type == .goal || event.type == .penalty || event.type == .penaltyFailure || event.type == .redCard || event.type == .yellowCard) && event.time == time
        })
    }
    
    // TODO: Team events are not right
    func prepareTeamEvents() -> [Event] {
        return events.filter({ event -> Bool in
            return event.type == .autoGoal || event.type == .foul || event.type == .penaltySeriesSuccess || event.type == .penaltySeriesFailure
        })
    }
    
    func prepareTeamEventsInTime(time: Event.Time) -> [Event] {
        var resultArray: [Event] = []
        for event in events
        {
            if event.time == time
            {
                if event.type == .autoGoal
                {
                    resultArray.append(event)
                }
                if event.type == .foul
                {
                    resultArray.append(event)
                }
                if event.type == .penaltySeriesSuccess
                {
                    resultArray.append(event)
                }
                if event.type == .penaltySeriesFailure
                {
                    resultArray.append(event)
                }
            }
        }
        return resultArray
    }
    
    func prepareNotAutoGoalFoulEvents() -> [Event] {
        return events.filter { $0.type != .autoGoal || $0.type != .foul }
//        return events.filter({ event -> Bool in
//            return event.getSystemEventType() != .autoGoal || event.getSystemEventType() != .foul
//        })
    }
    
    func prepareAutoGoalEvents() -> [Event] {
        return events.filter { $0.type == .autoGoal }
//        return events.filter({ event -> Bool in
//            return event.getSystemEventType() == .autoGoal
//        })
    }
    
    func prepareFoulEvents() -> [Event] {
        return events.filter { $0.type == .foul }
//        return events.filter({ event -> Bool in
//            return event.getSystemEventType() == .foul
//        })
    }
    
    func add(_ event: Event) {
        events.append(event)
        lastAddedEvent = event
    }
    
//    func removeFirstWith(event: EventMaker.DeleteEvent) -> Bool {
//        for i in 0...events.count - 1
//        {
//            if events[i].player?.getId() ?? events[i].player?.getValue()!.id == event.playerId && events[i].type == event.eventType {
//                events.remove(at: i)
//                return true
//            }
//        }
//        return false
//    }
    
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
    
    func removeFirst(_ event: Event) {
        let index = events.index(of: event)!
        events.remove(at: index)
    }
    
    func updateEvents(events: [Event]) {
        self.events.removeAll()
        self.events.append(contentsOf: events)
    }
}

extension Event: Equatable {
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type && lhs.player?.getId() ?? lhs.player?.getValue()!.id == rhs.player?.getId() ?? rhs.player?.getValue()!.id && lhs.time == rhs.time
    }
    static func !=(lhs: Event, rhs: Event) -> Bool {
        return lhs.id != rhs.id
                || lhs.type != rhs.type
                || lhs.player?.getId() ?? lhs.player?.getValue()!.id != rhs.player?.getId() ?? rhs.player?.getValue()!.id
                || lhs.time != rhs.time
    }
}
