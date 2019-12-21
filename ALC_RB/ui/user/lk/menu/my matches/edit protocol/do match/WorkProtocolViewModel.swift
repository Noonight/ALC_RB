//
//  WorkProtocolViewModel.swift
//  ALC_RB
//
//  Created by ayur on 16.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkProtocolViewModel {
    
    let loading = PublishSubject<Bool>()
    let error = PublishSubject<Error>()
    let message = PublishSubject<SingleLineMessage>()
    
    var match: Match!
    let isChangedMatch = PublishSubject<Bool>()
    
    let teamOneEvents = PublishSubject<[RefereeProtocolPlayerTeamCellModel]>()
    let teamTwoEvents = PublishSubject<[RefereeProtocolPlayerTeamCellModel]>()
    
    var time: Event.Time = .firstHalf {
        didSet {
            rxTime.onNext(time)
        }
    }
    let rxTime = PublishSubject<Event.Time>()
    
    let protocolApi: ProtocolApi
    
    init(protocolApi: ProtocolApi) {
        self.protocolApi = protocolApi
    }
    
    func setupTables() {
        Print.m("Match.enabledEvents: \(match.getEnabledEvents())")
        setupTeamOneEventModels()
        setupTeamTwoEventModels()
    }
    
    func request_addEvent(event: Event) {
        self.loading.onNext(true)
        protocolApi.post_addEvent(matchId: match.id, event: event) { result in
            switch result {
            case .success(let resultEvent):
                self.match.events?.append(resultEvent)
                self.isChangedMatch.onNext(true)
            case .message(let message):
                Print.m(message.message)
                self.message.onNext(message)
            case .failure(.error(let error)):
                Print.m(error)
                self.error.onNext(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
                self.message.onNext(SingleLineMessage(Constants.Texts.NOT_VALID_DATA))
            }
            self.loading.onNext(false)
        }
    }
}

// MARK: - HELPERS

extension WorkProtocolViewModel {
    
    func setupTeamOneEventModels() {
        var cellModels = [RefereeProtocolPlayerTeamCellModel]()
        let events = match.getEnabledEvents(team: .one)
        Print.m(events)
        let matchPersonList = match.getTeamPlayers(team: .one).map({ pObj -> Person in
            return pObj.getValue()!
        })
        
        for person in matchPersonList {
            let goals = events.filter({ gEvent -> Bool in
                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.id && gEvent.type == .goal
            }).count
            let penalties = events.filter({ gEvent -> Bool in
                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.id && gEvent.type == .penalty
            }).count
            let failurePenalties = events.filter({ gEvent -> Bool in
                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.id && gEvent.type == .penaltyFailure
            }).count
            let yellowCards = events.filter({ gEvent -> Bool in
                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.id && gEvent.type == .yellowCard
            }).count
            let redCard = events.filter({ gEvent -> Bool in
                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.id && gEvent.type == .redCard
            }).count > 0 ? true : false
            let personEvents = RefereeProtocolPlayerEventsModel(goals: goals, successfulPenaltyGoals: penalties, failurePenaltyGoals: failurePenalties, yellowCards: yellowCards, redCard: redCard)
            cellModels.append(RefereeProtocolPlayerTeamCellModel(person: person, eventsModel: personEvents))
        }
        
        self.teamOneEvents.onNext(cellModels)
    }
    
    func setupTeamTwoEventModels() {
        var cellModels = [RefereeProtocolPlayerTeamCellModel]()
        let events = match.getEnabledEvents(team: .two)
        Print.m(events)
        let matchPersonList = match.getTeamPlayers(team: .two).map({ pObj -> Person in
            return pObj.getValue()!
        })
        
        for person in matchPersonList {
            let goals = events.filter({ gEvent -> Bool in
                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.id && gEvent.type == .goal
            }).count
            let penalties = events.filter({ gEvent -> Bool in
                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.id && gEvent.type == .penalty
            }).count
            let failurePenalties = events.filter({ gEvent -> Bool in
                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.id && gEvent.type == .penaltyFailure
            }).count
            let yellowCards = events.filter({ gEvent -> Bool in
                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.id && gEvent.type == .yellowCard
            }).count
            let redCard = events.filter({ gEvent -> Bool in
                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.id && gEvent.type == .redCard
            }).count > 0 ? true : false
            let personEvents = RefereeProtocolPlayerEventsModel(goals: goals, successfulPenaltyGoals: penalties, failurePenaltyGoals: failurePenalties, yellowCards: yellowCards, redCard: redCard)
            cellModels.append(RefereeProtocolPlayerTeamCellModel(person: person, eventsModel: personEvents))
        }
        
        self.teamTwoEvents.onNext(cellModels)
    }
    
    func createEvent(playerId: String? = nil, teamId: String, type: Event.eType) -> Event {
        if let player = playerId {
            return Event(type: type, player: IdRefObjectWrapper<Person>(player), team: IdRefObjectWrapper<Team>(teamId), time: time)
        }
        return Event(type: type, team: IdRefObjectWrapper<Team>(teamId), time: time)
    }
    
}
