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
    
    var teamPersonInvitesViewModel: TeamPersonInvitesViewModel
    
    let teamApi: TeamApi
    let personApi: PersonApi
    
    init(teamApi: TeamApi, personApi: PersonApi, inviteApi: InviteApi) {
        self.teamApi = teamApi
        self.personApi = personApi
        self.teamPersonInvitesViewModel = TeamPersonInvitesViewModel(inviteApi: inviteApi)
    }
    
    func fetch() {
//        fetchTeamPlayers {
//            Print.m("RELOAD TABLE VIEW MB")
//        }
        
        guard let teamId = team.value?.id else { return }
        teamPersonInvitesViewModel.teamId.accept(teamId)
        teamPersonInvitesViewModel.fetch()
    }
    
    func requestPatchTeam(closure: @escaping () -> ()) {
        guard let team = team.value else { return }
        self.loading.onNext(true)
        teamApi.patch_team(team: team) { result in
            switch result {
            case .success(let responseTeam):
                Print.m(responseTeam)
                closure()
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
    
    func fetchTeamPlayers(closure: @escaping () -> ()) {
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
                    
                    var findedTeamPlayers = findedTeam.players
                    
                    let personIds = findedTeamPlayers?.map({ playerStatus -> String in
                        return playerStatus.person?.getId() ?? (playerStatus.person?.getValue()?.id)!
                    })
                    Print.m("PERSONS : \(personIds)")
                    if personIds?.count ?? 0 != 0 {
                        var params1 = [String:Any]()
                        if personIds?.count ?? 0 == 1 {
                            params1 = ParamBuilder<Person.CodingKeys>()
                                .add(key: .id, value: StrBuilder().add(personIds))
                                .get()
                        } else {
                            params1 = ParamBuilder<Person.CodingKeys>()
                                .add(key: .id, value: StrBuilder().add(.comma).add(personIds))
                                .get()
                        }
                        self.personApi.get_person(params: params1) { resultPerson in
                            switch resultPerson {
                            case .success(let persons):
                                
                                Print.m(persons)
                                
                                if persons.count != 0 {
                                    if findedTeamPlayers != nil {
                                        for i in 0..<findedTeamPlayers!.count {
                                            Print.m("ITERATOR")
                                            if let person = persons.filter({ mPerson -> Bool in
                                                return mPerson.id == findedTeamPlayers![i].person?.getId()
                                            }).first {
                                                Print.m("SET PERSON VALUE")
                                                Print.m("FOR: \(findedTeamPlayers![i].person)")
                                                findedTeamPlayers![i].person = IdRefObjectWrapper<Person>(person)
                                                Print.m("TO: \(IdRefObjectWrapper<Person>(person))")
                                                Print.m("SET PERSON VALUE COMPLETE")
                                            }
                                        }
                                    }
                                }
                                
                                team.players = findedTeamPlayers
                                
                                self.team.accept(team)
//                                dump(team)
                                closure()
//                                Print.m(team)
                            case .message(let message):
                                Print.m(message.message)
                            case .failure(.error(let error)):
                                Print.m(error)
                            case .failure(.notExpectedData):
                                Print.m("not expected data")
                            }
                        }
                    } else {
                        team.players = findedTeamPlayers
                        self.team.accept(team)
                        closure()
                    }
                    // TODO: IF NEED MODIFY POPULATE
                    
                    
                    // were here
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
