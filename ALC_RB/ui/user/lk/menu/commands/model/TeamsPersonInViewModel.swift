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
    
    private let leagueApi: LeagueApi
    private let inviteApi: InviteApi
    private let userDefaults = UserDefaultsHelper()
    
    init(leagueApi: LeagueApi, inviteApi: InviteApi) {
        self.leagueApi = leagueApi
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
//                let teamModels = teams.map { TeamModelItem(team: $0) }
                
                var tmi = [TeamModelItem]()
                
                var leagueByTeamIds = [String]()
                for team in teams {
                    if team.league?.getId() != nil {
                        leagueByTeamIds.append(team.league!.getId()!)
                    }
                }
                
                var tmpTeams = teams
                
                let params1 = ParamBuilder<League.CodingKeys>()
                    .add(key: .id, value: StrBuilder().setSeparatorStyle(.comma).add(.comma).add(leagueByTeamIds))
                    .populate(.tourney)
                    .get()
                self.leagueApi.get_league(params: params1) { result in
                    switch result {
                    case .success(let leagues):
                        for i in 0..<tmpTeams.count {
                            if let league = leagues.filter({ league in
                                return league.id == tmpTeams[i].league!.getId()!
                            }).first {
                                tmpTeams[i].league = IdRefObjectWrapper<League>(league)
                            }
                        }
                        
                        for tmpTeam in tmpTeams {
                            tmi.append(TeamModelItem(team: tmpTeam))
                        }
                        
                        self.inTeams.onNext(tmi)
                        
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
                    self.loading.onNext(false)
                }
                
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
                self.message.onNext(SingleLineMessage("Не валидные данные."))
            }
        }
    }
}
