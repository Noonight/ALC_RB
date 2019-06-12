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
    }
    
//    var activeMatches: PublishSubject<ActiveMatches> = PublishSubject()
    var error: PublishSubject<Error?> = PublishSubject()
    var refreshing: PublishSubject<Bool> = PublishSubject()
//    var referees: PublishSubject<Players> = PublishSubject()
//    var clubs: ReplaySubject<SoloClub> = ReplaySubject<SoloClub>.create(bufferSize: 4)

    var dataModel: PublishSubject<DataModel> = PublishSubject()
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetch() {
        refreshing.onNext(true)
        
        dataManager.getActiveMatchesForView(get_success: { (activeMatches, referees, clubs) in
            
//            Print.m(ScheduleRefViewModel.DataModel(activeMatches: activeMatches, referees: referees, clubs: clubs))
            dump(ScheduleRefViewModel.DataModel(activeMatches: activeMatches, referees: referees, clubs: clubs))
            
            self.refreshing.onNext(false)
            self.dataModel.onNext(ScheduleRefViewModel.DataModel(
                activeMatches: activeMatches,
                referees: referees,
                clubs: clubs)
            )
            
        }) { (error) in
            self.error.onNext(error)
        }
    }
    
//    func fetch() {
//        refreshing.onNext(true)
//
//        dataManager.get_activeMatches(get_success: { (activeMatches) in
////            self.refreshing.onNext(false)
//            self.activeMatches.onNext(activeMatches)
//        }) { (error) in
//            self.error.onNext(error)
//        }
//        fetchReferees()
//    }
    
//    func fetchReferees() {
//        dataManager.get_referees(get_success: { (referees) in
//            self.referees.onNext(referees)
//        }) { (error) in
//            self.error.onNext(error)
//            Print.m("Error with getting referees")
//        }
//    }
//
//    func fetchClub(with id: String) {
//        dataManager.get_clubById(id: id, get_success: { (soloClub) in
//            self.refreshing.onNext(false)
//            self.clubs.onNext(soloClub)
//        }) { (error) in
//            self.error.onNext(error)
//            Print.m("Fail with getting clubs by one")
//        }
//    }
}
