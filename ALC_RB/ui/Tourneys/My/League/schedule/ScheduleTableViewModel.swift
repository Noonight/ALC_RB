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
    
    var items: PublishSubject<[MatchScheduleModelItem]> = PublishSubject()
    var loading: PublishSubject<Bool> = PublishSubject()
    var mMessage: PublishSubject<SingleLineMessage> = PublishSubject()
    var error: PublishSubject<Error?> = PublishSubject()
    var firstLoad: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var leagueDetailModel = BehaviorRelay<LeagueDetailModel>(value: LeagueDetailModel())
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetch() {
//        if firstLoad.value == true {
//            loading.onNext(true)
//        }
//        dataManager.get_leagueMatches(leagueId: (leagueDetailModel.value.league.id)!) { result in
//            self.loading.onNext(false)
//            switch result {
//            case .success(let matches):
//                let mMatches = matches.map({ MatchScheduleModelItem(match: $0, teamOne: nil, teamTwo: nil) })
//                self.leagueDetailModel.value.matches = mMatches
//                self.items.onNext(mMatches)
//            case .message(let message):
//                self.mMessage.onNext(message)
//            case .failure(let error):
//                self.error.onNext(error)
//            }
//        }
    }
}
