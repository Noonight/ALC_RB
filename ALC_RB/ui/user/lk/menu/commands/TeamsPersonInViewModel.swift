//
//  TeamPeronInViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class TeamsPersonInViewModel {
    
    let error = PublishSubject<Error?>()
    let loading = PublishSubject<Bool>()
    let message = PublishSubject<SingleLineMessage?>()
    let inTeams = PublishSubject<[TeamModelItem]>()
    
    private let inviteApi: InviteApi
    private let userDefaults = UserDefaultsHelper()
    
    init(inviteApi: InviteApi) {
        self.inviteApi = inviteApi
    }
    
    func fetch() {
        self.loading.onNext(true)
        
        let userId = userDefaults.getAuthorizedUser()?.person.id
        let params = ParamBuilder<TeamPlayerInviteStatus.CodingKeys>()
            .add(key: .person, value: userId)
            .select(.team)
            .populate(.team)
            .get()
        inviteApi.get_personInvite(params: params) { result in
            switch result {
            case .success(let teamPlayerInvites):
                let teams = teamPlayerInvites.map { $0.team!.getValue()! }
                let teamModels = teams.map { TeamModelItem(team: $0) }
                self.inTeams.onNext(teamModels)
            case .message(let message):
                Print.m(message.message)
                self.message.onNext(message)
            case .failure(.error(let error)):
                Print.m(error)
                self.error.onNext(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
                self.message.onNext(SingleLineMessage("Не валидные данные."))
            }
            self.loading.onNext(false)
        }
    }
}
