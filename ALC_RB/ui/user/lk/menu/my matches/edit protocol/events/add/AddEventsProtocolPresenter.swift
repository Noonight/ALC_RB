//
//  AddEventsProtocolPresenter.swift
//  ALC_RB
//
//  Created by ayur on 07.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol AddEventsProtocolView : MvpView {
    
}

class AddEventsProtocolPresenter : MvpPresenter<AddEventsProtocolViewController> {
    
    let dataManager = ApiRequests()
    
    // in <-- array of person id s
    func fetchPersons(persons: [String], closure: @escaping ([GetPerson.Person]) -> (), failure: @escaping (Error) -> ()) {
        var resultPersons: [GetPerson.Person] = []
        let dispatchGroup = DispatchGroup()
        for item in persons {
            dispatchGroup.enter()
            dataManager.get_getPerson(id: item, success: { getPerson in
                resultPersons.append(getPerson.person!)
                dispatchGroup.leave()
            }) { error in
                failure(error)
            }
        }
        dispatchGroup.notify(queue: .main) {
            closure(resultPersons)
        }
    }
    
}
