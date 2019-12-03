//
//  ScheduleTableViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 17.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ScheduleTableViewModel {
    
    let items: PublishSubject<[MatchScheduleModelItem]> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    let mMessage: PublishSubject<SingleLineMessage> = PublishSubject()
    let error: PublishSubject<Error?> = PublishSubject()
    let firstLoad: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var leagueDetailModel = BehaviorRelay<LeagueDetailModel?>(value: nil)
    
    var lastItemCounts = BehaviorRelay<Int>(value: 0)
    
    private let matchApi: MatchApi
    
    init(matchApi: MatchApi) {
        self.matchApi = matchApi
    }
    
    func fetch() {
        
        if firstLoad.value == true {
            loading.onNext(true)
        }
        
        matchApi.get_match(
        params: ParamBuilder<Match.CodingKeys>()
            .add(key: .league, value: leagueDetailModel.value!.league.id)
            .populate(StrBuilder().add([.place, .teamOne, .teamTwo]))
//            .limit()
//            .offset(lastItemCounts.value)
            .limit(Constants.Values.LIMIT_ALL)
            .get()
        ) { result in
            switch result {
            case .success(let leagues):
                self.items.onNext(leagues.map { MatchScheduleModelItem(match: $0) })
//                dump(leagues.first)
            case .message(let message):
                Print.m(message.message)
                self.mMessage.onNext(message)
            case .failure(.error(let error)):
                Print.m(error)
                self.error.onNext(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
                self.mMessage.onNext(SingleLineMessage("Не ожидаемые данные."))
            }
            self.loading.onNext(false)
        }
    }
}
