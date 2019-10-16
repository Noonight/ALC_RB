//
//  TourneysVM.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 15.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

final class MyTourneysVM {
    
    let items: PublishSubject<[TourneyModelItem]> = PublishSubject()
    private let tourneys: PublishSubject<[Tourney]> = PublishSubject()
    let error: PublishSubject<Error?> = PublishSubject()
    let message: PublishSubject<SingleLineMessage?> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    
    private let dataManager: ApiRequests
    private let localTourney = LocalTourneys()
    private let disposeBag = DisposeBag()
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
        
    }
    
    func fetch() {
        
        self.loading.onNext(true)
        dataManager
            .get_league(tourneys: localTourney.getLocalTourneys()) { result in
                self.loading.onNext(false)
                switch result {
                case .success(let modelItems):
                    self.items.onNext(modelItems)
                case .message(let message):
                    self.message.onNext(message)
                case .failure(let error):
                    self.error.onNext(error)
                }
        }
    }
    
}
