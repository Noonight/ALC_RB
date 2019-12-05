//
//  InvitationViewModel.swift
//  ALC_RB
//
//  Created by ayur on 30.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class InvitationViewModel {
    
    let loading = PublishSubject<Bool>()
    let error = PublishSubject<Error?>()
    let message = PublishSubject<SingleLineMessage?>()
    
    let invites = BehaviorRelay<[InvitationModelItem]>(value: [])
    
    private let inviteApi: InviteApi
    private let teamApi: TeamApi
    
    init(inviteApi: InviteApi, teamApi: TeamApi) {
        self.inviteApi = inviteApi
        self.teamApi = teamApi
    }
    
    func fetch() {
        guard let userId = UserDefaultsHelper().getAuthorizedUser()?.person.id else { return }
        let params = ParamBuilder<TeamPlayerInviteStatus.CodingKeys>()
            .add(key: .person, value: userId)
            .add(key: .status, value: TeamPlayerInviteStatus.Status.pending.rawValue)
            .get()
        
        self.loading.onNext(true)
        
        inviteApi.get_personInvite(params: params) { result in
            switch result {
            case .success(let teamInvites):
                
                var invites = teamInvites
                
                if invites.count != 0 {
                    self.loading.onNext(true)
                    let params1 = ParamBuilder<Team.CodingKeys>()
                        .add(key: .id, value: StrBuilder().setSeparatorStyle(.comma).add(.comma).add(invites.map { $0.team?.getId() ?? ($0.team?.getValue()?.id)! }))
                        .populate(StrBuilder().add([.trainer, .league]))
                        .get()
                    self.teamApi.get_team(params: params1, resultMy: { result1 in
                        switch result1 {
                        case .success(let teams):
                            
                            for i in 0..<invites.count {
                                if let team = teams.filter({ mTeam -> Bool in
                                    return mTeam.id == invites[i].team?.getId() ?? (invites[i].team?.getValue()?.id)!
                                }).first {
                                    invites[i].team = IdRefObjectWrapper<Team>(team)
                                }
                            }
                            self.loading.onNext(false)
                            self.invites.accept(invites.map { InvitationModelItem(inviteStatus: $0) })
                            
//                            dump(self.invites.value)
                            
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
//                        self.loading.onNext(false)
                    })
                } else {
                    self.loading.onNext(false)
                    self.invites.accept([])
                }
                
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
        }
        
    }
    
    func requestAcceptInvite(inviteId: String, resultMy: @escaping (ResultMy<TeamPlayerInviteStatus, RequestError>) -> ()) {
        self.inviteApi.post_acceptPersonInvite(id: inviteId, resultMy: resultMy)
    }
    
    func requestRejectInvite(inviteId: String, resultMy: @escaping (ResultMy<TeamPlayerInviteStatus, RequestError>) -> ()) {
        self.inviteApi.post_rejectPersonInvite(id: inviteId, resultMy: resultMy)
    }
    
}
