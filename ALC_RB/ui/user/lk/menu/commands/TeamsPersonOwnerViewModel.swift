//
//  TeamsOwnerViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TeamsPersonOwnerViewModel {
    
    let error = PublishSubject<Error?>()
    let loading = PublishSubject<Bool>()
    let message = PublishSubject<SingleLineMessage?>()
    let ownerTeams = PublishSubject<[TeamModelItem]>()
    
    private let teamApi: TeamApi
    private let userDefaults = UserDefaultsHelper()
    
    init(teamApi: TeamApi) {
        self.teamApi = teamApi
    }
    
    func fetch() {
        self.loading.onNext(true)
        
        let userId = userDefaults.getAuthorizedUser()?.person.id
        let params = ParamBuilder<Team.CodingKeys>()
            .add(key: .creator, value: userId)
            .get()
        teamApi.get_team(params: params) { result in
            switch result {
            case .success(let teams):
                var tmi = [TeamModelItem]()
                for i in teams {
                    tmi.append(TeamModelItem(team: i))
                }
                self.ownerTeams.onNext(tmi)
            case .message(let message):
                Print.m(message.message)
                self.message.onNext(message)
            case .failure(.error(let error)):
                Print.m(error)
                self.error.onNext(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
                self.message.onNext(SingleLineMessage("Не валидные данные"))
            }
        }
    }
    
}
