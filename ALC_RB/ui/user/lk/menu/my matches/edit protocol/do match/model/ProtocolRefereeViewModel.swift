//
//  ProtocolRefereeModel.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class ProtocolRefereeViewModel {
    
    enum CurrentTime: String {
        case firstTime  = "1 тайм"
        case secondTime = "2 тайм"
        case moreTime   = "Дополнительное время"
        case penalty    = "Пенальти"
    }
    
    // current time using for make event
    var currentTime: CurrentTime = .firstTime
    
    var match: LIMatch!
    var leagueDetailModel: LeagueDetailModel!
    
    var teamOnePlayersController: ProtocolPlayersController!
    var teamTwoPlayersController: ProtocolPlayersController!
    var refereesController: ProtocolRefereesController!
    var eventsController: ProtocolEventsController!
    
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
    
    // MARK: PREPARE FOR DISPLAY OR PREPARE DATA FOR SERVER REQUEST
    
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
    
    func prepareTableViewCells(team: ClubTeamHelper.TeamEnum, completed: @escaping ([RefereeProtocolPlayerTeamCellModel]) -> ()) {
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
            completed(returnedArray)
        }
    }
    
    // MARK: Helpers
    
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
                if event.getEventType() == .goal
                {
                    returnedModel.goals = returnedModel.goals + 1
                }
                if event.getEventType() == .penalty
                {
                    returnedModel.successfulPenaltyGoals = returnedModel.successfulPenaltyGoals + 1
                }
                // MARK: TODO => failurePenalty
                if event.getEventType() == .yellowCard
                {
                    returnedModel.yellowCards = returnedModel.yellowCards + 1
                }
                if event.getEventType() == .redCard
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
