//
//  ProtocolAllViewModel.swift
//  ALC_RB
//
//  Created by ayur on 05.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

enum EndOfMatch: String {
    case mainTime = "в основное время"
    case extraTime = "в дополнительное время"
}

class ProtocolAllViewModel {
    
    var match: Match!
    var leagueDetailModel: LeagueDetailModel!
    
    var teamOnePlayersController: ProtocolPlayersController!
    var teamTwoPlayersController: ProtocolPlayersController!
    var refereesController: ProtocolRefereesController!
    var eventsController: ProtocolEventsController! {
        didSet {
            if self.eventsController != nil && self.eventsController.events != nil
            {
//                dump(self.eventsController.events)
            }
        }
    }
    
    let dataManager = ApiRequests()
    let personApi = PersonApi()
    
    init(match: Match, leagueDetailModel: LeagueDetailModel) {
        self.match = match
        self.leagueDetailModel = leagueDetailModel
        
        self.preConfigureModelControllers()
    }
    
    init(match: Match, leagueDetailModel: LeagueDetailModel, teamOneModel: ProtocolPlayersController, teamTwoModel: ProtocolPlayersController,
         refereesModel: ProtocolRefereesController, eventsModel: ProtocolEventsController) {
        self.match = match
        self.leagueDetailModel = leagueDetailModel
        self.teamOnePlayersController = teamOneModel
        self.teamTwoPlayersController = teamTwoModel
        self.refereesController = refereesModel
        self.eventsController = eventsModel
    }
    
    // MARK: PREPARE FOR DISPLAY
    
    func prepareResultScoreCalculated() -> String {
        let allEvents = eventsController.events
        
        var counterLeft = 0
        var counterRight = 0
        
        let teamOneEvents = self.getEventsForTeam(team: .one, events: allEvents)
        let teamTwoEvents = self.getEventsForTeam(team: .two, events: allEvents)
        
        for event in teamOneEvents
        {
            if event.getSystemEventType() == .goal || event.getSystemEventType() == .penalty
            {
                counterLeft += 1
            }
            if event.getSystemEventType() == .autoGoal
            {
                counterRight += 1
            }
        }
        for event in teamTwoEvents
        {
            if event.getSystemEventType() == .goal || event.getSystemEventType() == .penalty
            {
                counterRight += 1
            }
            if event.getSystemEventType() == .autoGoal
            {
                counterLeft += 1
            }
        }
        
        return "\(counterLeft) : \(counterRight)"
    }
    
    func preparePenaltyScore() -> String {
        if hasPenaltySeriesEvents() == true
        {
            let penaltySeries = self.getEventsByTime("penalty series")
            var counterLeft = 0
            var counterRight = 0
            
            let teamOneEvents = self.getEventsForTeam(team: .one, events: penaltySeries)
            let teamTwoEvents = self.getEventsForTeam(team: .two, events: penaltySeries)
            
            for event in teamOneEvents
            {
                if event.getSystemEventType() == .goal || event.getSystemEventType() == .penalty
                {
                    counterLeft += 1
                }
                if event.getSystemEventType() == .autoGoal
                {
//                    counterLeft -= 1
                    counterRight += 1
                }
            }
            
            for event in teamTwoEvents
            {
                if event.getSystemEventType() == .goal || event.getSystemEventType() == .penalty
                {
                    counterRight += 1
                }
                if event.getSystemEventType() == .autoGoal
                {
//                    counterRight -= 1
                    counterLeft += 1
                }
            }
            
            print ("LOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOL")
            return "\(counterLeft) : \(counterRight)"
        }
        else
        {
            return ""
        }
    }
    
    func hasPenaltySeriesEvents() -> Bool {
        if eventsController.events.contains(where: { event -> Bool in
            return event.time == "penalty series"
        }) == true
        {
            return true
        }
        return false
    }
    
    func prepareFirstTimeScore() -> String {
        let firstTimeEvents = self.getEventsByTime("1 half")
        var counterLeft = 0
        var counterRight = 0
        
        let teamOneEvents = self.getEventsForTeam(team: .one, events: firstTimeEvents)
        let teamTwoEvents = self.getEventsForTeam(team: .two, events: firstTimeEvents)
        
        for event in teamOneEvents
        {
            if event.getSystemEventType() == .goal || event.getSystemEventType() == .penalty
            {
                counterLeft += 1
            }
            if event.getSystemEventType() == .autoGoal
            {
//                counterLeft -= 1
                counterRight += 1
            }
        }
        
        for event in teamTwoEvents
        {
            if event.getSystemEventType() == .goal || event.getSystemEventType() == .penalty
            {
                counterRight += 1
            }
            if event.getSystemEventType() == .autoGoal
            {
//                counterRight -= 1
                counterLeft += 1
            }
        }
        print ("TROLOLOLOLOLOLOLOOOOOOLOLOOOOLLLLOLOLOLOLLOOLOLOL")
        return "(\(counterLeft) : \(counterRight))"
    }
    
    func prepareMainTimeScore() -> String {
        let firstTimeEvents = self.getEventsByTime("1 half")
        let secondTimeEvents = self.getEventsByTime("2 half")
        var allEvents: [LIEvent] = []
        allEvents.append(contentsOf: firstTimeEvents)
        allEvents.append(contentsOf: secondTimeEvents)
        
        for e in allEvents {
            print (e)
        }
        
        var counterLeft = 0
        var counterRight = 0
        
        let teamOneEvents = self.getEventsForTeam(team: .one, events: allEvents)
        let teamTwoEvents = self.getEventsForTeam(team: .two, events: allEvents)
        
        for event in teamOneEvents
        {
            if event.getSystemEventType() == .goal || event.getSystemEventType() == .penalty
            {
                counterLeft += 1
            }
            if event.getSystemEventType() == .autoGoal
            {
//                counterLeft -= 1
                counterRight += 1
            }
        }
        for event in teamTwoEvents
        {
            if event.getSystemEventType() == .goal || event.getSystemEventType() == .penalty
            {
                counterRight += 1
            }
            if event.getSystemEventType() == .autoGoal
            {
                //counterRight -= 1
                counterLeft += 1
            }
        }
        
        return "\(counterLeft) : \(counterRight)"
    }
    
    func prepareResultScore() -> String {
        guard let score = self.match.score else { return "" }
        let separated = score.components(separatedBy: ":")
        
        return "\(separated[0]) : \(separated[1])"
    }
    
    func prepareEndOfMatch() -> String {
        return self.eventsController.getLastTime()
    }
    
    func preparePlace() -> String {
        guard let place = self.match.place else { return "Не указано" }
        return place
    }
    
    func prepareTime() -> String {
        let date = self.match.date
        guard let time = date?.toFormat("HH.mm") else { return "" }
        return "\(time)ч"
    }
    
    func prepareDate() -> String {
        let date = self.match.date
        guard let day = date?.dateComponents.day else { return "" }
        guard let month = date?.monthName(.default) else { return "" }
        
        return "\(day) \(month)"
    }
    
    func prepareDateAsWeekDay() -> String {
        let date = self.match.date
        guard let dayOfWeek = date?.weekdayName(.default, locale: Locale.current) else { return "" }
        return dayOfWeek
    }
    
    func prepareTournamentTitle() -> String {
//        var curName = ""
//        if let name = self.leagueDetailModel.leagueInfo.league.name {
//            curName = name
//        }
        var curTourney = ""
        if let tourney = self.leagueDetailModel.leagueInfo.league.name {
            curTourney = tourney
        }
//        return "\(curName). \(curTourney)"
        return curTourney
    }
    
    func prepareTour() -> String {
//        return self.leagueDetailModel.leagueInfo.league.tourney ?? ""
        return ""
    }
    
    func prepareTeamTitle(team: TeamEnum) -> String {
        switch team {
        case .one:
            return ClubTeamHelper.getTeamTitle(league: self.leagueDetailModel.leagueInfo.league, match: match, team: .one)
        case .two:
            return ClubTeamHelper.getTeamTitle(league: self.leagueDetailModel.leagueInfo.league, match: match, team: .two)
        }
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
//            dump(resultArray)
            completed(resultArray)
        }
    }
    
    // MARK: Helpers
    
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
    
    private func getEventsForTeam(team: TeamEnum, events: [LIEvent]) -> [LIEvent] {
        var resultArray: [LIEvent] = []
        
        if team == .one
        {
            var players: [String] = []
            for p in teamOnePlayersController.getPlayingPlayers() {
                players.append(p.playerId)
            }
            for event in events
            {
                if players.index(of: event.player) != nil {
                    resultArray.append(event)
                }
            }
        }
        
        if team == .two
        {
            var players: [String] = []
            for p in teamTwoPlayersController.getPlayingPlayers() {
                players.append(p.playerId)
            }
            for event in events
            {
                if players.index(of: event.player) != nil {
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
            let maxOf = max(teamOneEventsPlayers.count, teamTwoEventsPlayers.count)
            if maxOf - 1 >= 0
            {
                for i in 0...maxOf - 1
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
            else
            {
                for i in 0...maxOf
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
        
    }
    
    struct EventPLayer {
        var event: LIEvent
        var player: LIPlayer
        var person: Person
    }
    
    private func getEventsAndPlayerByPlayerIdForTeam(team: TeamEnum, events: [LIEvent], complete: @escaping ([EventPLayer]) -> ()) {
        
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
    
    func preConfigureModelControllers() {
        teamOnePlayersController = nil
        teamTwoPlayersController = nil// MARK: TODO team can be empty
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
//        self.dataManager.get_soloPerson(playerId: playerId, success: { soloPerson in
//            success(soloPerson)
//        }) { error in
//            failure(error)
//        }
        self.personApi.get_person(id: playerId) { result in
            switch result {
            case .success(let person):
                success(SoloPerson(person: person.first!))
            case .message(let message):
                Print.m("message \(message.message)")
            case .failure(RequestError.notExpectedData):
                Print.m("not expected data")
            case .failure(.error(let error)):
                Print.m(error)
            }
        }
    }
    
}
