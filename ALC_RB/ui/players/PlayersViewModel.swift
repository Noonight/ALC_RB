//
//  PlayersViewModel.swift
//  ALC_RB
//
//  Created by mac on 08.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class PlayersViewModel {
    
    let persons = PublishSubject<[Person]>()
    let filteredPersons = PublishSubject<[Person]>()
    let error: PublishSubject<Error?> = PublishSubject()
    let encodeFail = PublishSubject<Void>()
    let message: PublishSubject<SingleLineMessage?> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    
    let offset = BehaviorRelay<Int>(value: 0)
    let query = BehaviorRelay<String?>(value: nil)
    
    let region = BehaviorRelay<RegionMy?>(value: nil)
    
    private let personApi: PersonApi
    
    init(personApi: PersonApi) {
        self.personApi = personApi
    }
    
    func fetch() {
        
        self.loading.onNext(true)
        if let mQuery = query.value {
            personApi.get_personQuery(name: mQuery, surname: mQuery, lastname: mQuery, region: region.value, resultMy: { result in
                switch result {
                case .success(let persons):
                    self.filteredPersons.onNext(persons)
                case .message(let message):
                    self.message.onNext(message)
                case .failure(.error(let error)):
                    self.error.onNext(error)
                case .failure(.notExpectedData):
                    self.encodeFail.onNext(())
                }
                self.loading.onNext(false)
            })
        } else {
            personApi.get_person(region: region.value, offset: self.offset.value, resultMy: { result in
                switch result {
                case .success(let persons):
                    self.persons.onNext(persons)
                case .message(let message):
                    self.message.onNext(message)
                case .failure(.error(let error)):
                    self.error.onNext(error)
                case .failure(.notExpectedData):
                    self.encodeFail.onNext(())
                }
                self.loading.onNext(false)
            })
        }
    }
    
}
