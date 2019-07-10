//
//  RefereesViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 03/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

class RefereesViewModel {
    var referees: PublishSubject<Players> = PublishSubject()
    var error: PublishSubject<Error?> = PublishSubject()
    var refreshing: PublishSubject<Bool> = PublishSubject()
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetch(closure: @escaping ()->()) {
        refreshing.onNext(true)
        
        dataManager.get_referees(get_success: { (referees) in
//            Print.m(referees)
            self.refreshing.onNext(false)
            self.referees.onNext(referees)
            closure()
        }) { (error) in
            Print.m(error)
            self.error.onNext(error)
            closure()
        }
    }
}
