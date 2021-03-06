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
    var events: [Event] = []
    var teamOneCountOfPenalties = 0
    var teamTwoCountOfPenalties = 0
    var teamOneScore = 0
    var teamTwoScore = 0
    var teamOneData: [GroupPenaltyState] = []
    var teamTwoData: [GroupPenaltyState] = []
    var currentTurn: PenaltyTurn = .none
    var match: Match!
    
    // MARK: INIT
    
    public func initData(teamOneTitle: String, teamTwoTitle: String, events: [Event], match: Match) {
        self.teamOneTitle = teamOneTitle
        self.teamTwoTitle = teamTwoTitle
        self.events = events
        self.match = match
        self.teamOneScore = self.getSuccessPenalties(events: self.getEventsWith(team: .one, events: events)).count
        self.teamTwoScore = self.getSuccessPenalties(events: self.getEventsWith(team: .two, events: events)).count
    }
    
    // MARK: UPDATE
    
    func undoLastEvent() {
        if events.count != 0
        {
            for i in (0...events.count - 1).reversed()
            {
                if events[i].type! == .penaltySeriesSuccess || events[i].type! == .penaltySeriesFailure {
                    events.remove(at: i)
                    return
                }
            }
        }
    }
    
    func updatePenaltyStatusFor(penaltyState: PenaltyState) {
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
    
    func prepareTeamPenalties(team: TeamEnum) -> [Event] {
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
//                self.events.append(Event(
//                    matchID: self.match.id,
//                    eventType: .penaltySeriesSuccess,
//                    playerID: teamId,
//                    time: .penaltySeries)
//                )
                self.events.append(Event(id: self.match.id, type: Event.eType.penaltySeriesSuccess, player: nil, team: teamId, time: Event.Time.penaltySeries))
            }
            if currentTurn == .two
            {
                guard let teamId = self.match.teamTwo else { return }
//                self.events.append(Event(
//                    matchID: self.match.id,
//                    eventType: .penaltySeriesSuccess,
//                    playerID: teamId,
//                    time: .penaltySeries)
//                )
                self.events.append(Event(id: self.match.id, type: .penaltySeriesSuccess, player: nil, team: teamId, time: Event.Time.penaltySeries))
            }
        }
        if penaltyState == .failure
        {
            if currentTurn == .one
            {
                guard let teamId = self.match.teamOne else { return }
                self.events.append(Event(
                    id: self.match.id,
                    type: .penaltySeriesFailure,
                    player: nil,
                    team: teamId,
                    time: .penaltySeries)
                )
            }
            if currentTurn == .two
            {
                guard let teamId = self.match.teamTwo else { return }
                self.events.append(Event(
                    id: self.match.id,
                    type: .penaltySeriesFailure,
                    player: nil,
                    team: teamId,
                    time: .penaltySeries)
                )
            }
        }
    }
    
    private func getGroupPenaltyModelFor(team: TeamEnum) -> [GroupPenaltyState] {
        var resultArray: [GroupPenaltyState] = []
        var teamPenalties: [Event] = []
        var localCounter = 0
        if team == .one
        {
            teamPenalties = getPenalties(events: getEventsWith(team: .one, events: self.events))
            var penaltyStateElement = GroupPenaltyState(first: .none, second: .none, third: .none)
            for event in teamPenalties
            {
                if event.type == .penaltySeriesSuccess
                {
                    penaltyStateElement.addState(.success)
                }
                if event.type == .penaltySeriesFailure
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
                if event.type == .penaltySeriesSuccess
                {
                    penaltyStateElement.addState(.success)
                }
                if event.type == .penaltySeriesFailure
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
    
    private func getSuccessPenalties(events: [Event]) -> [Event] {
        return events.filter({ event -> Bool in
            return event.type == .penaltySeriesSuccess
        })
    }
    
    private func getPenalties(events: [Event]) -> [Event] {
        return events.filter({ event -> Bool in
            return event.type == .penaltySeriesSuccess || event.type == .penaltySeriesFailure
        })
    }
    
    private func getEventsWith(team: TeamEnum, events: [Event]) -> [Event] {
        if team == .one
        {
            return events.filter({ event -> Bool in
                return event.team?.orEqual(self.match.teamOne?.getId() ?? "", { $0.id == self.match.teamOne?.getValue()?.id ?? "" }) ?? false
//                return event.player == self.match.teamOne
            })
        }
        if team == .two
        {
            return events.filter({ event -> Bool in
                return event.team?.orEqual(self.match.teamTwo?.getId() ?? "", { $0.id == self.match.teamTwo?.getValue()?.id ?? "" }) ?? false
//                return event.player == self.match.teamTwo
            })
        }
        return []
    }
}
