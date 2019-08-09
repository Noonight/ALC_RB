//
//  ProtocolRefereeModel.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class ProtocolRefereeViewModel {
    
    // current time using for make event
    var currentTime: EventTime = .oneHalf
    
    var match: LIMatch!
    var leagueDetailModel: LeagueDetailModel!
    
    var teamOnePlayersController: ProtocolPlayersController!
    var teamTwoPlayersController: ProtocolPlayersController!
    var refereesController: ProtocolRefereesController!
    var eventsController: ProtocolEventsController!
    
    var teamOneFoulsCount = 0 // TODO need update later
    var teamTwoFoulsCount = 0
    
    var teamOneAutoGoalsCount = 0 // TODO need smth
    var teamTwoAutoGoalsCount = 0
    
    let dataManager = ApiRequests()
    
    init(match: LIMatch, leagueDetailModel: LeagueDetailModel, teamOneModel: ProtocolPlayersController, teamTwoModel: ProtocolPlayersController,
         refereesModel: ProtocolRefereesController, eventsModel: ProtocolEventsController) {
        self.match = match
        self.leagueDetailModel = leagueDetailModel
        self.teamOnePlayersController = teamOneModel
        self.teamTwoPlayersController = teamTwoModel
        self.refereesController = refereesModel
        self.eventsController = eventsModel
    }
    
    // MARK: UPDATE DATA
    
    func upFoulsCount(team: TeamEnum) {
        switch team {
        case .one:
            guard let teamId = self.match.teamOne else { return }
            self.eventsController.add(LIEvent(
                matchID: self.match.id,
                eventType: .foul,
                playerID: teamId,
                time: self.currentTime)
            )
        case .two:
            guard let teamId = self.match.teamTwo else { return }
            self.eventsController.add(LIEvent(
                matchID: self.match.id,
                eventType: .foul,
                playerID: teamId,
                time: self.currentTime)
            )
        }
    }
    
    func upAutoGoalsCount(team: TeamEnum) {
        switch team {
        case .one:
            guard let teamId = self.match.teamOne else { return } // CHECK
            self.eventsController.add(LIEvent(
                matchID: self.match.id,
                eventType: .autoGoal,
                playerID: teamId,
                time: self.currentTime)
            )
        case .two:
            guard let teamId = self.match.teamTwo else { return } // CHECK
            self.eventsController.add(LIEvent(
                matchID: self.match.id,
                eventType: .autoGoal,
                playerID: teamId,
                time: self.currentTime)
            )
        }
    }
    
    func clearFouls() {
        self.teamOneFoulsCount = 0
        self.teamTwoFoulsCount = 0
    }
    
    func updateTime(time: EventTime) {
        if self.currentTime != time
        {
            self.currentTime = time
            if self.currentTime == .oneHalf
            {
                self.clearFouls() // MARK: CHECK IT IN FEATURE
            }
            if self.currentTime == .twoHalf
            {
                self.clearFouls()
            }
            if self.currentTime == .penaltySeries
            {
                self.clearFouls()
            }
        }
    }
    
    func deleteLastAddedEvent() {
        self.eventsController.removeLastAdded()
    }
    
    func restoreLastDeletedEvent() {
        self.eventsController.restoreLastDeleted()
    }
    
    func updateMatch(match: LIMatch) {
        self.match = match
        self.eventsController.updateEvents(events: match.events)
    }
    
    // MARK: WORK WITH VARIABLES
    
    func appendEvent(event: LIEvent) {
        self.eventsController.add(event)
    }
    
    func removeEvent(event: EventMaker.DeleteEvent) -> Bool {
        return self.eventsController.removeFirstWith(event: event)
    }
    
    // MARK: PREPARE FOR DISPLAY OR PREPARE DATA FOR SERVER REQUEST
    
    func prepareAutogoalsCountInCurrentTime(team: TeamEnum) -> Int { // OK
        let teamEvents = self.eventsController.prepareTeamEventsInTime(time: self.currentTime)
        
        return getEventsForTeam(team: team, events: teamEvents).filter({ event -> Bool in
            return event.getEventType() == .team(.autoGoal)
        }).count
    }
    
    func prepareFoulsCountInCurrentTime(team: TeamEnum) -> Int {
        let teamEvents = self.eventsController.prepareTeamEventsInTime(time: self.currentTime)
        
        return getEventsForTeam(team: team, events: teamEvents).filter({ event -> Bool in
            return event.getEventType() == .team(.foul)
        }).count
    }
    
    func prepareCurrentTime() -> String {
        return self.currentTime.rawValue
    }
    
    func prepareMatchId() -> String {
        return self.match.id
    }
    
    func prepareEditProtocol() -> EditProtocol {
        return EditProtocol(
            id: self.match.id,
            events: EditProtocol.Events(events: eventsController.events),
            playersList: self.getPlayersId()
        )
    }
    
    func prepareFoulsCount(for team: TeamEnum) -> Int {
        if team == .one
        {
            return self.teamOneFoulsCount
        }
        if team == .two
        {
            return self.teamTwoFoulsCount
        }
        return 0
    }
    
    func prepareTableViewCells(team: TeamEnum, completed: @escaping ([RefereeProtocolPlayerTeamCellModel]) -> ()) {
        var returnedArray: [RefereeProtocolPlayerTeamCellModel] = []
        
        let group = DispatchGroup()
        
        if team == .one
        {
            for item in teamOnePlayersController.getPlayingPlayers()
            {
                group.enter()
                self.fetchPerson(playerId: item.playerId, success:
                { person in
                    returnedArray.append(RefereeProtocolPlayerTeamCellModel(
                        player: item.convertToPlayer(),
                        person: person.person,
                        eventsModel: self.getPlayerEventsBy(playerId: item.playerId))
                    )
                    group.leave()
                }) { error in
                    Print.m("Player not found m.b. ->> \(error)")
                }
            }
        }
        if team == .two
        {
            for item in teamTwoPlayersController.getPlayingPlayers()
            {
                group.enter()
                self.fetchPerson(playerId: item.playerId, success:
                { person in
                    returnedArray.append(RefereeProtocolPlayerTeamCellModel(
                        player: item.convertToPlayer(),
                        person: person.person,
                        eventsModel: self.getPlayerEventsBy(playerId: item.playerId))
                    )
                    group.leave()
                }) { error in
                    Print.m("Player not found m.b. ->> \(error)")
                }
            }
        }
        
        group.notify(queue: .main) {
            completed(returnedArray.sorted { $0.person!.getSurnameNP() > $1.person!.getSurnameNP() }) // add sort for every time
        }
    }
    
    // MARK: Helpers
    
    private func getEventsForTeam(team: TeamEnum, events: [LIEvent]) -> [LIEvent] {
        var resultArray: [LIEvent] = []
        if team == .one
        {
            for event in events
            {
                if teamOnePlayersController.players.contains(where: { liPlayer -> Bool in
                    return liPlayer.playerId == event.player
                }) == true
                {
                    resultArray.append(event)
                }
            }
        }
        
        if team == .two
        {
            for event in events
            {
                if teamTwoPlayersController.players.contains(where: { liPlayer -> Bool in
                    return liPlayer.playerId == event.player
                }) == true
                {
                    resultArray.append(event)
                }
            }
        }
        
        return resultArray
    }
    
    private func getFoulsByTimeForTeam(time: String, team: TeamEnum, events: [LIEvent]) -> Int {
        var count = 0
        
        if team == .one
        {
            for event in getEventsForTeam(team: .one, events: events)
            {
                if event.time == time && event.getSystemEventType() == .foul
                {
                    count += 1
                }
            }
        }
        
        if team == .two
        {
            for event in getEventsForTeam(team: .two, events: events)
            {
                if event.time == time && event.getSystemEventType() == .foul
                {
                    count += 1
                }
            }
        }
        return count
    }
    
    fileprivate func getPlayersId() -> [String] {
        return connectPlayersOfTeamOneAndTwo().map({ liPlayer -> String in
            return liPlayer.playerId
        })
    }
    
    fileprivate func connectPlayersOfTeamOneAndTwo() -> [LIPlayer] {
        return [teamOnePlayersController.getPlayingPlayers(), teamTwoPlayersController.getPlayingPlayers()].flatMap({ liPlayer -> [LIPlayer] in
            return liPlayer
        })
    }
    
    fileprivate func getPlayerEventsBy(playerId: String) -> RefereeProtocolPlayerEventsModel
    {
        var playerEvents: [LIEvent] = []
        var returnedModel = RefereeProtocolPlayerEventsModel()
        for item in eventsController.events
        {
            if item.player == playerId
            {
                playerEvents.append(item)
            }
        }
        if playerEvents.count != 0
        {
            returnedModel = RefereeProtocolPlayerEventsModel()
            for event in playerEvents
            {
                if event.getEventType() == .player(.goal)
                {
                    returnedModel.goals = returnedModel.goals + 1
                }
                if event.getEventType() == .player(.penalty)
                {
                    returnedModel.successfulPenaltyGoals = returnedModel.successfulPenaltyGoals + 1
                }
                if event.getEventType() == .player(.penaltyFailure)
                {
                    returnedModel.failurePenaltyGoals = returnedModel.failurePenaltyGoals + 1
                }
                if event.getEventType() == .player(.yellowCard)
                {
                    returnedModel.yellowCards = returnedModel.yellowCards + 1
                }
                if event.getEventType() == .player(.redCard)
                {
                    returnedModel.redCard = true
                }
            }
            return returnedModel
        }
        return returnedModel
    }
}

// MARK: API REQUESTS

extension ProtocolRefereeViewModel {
    
    func fetchPerson(playerId: String, success: @escaping (SoloPerson) -> (), failure: @escaping (Error) -> ()) {
        self.dataManager.get_soloPerson(playerId: playerId, success: { soloPerson in
            success(soloPerson)
        }) { error in
            failure(error)
        }
    }
    
}