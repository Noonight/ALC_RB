//
//  EditScheduleViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

class EditScheduleViewModel {
    struct SlidersData {
        var defaultValues: [Referee]
        var allReferees: Players
        
        init(defaultValues: [Referee], allReferees: Players) {
            self.defaultValues = defaultValues
            self.allReferees = allReferees
        }
        
        init() {
            defaultValues = []
            allReferees = Players()
        }
        
//        func setReferee(oldRefId: String, newRefId: String) {
//            defaultValues.swapAt(defaultValues.firstIndex(where: { (ref) -> Bool in
//                return re == oldRefId
//            }), defaultValues.append(Referee()))
//        }
    }
    
    var refreshing: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<Error> = PublishSubject()
    var activeMatch: PublishSubject<ActiveMatch> = PublishSubject()
    var referees: PublishSubject<Players> = PublishSubject()
    
    var sliderData: PublishSubject<SlidersData> = PublishSubject()
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetchReferees() {
        self.refreshing.onNext(true)
        dataManager.get_referees(get_success: { (referees) in
            
            self.referees.onNext(referees)
            self.refreshing.onNext(false)

        }) { (error) in
            self.error.onNext(error)
        }
    }
    
}
