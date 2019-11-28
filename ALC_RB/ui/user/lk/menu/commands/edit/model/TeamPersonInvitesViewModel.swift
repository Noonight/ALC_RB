//
//  PersonInvitesViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 26.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TeamPersonInvitesViewModel {
    
    let error = PublishSubject<Error?>()
    let loading = PublishSubject<Bool>()
    let message = PublishSubject<SingleLineMessage?>()
    
    let team = BehaviorRelay<Team?>(value: nil)
    
    let teamPersonInvites = BehaviorRelay<[TeamPlayerInviteStatus]>(value: [])
    
//    let person = BehaviorRelay<String?>(value: nil)
    
    let inviteApi: InviteApi
    
    init(inviteApi: InviteApi) {
        self.inviteApi = inviteApi
    }
    
    func fetch() {
        self.loading.onNext(true)
        guard let teamId = team.value?.id else { assertionFailure("LOOK AT WHAT YOU DO"); return }
        let params = ParamBuilder<TeamPlayerInviteStatus.CodingKeys>()
            .add(key: .team, value: teamId)
            .populate(.person)
            .get()
        inviteApi.get_personInvite(params: params) { result in
            switch result {
            case .success(let teamPersonInviteStatuses):
                Print.m(teamPersonInviteStatuses)
                self.teamPersonInvites.accept(teamPersonInviteStatuses)
//                dump(teamPersonInviteStatuses)
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
    
    func requestCancelInvite(inviteId: String, resultMy: @escaping (ResultMy<TeamPlayerInviteStatus, RequestError>) -> ()) {
        inviteApi.post_cancelPersonInvite(id: inviteId, resultMy: resultMy)
    }
    
    func requestInvite(personId: String, resultMy: @escaping (ResultMy<TeamPlayerInviteStatus, RequestError>) -> ()) {
        guard let team = self.team.value else { return }
        inviteApi.post_personInvite(invite: TeamPlayerInviteStatus(team: IdRefObjectWrapper<Team>(team), person: IdRefObjectWrapper<Person>(personId)), resultMy: resultMy)
    }
    
}
