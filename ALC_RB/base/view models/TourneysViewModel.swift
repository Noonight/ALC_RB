//
//  TourneysViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 24.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TourneysViewModel {
    
    let tourneys = PublishSubject<[Tourney]>()
    let loading = PublishSubject<Bool>()
    let error = PublishSubject<Error?>()
    let message = PublishSubject<SingleLineMessage>()
    
    let searchingQuery = BehaviorRelay<String?>(value: nil)
    let choosedRegion = BehaviorRelay<RegionMy?>(value: nil)
    let offset = BehaviorRelay<Int?>(value: nil)
    
    let tourneyApi: TourneyApi
    
    init(tourneyApi: TourneyApi) {
        self.tourneyApi = tourneyApi
    }
    
    func fetch() {
        self.loading.onNext(true)
        tourneyApi.get_tourney(
            name: searchingQuery.value,
            region: choosedRegion.value?.id,
            limit: Constants.Values.LIMIT_ALL,
            offset: offset.value
        ) { result in
            self.loading.onNext(false)
            switch result {
            case .success(let tourneys):
                self.tourneys.onNext(tourneys)
                self.offset.accept(tourneys.count)// MARK: - TODO it works not right
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
    
}
