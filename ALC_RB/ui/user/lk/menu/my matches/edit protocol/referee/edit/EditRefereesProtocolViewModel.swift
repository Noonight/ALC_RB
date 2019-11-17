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
    
//    var comingReferees: Variable<Players> = Variable<Players>([Person]())
    
    var referees: Variable<[Person]> = Variable<[Person]>([Person]())
    var comingMatch: Match!
    
    private let matchApi: MatchApi
    private let apiPerson: PersonApi
    
    var cache: EditMatchReferees?
    
    init(matchApi: MatchApi, personApi: PersonApi) {
        self.matchApi = matchApi
        self.apiPerson = personApi
    }
    
    func fetchReferees(closure: @escaping () -> ()) {
        self.refreshing.onNext(true)
        apiPerson.get_person(limit: Constants.Values.LIMIT_ALL) { result in
            switch result {
            case .success(let persons):
                self.referees.value = persons
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
    
    func editMatchReferees(token: String, editMatchReferees: EditMatchReferees, success: @escaping (Match)->(), message_single: @escaping (SingleLineMessage)->(), failure: @escaping (Error)->()) {
        self.cache = editMatchReferees
        self.refreshing.onNext(true)
        matchApi.post_matchSetReferee(token: token, editMatchReferees: editMatchReferees) { result in
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
