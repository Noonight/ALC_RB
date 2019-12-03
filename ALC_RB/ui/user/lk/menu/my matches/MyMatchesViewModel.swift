//
//  MyMatchesRefViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

class MyMatchesViewModel {
    
    let message = PublishSubject<SingleLineMessage?>()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<Error?> = PublishSubject()
    
    let matches = PublishSubject<[MyMatchModelItem]>()
    
    private let matchApi: MatchApi
    
    init(matchApi: MatchApi) {
        self.matchApi = matchApi
    }
    
    func fetch() {
        self.loading.onNext(true)
        guard let userId = UserDefaultsHelper().getAuthorizedUser()?.person.id else { return }
        let params = ParamBuilder<Match.CodingKeys>()
            .add(key: "referees.person", value: userId)
            .add(key: .played, value: false)
            .populate(StrBuilder().add([.teamOne, .teamTwo, .league, .place]).add("referees.person"))
            .get()
        self.matchApi.get_match(params: params) { result in
            switch result {
            case .success(let findedMatches):
                self.matches.onNext(findedMatches.map { MyMatchModelItem(match: $0) })
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
