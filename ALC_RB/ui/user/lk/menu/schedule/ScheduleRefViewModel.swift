//
//  ScheduleRefViewModel.swift
//  ALC_RB
//
//  Created by ayur on 11.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

class ScheduleRefViewModel {
    struct DataModel {
        var activeMatches = ActiveMatches()
        var referees = Players()
        var clubs: [SoloClub] = []
        
        init(activeMatches: ActiveMatches, referees: Players, clubs: [SoloClub]) {
            self.activeMatches = activeMatches
            self.referees = referees
            self.clubs = clubs
        }
        
        init(tuple: (ActiveMatches, Players, [SoloClub])) {
            self.activeMatches = tuple.0
            self.referees = tuple.1
            self.clubs = tuple.2
        }
    }
    
    var error: PublishSubject<Error?> = PublishSubject()
    var refreshing: PublishSubject<Bool> = PublishSubject()
    var message: PublishSubject<SingleLineMessage> = PublishSubject()

    var dataModel: PublishSubject<DataModel> = PublishSubject()
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetch(closure: @escaping () -> ()) {
        refreshing.onNext(true)
        
        dataManager.get_scheduleRefereeData { result in
            self.refreshing.onNext(false)
            switch result {
            case .success(let tuple):
                Print.m(tuple)
                self.dataModel.onNext(DataModel(tuple: tuple))
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
            closure()
        }
        
//        dataManager.getActiveMatchesForView(get_success: { (activeMatches, referees, clubs) in
//
//            self.refreshing.onNext(false)
//            self.dataModel.onNext(ScheduleRefViewModel.DataModel(
//                activeMatches: activeMatches,
//                referees: referees,
//                clubs: clubs)
//            )
//            closure()
//
//        }, get_message: { message in
//            self.message.onNext(message)
//            closure()
//        }) { (error) in
//            Print.m(error)
//            self.error.onNext(error)
//            closure()
//        }
    }
}
