//
//  WorkProtocolViewModel.swift
//  ALC_RB
//
//  Created by ayur on 18.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class WorkProtocolEventsViewModel {
    
    let loading = PublishSubject<Bool>()
    let error = PublishSubject<Error>()
    let message = PublishSubject<SingleLineMessage>()
    
    let events = PublishSubject<[Event]>()
    
    let includeEnabledEvents = BehaviorRelay<Bool>(value: false)
    
    var match: Match! {
        didSet {
            setupTable()
        }
    }
    
    let protocolApi: ProtocolApi
    
    init(protocolApi: ProtocolApi) {
        self.protocolApi = protocolApi
    }
    
    func request_disableEvent(event: Event) {
        // disable event
        match.events?.append(event)
    }
    
    func request_enableEvent(event: Event) {
        // enable event
        match.events?.append(event)
    }
    
    func setupTable() {
        var filteredEvents = [Event]()
        
        let allEvents = match.events ?? []
        
        if includeEnabledEvents.value == true {
            for event in allEvents {
                for fEvent in filteredEvents {
                    if event.id == fEvent.id {
                        
                    }
                }
            }
        } else {
            
        }
        
        self.events.onNext(match.events ?? [])
    }
    
}
