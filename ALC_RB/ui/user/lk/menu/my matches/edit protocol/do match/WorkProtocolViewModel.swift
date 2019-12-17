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
    let events = PublishSubject<[Event]>()
    
    var match: Match! {
        didSet {
            // if match was edited it is always events
            self.events.onNext(self.match.events ?? [])
        }
    }
    var time: Event.Time = .firstHalf
    
    let protocolApi: ProtocolApi
    
    init(protocolApi: ProtocolApi) {
        self.protocolApi = protocolApi
    }
    
    func request_addEvent(event: Event) {
        self.loading.onNext(true)
        protocolApi.post_addEvent(matchId: match.id, event: event) { result in
            switch result {
            case .success(let resultMatch):
                self.match.events = resultMatch.events
                self.loading.onNext(false)
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
        }
    }
}

// MARK: - HELPERS

extension WorkProtocolViewModel {
    
    func createEvent(playerId: String? = nil, teamId: String? = nil, type: Event.eType) -> Event {
        var event: Event!
        if let player = playerId {
            event = Event(type: type, player: IdRefObjectWrapper<Person>(player), team: nil, time: time)
        }
        if let team = teamId {
            event = Event(type: type, player: nil, team: IdRefObjectWrapper<Team>(team), time: time)
        }
        return event
    }
    
}
