//
//  ChoosePersonVM.swift
//  ALC_RB
//
//  Created by ayur on 28.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ChoosePersonVM {
    
    let loading = PublishSubject<Bool>()
    let error = PublishSubject<Error?>()
    let message = PublishSubject<SingleLineMessage>()
    let query = BehaviorRelay<String?>(value: nil)
    let choosedRegion = BehaviorRelay<RegionMy?>(value: nil)
    
    let findedPersons = PublishSubject<[PersonModelItem]>()
    
    let personApi: PersonApi
    
    init(personApi: PersonApi) {
        self.personApi = personApi
    }
    
    func fetch() {
        self.loading.onNext(true) // TODO: make request with limit and offset
        self.personApi.get_personQuery(name: query.value, surname: query.value, lastname: query.value, region: choosedRegion.value, limit: Constants.Values.LIMIT_ALL) { result in
            switch result {
            case .success(let persons):
                self.findedPersons.onNext(persons.map { PersonModelItem(person: $0) })
            case .message(let message):
                Print.m(message.message)
                self.message.onNext(message)
            case .failure(.error(let error)):
                Print.m(error)
                self.error.onNext(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
                self.message.onNext(SingleLineMessage(Constants.Texts.NOT_VALID_DATA))
            }
            self.loading.onNext(false)
        }
    }
    
}
