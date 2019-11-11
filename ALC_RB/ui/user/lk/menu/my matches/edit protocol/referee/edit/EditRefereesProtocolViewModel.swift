//
//  EditRefereeProtocolViewModel.swift
//  ALC_RB
//
//  Created by ayur on 05.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

class EditRefereesProtocolViewModel {
    
    var refreshing: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<Error> = PublishSubject()
    var message = PublishSubject<SingleLineMessage>()
    
//    var comingReferees: Variable<Players> = Variable<Players>(Players())
    
    var referees: Variable<Players> = Variable<Players>(Players())
    var comingMatch: LIMatch!
    
    private let dataManager: ApiRequests
    private let apiPerson: PersonApi
    
    var cache: EditMatchReferees?
    
    init(dataManager: ApiRequests, personApi: PersonApi) {
        self.dataManager = dataManager
        self.apiPerson = personApi
    }
    
    func fetchReferees(closure: @escaping () -> ()) {
        self.refreshing.onNext(true)
        apiPerson.get_person(limit: Constants.Values.LIMIT_ALL) { result in
            switch result {
            case .success(let persons):
                self.referees.value = Players(persons: persons, count: persons.count)
            case .message(let message):
                self.message.onNext(message)
            case .failure(.notExpectedData):
                self.message.onNext(SingleLineMessage(message: "Not expected data. Can't parse data"))
            case .failure(.error(let error)):
                self.error.onNext(error)
            }
            closure()
        }
//        dataManager.get_referees { result in
//            self.refreshing.onNext(false)
//            switch result {
//            case .success(let referees):
//                self.referees.value = referees
//            case .message(let message):
//                self.message.onNext(message)
//            case .failure(let error):
//                self.error.onNext(error)
//            }
//            closure()
//        }
    }
    
    func editMatchReferees(token: String, editMatchReferees: EditMatchReferees, success: @escaping (SoloMatch)->(), message_single: @escaping (SingleLineMessage)->(), failure: @escaping (Error)->()) {
        self.cache = editMatchReferees
        self.refreshing.onNext(true)
        dataManager.post_matchSetReferee(token: token, editMatchReferees: editMatchReferees) { result in
            self.refreshing.onNext(false)
            switch result {
            case .success(let match):
                success(match)
            case .message(let message):
                message_single(message)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
}
