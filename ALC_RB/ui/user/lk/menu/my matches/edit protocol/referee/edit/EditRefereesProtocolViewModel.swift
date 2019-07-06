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
        dataManager.get_referees(get_success: { (referees) in
            
            self.referees.value = referees
            self.refreshing.onNext(false)
            
            closure()
            
        }) { (error) in
            self.error.onNext(error)
        }
    }
    
    func editMatchReferees(token: String, editMatchReferees: EditMatchReferees, success: @escaping (SoloMatch)->(), message_single: @escaping (SingleLineMessage)->(), failure: @escaping (Error)->()) {
        self.cache = editMatchReferees
        dataManager.post_matchSetReferee(token: token, editMatchReferees: editMatchReferees, response_success: { soloMatch in
            success(soloMatch)
        }, response_message: { message in
            message_single(message)
        }) { error in
            failure(error)
        }
    }
    
}
