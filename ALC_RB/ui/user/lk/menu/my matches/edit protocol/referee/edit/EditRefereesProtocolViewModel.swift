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
    
    var cache: EditMatchReferees?
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetchReferees(closure: @escaping () -> ()) {
        self.refreshing.onNext(true)
        dataManager.get_referees { result in
            self.refreshing.onNext(false)
            switch result {
            case .success(let referees):
                self.referees.value = referees
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
            closure()
        }
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
