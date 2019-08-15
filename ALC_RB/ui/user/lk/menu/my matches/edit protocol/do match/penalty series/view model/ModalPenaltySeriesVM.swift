//
//  ModalPenaltySeriesVM.swift
//  ALC_RB
//
//  Created by ayur on 13.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class ModalPenaltySeriesVM {
    enum Texts {
        static let NOT_FOUND_TITLE = "Title not found..."
    }
    
    // MARK: VAR & LET
    
    var teamOneTitle = ""
    var teamTwoTitle = ""
    
    // penalty series team events 
    var events: [LIEvent] = []
    var teamOneCountOfPenalties = 0
    var teamTwoCountOfPenalties = 0
    var teamOneScore = 0
    var teamTwoScore = 0
    var teamOneData: [GroupPenaltyState] = []
    var teamTwoData: [GroupPenaltyState] = []
    var currentTurn: PenaltyTurn = .none
    var match: LIMatch!
    
    // MARK: INIT
    
    public func initData(teamOneTitle: String, teamTwoTitle: String, events: [LIEvent], match: LIMatch) {
        self.teamOneTitle = teamOneTitle
        self.teamTwoTitle = teamTwoTitle
        self.teamOneScore = self.getSuccessPenalties(events: self.getEventsWith(team: .one, events: events)).count
        self.teamTwoScore = self.getSuccessPenalties(events: self.getEventsWith(team: .two, events: events)).count
        self.events = events
        self.match = match
    }
    
    // MARK: UPDATE
    
//    func updatePenaltyScore(penaltyState: PenaltyState) {
//        if self.currentTurn == .one
//        {
//            if penaltyState == .success
//            {
//                self.teamOneScore += 1
//            }
//        }
//        if self.currentTurn == .two
//        {
//            if penaltyState == .success
//            {
//                self.teamTwoScore += 1
//            }
//        }
//    }
    
    func updatePenaltyStatusFor(penaltyState: PenaltyState) {
//        if self.currentTurn == .one
//        {
//            if teamOneData.count == 0
//            {
//                teamOneData.append(GroupPenaltyState(first: .none, second: .none, third: .none))
//            }
//            for i in 0...teamOneData.count
//            {
//                if teamOneData.count == i && teamOneData.last?.thirdItem != .none
//                {
//                    teamOneData.append(GroupPenaltyState(first: .none, second: .none, third: .none))
//                    self.updatePenaltyStatusFor(penaltyState: penaltyState)
//                    break
//                }
//                if teamOneData[i].firstItem == .none
//                {
//                    teamOneData[i].firstItem = penaltyState
//                    break
//                }
//                if teamOneData[i].secondItem == .none
//                {
//                    teamOneData[i].secondItem = penaltyState
//                    break
//                }
//                if teamOneData[i].thirdItem == .none
//                {
//                    teamOneData[i].thirdItem = penaltyState
//                    break
//                }
//            }
//        }
//        if self.currentTurn == .two
//        {
//            if teamTwoData.count == 0
//            {
//                teamTwoData.append(GroupPenaltyState(first: .none, second: .none, third: .none))
//            }
//            for i in 0...teamTwoData.count
//            {
//                if teamTwoData.count == i && teamTwoData.last?.thirdItem != .none
//                {
//                    teamTwoData.append(GroupPenaltyState(first: .none, second: .none, third: .none))
//                    self.updatePenaltyStatusFor(penaltyState: penaltyState)
//                    break
//                }
//                if teamTwoData[i].firstItem == .none
//                {
//                    teamTwoData[i].firstItem = penaltyState
//                    break
//                }
//                if teamTwoData[i].secondItem == .none
//                {
//                    teamTwoData[i].secondItem = penaltyState
//                    break
//                }
//                if teamTwoData[i].thirdItem == .none
//                {
//                    teamTwoData[i].thirdItem = penaltyState
//                    break
//                }
//            }
//        }
        
        self.addEvent(penaltyState: penaltyState)
    }
    
    // MARK: PREPARE
    
    func prepareTeamTitle(team: TeamEnum) -> String {
        if team == .one
        {
            return teamOneTitle
        }
        if team == .two
        {
            return teamTwoTitle
        }
        return Texts.NOT_FOUND_TITLE
    }
    
    func prepareTeamPenaltyScore(team: TeamEnum) -> Int {
        if team == .one
        {
            self.teamOneScore = self.getSuccessPenalties(events: self.getEventsWith(team: .one, events: events)).count
            return teamOneScore
        }
        if team == .two
        {
            self.teamTwoScore = self.getSuccessPenalties(events: self.getEventsWith(team: .two, events: events)).count
            return teamTwoScore
        }
        return 0
    }
    
    func prepareTeamCountOfPenaltiesFor(team: TeamEnum) -> Int {
        if team == .one
        {
            self.teamOneCountOfPenalties = self.getPenalties(events: self.getEventsWith(team: .one, events: self.events)).count
            return teamOneCountOfPenalties
        }
        if team == .two
        {
            self.teamTwoCountOfPenalties = self.getPenalties(events: self.getEventsWith(team: .two, events: self.events)).count
            return teamTwoCountOfPenalties
        }
        return 0
    }
    
    func prepareTableDataFor(team: TeamEnum) -> [GroupPenaltyState] {
        return self.getGroupPenaltyModelFor(team: team)
    }
    
    func prepareTeamPenalties(team: TeamEnum) -> [LIEvent] {
        return getPenalties(events: getEventsWith(team: team, events: self.events))
    }
    
}

// MARK: HELPERS

extension ModalPenaltySeriesVM {
    
    private func addEvent(penaltyState: PenaltyState) {
        if penaltyState == .success
        {
            if currentTurn == .one
            {
                guard let teamId = self.match.teamOne else { return }
                self.events.append(LIEvent(
                    matchID: self.match.id,
                    eventType: .penaltySeriesSuccess,
                    playerID: teamId,
                    time: .penaltySeries)
                )
            }
            if currentTurn == .two
            {
                guard let teamId = self.match.teamTwo else { return }
                self.events.append(LIEvent(
                    matchID: self.match.id,
                    eventType: .penaltySeriesSuccess,
                    playerID: teamId,
                    time: .penaltySeries)
                )
            }
        }
        if penaltyState == .failure
        {
            if currentTurn == .one
            {
                guard let teamId = self.match.teamOne else { return }
                self.events.append(LIEvent(
                    matchID: self.match.id,
                    eventType: .penaltySeriesFailure,
                    playerID: teamId,
                    time: .penaltySeries)
                )
            }
            if currentTurn == .two
            {
                guard let teamId = self.match.teamTwo else { return }
                self.events.append(LIEvent(
                    matchID: self.match.id,
                    eventType: .penaltySeriesFailure,
                    playerID: teamId,
                    time: .penaltySeries)
                )
            }
        }
    }
    
    private func getGroupPenaltyModelFor(team: TeamEnum) -> [GroupPenaltyState] {
        var resultArray: [GroupPenaltyState] = []
        var teamPenalties: [LIEvent] = []
        var localCounter = 0
        if team == .one
        {
            teamPenalties = getPenalties(events: getEventsWith(team: .one, events: self.events))
            var penaltyStateElement = GroupPenaltyState(first: .none, second: .none, third: .none)
            for event in teamPenalties
            {
                if event.getEventType() == .team(.penaltySeriesSuccess)
                {
                    penaltyStateElement.addState(.success)
                }
                if event.getEventType() == .team(.penaltySeriesFailure)
                {
                    penaltyStateElement.addState(.failure)
                }
                
                localCounter += 1
                if localCounter == 3
                {
                    resultArray.append(penaltyStateElement)
                    penaltyStateElement = GroupPenaltyState(first: .none, second: .none, third: .none)
                    localCounter = 0
                }
            }
            resultArray.append(penaltyStateElement)
        }
        if team == .two
        {
            teamPenalties = getPenalties(events: getEventsWith(team: .two, events: self.events))
            var penaltyStateElement = GroupPenaltyState(first: .none, second: .none, third: .none)
            for event in teamPenalties
            {
                if event.getEventType() == .team(.penaltySeriesSuccess)
                {
                    penaltyStateElement.addState(.success)
                }
                if event.getEventType() == .team(.penaltySeriesFailure)
                {
                    penaltyStateElement.addState(.failure)
                }
                
                localCounter += 1
                if localCounter == 3
                {
                    resultArray.append(penaltyStateElement)
                    penaltyStateElement = GroupPenaltyState(first: .none, second: .none, third: .none)
                    localCounter = 0
                }
            }
            resultArray.append(penaltyStateElement)
        }
        if resultArray.last?.hasOne() == false
        {
            resultArray.removeLast()
        }
        return resultArray
    }
    
//    private func getGroupPenaltyModel(team: TeamEnum) -> [GroupPenaltyState] {
//
//        func addElement(element: inout GroupPenaltyState, checkEvent: LIEvent) -> Bool {
//            if element.isFull() == false
//            {
//                if checkEvent.getEventType() == .team(.penaltySeriesSuccess)
//                {
//                    return element.addState(.success)
//                }
//                if checkEvent.getEventType() == .team(.penaltySeriesFailure)
//                {
//                    return element.addState(.failure)
//                }
//            }
//            if element.isFull() == true
//            {
//                return false
//            }
//            return false
//        }
//
//        var resultArray: [GroupPenaltyState] = []
//        var teamPenalties: [LIEvent] = []
//        var localCounter = 0
//        if team == .one
//        {
//            teamPenalties = getPenalties(events: getEventsWith(team: .one, events: self.events))
//            var penaltyStateElement = GroupPenaltyState()
//            if teamPenalties.count != 0
//            {
//                for i in 0...teamPenalties.count - 1
//                {
////                    if teamPenalties
//                }
//            }
//        }
//        if team == .two
//        {
//            teamPenalties = getPenalties(events: getEventsWith(team: .two, events: self.events))
//            var penaltyStateElement = GroupPenaltyState()
//            if teamPenalties.count != 0
//            {
//                for i in 0...teamPenalties.count - 1
//                {
//                    if teamPenalties[i].getEventType() == .team(.penaltySeriesSuccess)
//                    {
//                        penaltyStateElement.addState(.success)
//                    }
//                    if teamPenalties[i].getEventType() == .team(.penaltySeriesFailure)
//                    {
//                        penaltyStateElement.addState(.failure)
//                    }
//
//                    localCounter += 1
//                    if localCounter == 3
//                    {
//                        resultArray.append(penaltyStateElement)
//                        penaltyStateElement = GroupPenaltyState()
//                        localCounter = 0
//                    }
//                    else
//                    if penaltyStateElement.isFull() == false && (((teamPenalties.count - 1) - i == 1) || ((teamPenalties.count - 1) - i == 0))
//                    {
//                        resultArray.append(penaltyStateElement)
//                        penaltyStateElement = GroupPenaltyState()
//                    //                        localCounter = 0
//                    }
//                }
//            }
//        }
//        return resultArray
//    }
    
    private func getSuccessPenalties(events: [LIEvent]) -> [LIEvent] {
        return events.filter({ event -> Bool in
            return event.getEventType() == .team(.penaltySeriesSuccess)
        })
    }
    
    private func getPenalties(events: [LIEvent]) -> [LIEvent] {
        return events.filter({ event -> Bool in
            return event.getEventType() == .team(.penaltySeriesSuccess) || event.getEventType() == .team(.penaltySeriesFailure)
        })
    }
    
    private func getEventsWith(team: TeamEnum, events: [LIEvent]) -> [LIEvent] {
        if team == .one
        {
            return events.filter({ event -> Bool in
                return event.player == self.match.teamOne
            })
        }
        if team == .two
        {
            return events.filter({ event -> Bool in
                return event.player == self.match.teamTwo
            })
        }
        return []
    }
}
