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
    private let personApi: PersonApi
    
    init(dataManager: ApiRequests, personApi: PersonApi) {
        self.dataManager = dataManager
        self.personApi = personApi
    }
    
    func fetch(closure: @escaping ()->()) {
        refreshing.onNext(true)
        
        personApi.get_person { result in
            self.refreshing.onNext(false)
            switch result {
            case .success(let persons):
                self.referees.onNext(Players(persons: persons, count: persons.count))
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
                self.error.onNext(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
            closure()
        }
//        dataManager.get_referees(get_success: { (referees) in
////            Print.m(referees)
//            self.refreshing.onNext(false)
//            self.referees.onNext(referees)
//            closure()
//        }) { (error) in
//            Print.m(error)
//            self.error.onNext(error)
//            closure()
//        }
    }
}
