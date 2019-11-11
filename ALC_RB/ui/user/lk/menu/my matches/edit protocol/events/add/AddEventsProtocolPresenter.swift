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
    let personApi = PersonApi()
    
    // in <-- array of person id s
    func fetchPersons(persons: [String], closure: @escaping ([Person]) -> (), failure: @escaping (Error) -> ()) {
        var resultPersons: [Person] = []
        let dispatchGroup = DispatchGroup()
        for item in persons {
            dispatchGroup.enter()
            personApi.get_person(id: item) { result in
                switch result {
                case .success(let persons):
                    resultPersons.append(persons.first!)
                    dispatchGroup.leave()
                case .message(let message):
                    Print.m(message.message)
                case .failure(.error(let error)):
                    Print.m(error)
                    failure(error)
                case .failure(.notExpectedData):
                    Print.m("not expected data")
                }
            }
//            dataManager.get_getPerson(id: item, success: { getPerson in
//                resultPersons.append(getPerson.person!)
//                dispatchGroup.leave()
//            }) { error in
//                failure(error)
//            }
        }
        dispatchGroup.notify(queue: .main) {
            closure(resultPersons)
        }
    }
    
}
