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
    
    func request_saveProtocolEvents() {
        let editProtocolModel = EditProtocol(id: match.id, events: EditProtocol.Events(events: match.events!))
        self.loading.onNext(true)
        protocolApi.post_changeProtocol(newProtocol: editProtocolModel) { result in
            switch result {
            case .success(let editedMatch):
                self.match.events = editedMatch.events
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
    
    // another view models
    
}
