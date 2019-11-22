//
//  TeamEditLKViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TeamEditLKViewModel {
    
    let error = PublishSubject<Error?>()
    let loading = PublishSubject<Bool>()
    let message = PublishSubject<SingleLineMessage?>()
    
    let team = BehaviorRelay<Team?>(value: nil)
    
    let teamApi: TeamApi
    
    init(teamApi: TeamApi) {
        self.teamApi = teamApi
    }
    
    func fetch() {
        
    }
    
    func fetchTeamPlayerStatuses(closure: @escaping () -> ()) {
        guard var team = team.value else { return }
        let params = ParamBuilder<Team.CodingKeys>()
            .add(key: .id, value: team.id)
            .select(.players)
            .populate(.players)
            .get()
        teamApi.get_team(params: params) { result in
            switch result {
            case .success(let teams):
                guard let findedTeam = teams.first else { return }
                if findedTeam.id == team.id {
                    team.players = findedTeam.players
                    
                    self.team.accept(team)
                    closure()
                }
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
}
