//
//  ProtocolAllViewModel.swift
//  ALC_RB
//
//  Created by ayur on 05.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class ProtocolAllViewModel {
    
    var match: LIMatch!
    var leagueDetailModel: LeagueDetailModel!
    
    var teamOnePlayersController: ProtocolPlayersController!
    var teamTwoPlayersController: ProtocolPlayersController!
    var refereesController: ProtocolRefereesController!
    var eventsController: ProtocolEventsController!
    
    let dataManager = ApiRequests()
    
    init(match: LIMatch, leagueDetailModel: LeagueDetailModel) {
        self.match = match
        self.leagueDetailModel = leagueDetailModel
        
        self.preConfigureModelControllers()
    }
    
    init(match: LIMatch, leagueDetailModel: LeagueDetailModel, teamOneModel: ProtocolPlayersController, teamTwoModel: ProtocolPlayersController,
         refereesModel: ProtocolRefereesController, eventsModel: ProtocolEventsController) {
        self.match = match
        self.leagueDetailModel = leagueDetailModel
        self.teamOnePlayersController = teamOneModel
        self.teamTwoPlayersController = teamTwoModel
        self.refereesController = refereesModel
        self.eventsController = eventsModel
    }
    
    // MARK: PREPARE FOR DISPLAY
    
    func prepareTour() -> String {
        return self.leagueDetailModel.leagueInfo.league.tourney ?? ""
    }
    
    func prepareTeamTitle(team: ClubTeamHelper.TeamEnum) -> String {
        switch team {
        case .one:
            return ClubTeamHelper.getTeamTitle(league: self.leagueDetailModel.leagueInfo.league, match: match, team: .one)
        case .two:
            return ClubTeamHelper.getTeamTitle(league: self.leagueDetailModel.leagueInfo.league, match: match, team: .two)
        }
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
            completed(returnedArray.sorted { $0.person!.getSurnameNP() > $1.person!.getSurnameNP() }) // add sort for every time
        }
    }
    
    func prepareTableViewDataSource(completed: @escaping ([ProtocolAllEventsSectionTable]) -> ()) {
        var resultArray: [ProtocolAllEventsSectionTable] = []
        
        let group = DispatchGroup()
        
        for time in getUniqueTimes()
        {
            group.enter()
            getCellsByTime(time: time) { cellModel in
                resultArray.append(ProtocolAllEventsSectionTable(
                    eventsCellModel: cellModel,
                    leftFooterFouls: self.getFoulsByTimeForTeam(
                        time: time,
                        team: .one,
                        events: self.eventsController.events),
                    rightFooterFouls: self.getFoulsByTimeForTeam(
                        time: time,
                        team: .two,
                        events: self.eventsController.events)
                    )
                )
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completed(resultArray)
        }
    }
    
    // MARK: Helpers
    
    private func getFoulsByTimeForTeam(time: String, team: ClubTeamHelper.TeamEnum, events: [LIEvent]) -> Int {
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
    
    private func getEventsForTeam(team: ClubTeamHelper.TeamEnum, events: [LIEvent]) -> [LIEvent] {
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
    
    private func getCellsByTime(time: String, completed: @escaping([ProtocolAllEventsCellModel]) -> ()) {

        let group = DispatchGroup()
        
        var resultCells: [ProtocolAllEventsCellModel] = []
        
        var teamOneEventsPlayers: [EventPLayer] = []
        
        group.enter()
        self.getEventsAndPlayerByPlayerIdForTeam(team: .one, events: getEventsByTime(time)) { eventsPlayers in
            teamOneEventsPlayers.removeAll()
            teamOneEventsPlayers.append(contentsOf: eventsPlayers)
            
            group.leave()
        }
        
        var teamTwoEventsPlayers: [EventPLayer] = []
        
        group.enter()
        self.getEventsAndPlayerByPlayerIdForTeam(team: .two, events: getEventsByTime(time)) { eventsPlayers in
            teamTwoEventsPlayers.removeAll()
            teamTwoEventsPlayers.append(contentsOf: eventsPlayers)
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            for i in 0...max(teamOneEventsPlayers.count, teamTwoEventsPlayers.count) - 1
            {
                var cellModel = ProtocolAllEventsCellModel()
                if i <= teamOneEventsPlayers.count - 1
                {
                    cellModel.left_name = teamOneEventsPlayers[i].person.getSurnameNP()
                    cellModel.left_event = teamOneEventsPlayers[i].event.getSystemEventType()
                }
                if i <= teamTwoEventsPlayers.count - 1
                {
                    cellModel.right_name = teamTwoEventsPlayers[i].person.getSurnameNP()
                    cellModel.right_event = teamTwoEventsPlayers[i].event.getSystemEventType()
                }
                resultCells.append(cellModel)
            }
            completed(resultCells)
        }
        
    }
    
    struct EventPLayer {
        var event: LIEvent
        var player: LIPlayer
        var person: Person
    }
    
    private func getEventsAndPlayerByPlayerIdForTeam(team: ClubTeamHelper.TeamEnum, events: [LIEvent], complete: @escaping ([EventPLayer]) -> ()) {
        
        var resultArray: [EventPLayer] = []
        
        let group = DispatchGroup()
        
        if team == .one
        {
            for event in events
            {
                if teamOnePlayersController.players.contains(where: { liPLayer -> Bool in
                    return liPLayer.playerId == event.player
                }) == true
                {
                    group.enter()
                    self.fetchPerson(playerId: event.player, success: { person in
                        resultArray.append(ProtocolAllViewModel.EventPLayer(
                            event: event,
                            player: self.teamOnePlayersController.getPlayerById(event.player)!,
                            person: person.person))
                        group.leave()
                    }) { error in
                        Print.m("player not found ->> \(error)")
                    }
                }
            }
            
        }
        
        if team == .two
        {
            for event in events
            {
                if teamTwoPlayersController.players.contains(where: { liPLayer -> Bool in
                    return liPLayer.playerId == event.player
                }) == true
                {
                    group.enter()
                    self.fetchPerson(playerId: event.player, success: { person in
                        resultArray.append(ProtocolAllViewModel.EventPLayer(
                            event: event,
                            player: self.teamTwoPlayersController.getPlayerById(event.player)!,
                            person: person.person))
                        group.leave()
                    }) { error in
                        Print.m("player not found ->> \(error)")
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            complete(resultArray)
        }
    }
    
    private func getUniqueTimes() -> [String] {
        var resultArray: [String] = []
        
        for event in eventsController.events
        {
            if resultArray.contains(event.time) == false
            {
                resultArray.append(event.time)
            }
        }
        
        return resultArray
    }
    
    private func getEventsByTime(_ time: String) -> [LIEvent] {
        var resultArray: [LIEvent] = []
        
        for event in eventsController.events
        {
            if event.time == time
            {
                resultArray.append(event)
            }
        }
        
        return resultArray
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
                if event.getEventType() == .goal
                {
                    returnedModel.goals = returnedModel.goals + 1
                }
                if event.getEventType() == .penalty
                {
                    returnedModel.successfulPenaltyGoals = returnedModel.successfulPenaltyGoals + 1
                }
                if event.getEventType() == .penaltyFailure
                {
                    returnedModel.failurePenaltyGoals = returnedModel.failurePenaltyGoals + 1
                }
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
    
    func preConfigureModelControllers() {
        teamOnePlayersController = nil
        teamTwoPlayersController = nil
        teamOnePlayersController = ProtocolPlayersController(players: getPlayersTeam(team: match.teamOne!))
        teamTwoPlayersController = ProtocolPlayersController(players: getPlayersTeam(team: match.teamTwo!))
        refereesController = nil
        refereesController = ProtocolRefereesController(referees: match.referees)
        eventsController = nil
        eventsController = ProtocolEventsController(events: match.events)
    }
    
    func getPlayersTeam(team id: String) -> [LIPlayer] {
        return (leagueDetailModel.leagueInfo.league.teams?.filter({ (team) -> Bool in
            return team.id == id
        }).first?.players)!
    }
}

// MARK: API REQUESTS

extension ProtocolAllViewModel {
    
    func fetchPerson(playerId: String, success: @escaping (SoloPerson) -> (), failure: @escaping (Error) -> ()) {
        self.dataManager.get_soloPerson(playerId: playerId, success: { soloPerson in
            success(soloPerson)
        }) { error in
            failure(error)
        }
    }
    
}
