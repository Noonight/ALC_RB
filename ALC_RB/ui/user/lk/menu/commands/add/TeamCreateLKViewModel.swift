//
//  CommandCreateLKViewModel.swift
//  ALC_RB
//
//  Created by ayur on 24.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TeamCreateLKViewModel {
    
    var loading = PublishSubject<Bool>()
    var error = PublishSubject<Error?>()
    var message = PublishSubject<SingleLineMessage>()
    var createdRequestedTeam = BehaviorRelay<Team?>(value: nil)
    
    private let teamApi: TeamApi
    
    init(teamApi: TeamApi) {
        self.teamApi = teamApi
    }
    
    func requestCreateTeam(team: Team) {
        self.loading.onNext(true)
        teamApi.post_team(team: team) { result in
            switch result {
            case .success(let team):
//                Print.m(team)
                if let league = team.league?.getId() ?? team.league?.getValue()?.id {
                    self.loading.onNext(true)
                    self.requestTeamToLeague(
                    teamParticipationRequest: TeamParticipationRequest(id: "", team: IdRefObjectWrapper<Team>(team), league: IdRefObjectWrapper<League>(league), status: .canceled)) { result in
                        switch result {
                        case .success(let participationRequest):
                            Print.m(participationRequest)
                            
                            self.createdRequestedTeam.accept(team)
                            
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
    
    func requestTeamToLeague(teamParticipationRequest: TeamParticipationRequest, resultMy: @escaping (ResultMy<TeamParticipationRequest, RequestError>) -> ()) {
        teamApi.post_teamParticipationRequest(teamParticipationRequest: teamParticipationRequest, resultMy: resultMy)
    }
}
