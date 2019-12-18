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
    
    var match: Match! {
        didSet {
            setupTables()
        }
    }
    let teamOneEvents = PublishSubject<[Event]>()
    let teamTwoEvents = PublishSubject<[Event]>()
    
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
        let teamOnePlayerEvents = self.match.events?.filter({ event -> Bool in
            return match.teamOne?.getValue()?.players?.contains(where: { player -> Bool in
//                Print.m(player)
                return player.person?.getId() ?? player.person?.getValue()?.id == event.player?.getId() ?? event.player?.getValue()?.id
            }) ?? false
        }) ?? []
//        Print.m(teamOnePlayerEvents)
        let teamOneTeamEvents = self.match.events?.filter({ event -> Bool in
            return event.team?.getId() ?? event.team?.getValue()?.id == match.teamOne?.getId() ?? match.teamOne?.getValue()?.id
        }) ?? []
        var teamOneEvents = [Event]()
        teamOneEvents.append(contentsOf: teamOnePlayerEvents)
        teamOneEvents.append(contentsOf: teamOneTeamEvents)
        
        let teamTwoPlayerEvents = self.match.events?.filter({ event -> Bool in
            return match.teamTwo?.getValue()?.players?.contains(where: { player -> Bool in
                return player.person?.getId() ?? player.person?.getValue()?.id == event.player?.getId() ?? event.player?.getValue()?.id
            }) ?? false
        }) ?? []
        let teamTwoTeamEvents = self.match.events?.filter({ event -> Bool in
            return event.team?.getId() ?? event.team?.getValue()?.id == match.teamTwo?.getId() ?? match.teamTwo?.getValue()?.id
        }) ?? []
        var teamTwoEvents = [Event]()
        teamTwoEvents.append(contentsOf: teamTwoPlayerEvents)
        teamTwoEvents.append(contentsOf: teamTwoTeamEvents)
        
        self.teamOneEvents.onNext(teamOneEvents)
        self.teamTwoEvents.onNext(teamTwoEvents)
    }
    
    func request_addEvent(event: Event) {
        self.loading.onNext(true)
        protocolApi.post_addEvent(matchId: match.id, event: event) { result in
            switch result {
            case .success(let resultEvent):
                self.match.events?.append(resultEvent)
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
    
    func createEvent(playerId: String? = nil, teamId: String, type: Event.eType) -> Event {
        if let player = playerId {
            return Event(type: type, player: IdRefObjectWrapper<Person>(player), team: IdRefObjectWrapper<Team>(teamId), time: time)
        }
        return Event(type: type, player: nil, team: IdRefObjectWrapper<Team>(teamId), time: time)
    }
    
}
