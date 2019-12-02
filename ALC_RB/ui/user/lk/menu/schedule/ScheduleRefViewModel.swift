//
//  ScheduleRefViewModel.swift
//  ALC_RB
//
//  Created by ayur on 11.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ScheduleRefViewModel {
    
    var error: PublishSubject<Error?> = PublishSubject()
    var loading: PublishSubject<Bool> = PublishSubject()
    var message: PublishSubject<SingleLineMessage?> = PublishSubject()

    var groupedMatches: PublishSubject<[ScheduleGroupByLeagueMatches]> = PublishSubject()
    
    private let matchApi: MatchApi
    
    init(matchApi: MatchApi) {
        self.matchApi = matchApi
    }
    
    func fetch() {
        loading.onNext(true)
        
        matchApi.get_mainRefMatchesModelsGroupedByLeague { result in
            switch result {
            case .success(let groupedMatches):
                
                self.groupedMatches.onNext(groupedMatches)
                
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
