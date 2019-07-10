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
    
    var error: PublishSubject<Error?> = PublishSubject()
    var refreshing: PublishSubject<Bool> = PublishSubject()

    var dataModel: PublishSubject<DataModel> = PublishSubject()
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetch(closure: @escaping () -> ()) {
        refreshing.onNext(true)
        
        dataManager.getActiveMatchesForView(get_success: { (activeMatches, referees, clubs) in
            
            self.refreshing.onNext(false)
            self.dataModel.onNext(ScheduleRefViewModel.DataModel(
                activeMatches: activeMatches,
                referees: referees,
                clubs: clubs)
            )
            closure()
            
        }) { (error) in
            self.error.onNext(error)
            closure()
        }
    }
}
