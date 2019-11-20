//
//  ChooseTourneyLeagueVM.swift
//  ALC_RB
//
//  Created by mac on 20.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class ChooseTourneyLeagueVM {
    
    let loading = PublishSubject<Bool>()
    let error = PublishSubject<Error?>()
    let message = PublishSubject<SingleLineMessage>()
    let query = BehaviorRelay<String?>(value: nil)
    let choosedRegion = BehaviorRelay<RegionMy?>(value: nil)
    
    let findedLeagues = PublishSubject<[TourneyModelItem]>()
    
    let tourneyApi: TourneyApi
    
    init(tourneyApi: TourneyApi) {
        self.tourneyApi = tourneyApi
    }
    
    func fetch() {
        loading.onNext(true)
        
        tourneyApi.get_tourneyModelItemsQuery(leagueName: query.value, region: choosedRegion.value) { result in
            switch result {
            case .success(let tourneyModelItems):
                self.findedLeagues.onNext(tourneyModelItems)
            case .message(let message):
                Print.m(message.message)
                self.message.onNext(message)
            case .failure(.error(let error)):
                Print.m(error)
                self.error.onNext(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
                self.message.onNext(SingleLineMessage("Не валидные данные"))
            }
            self.loading.onNext(false)
        }
    }
    
}
