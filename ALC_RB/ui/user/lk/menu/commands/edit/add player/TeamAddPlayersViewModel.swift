//
//  TeamAddPlayersViewModel.swift
//  ALC_RB
//
//  Created by ayur on 28.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TeamAddPlayersViewModel {
    
    let error = PublishSubject<Error?>()
    let loading = PublishSubject<Bool>()
    let message = PublishSubject<SingleLineMessage?>()
    
    let team = BehaviorRelay<Team?>(value: nil)
    
    let choosedRegion = BehaviorRelay<RegionMy?>(value: nil)
    let query = BehaviorRelay<String?>(value: nil)
    
    let findedTeamPersons = BehaviorRelay<[TeamAddPlayerModelItem]?>(value: [])
    
    var teamPersonInvitesViewModel: TeamPersonInvitesViewModel
    
    let personApi: PersonApi
    
    init(personApi: PersonApi, inviteApi: InviteApi) {
        self.personApi = personApi
        self.teamPersonInvitesViewModel = TeamPersonInvitesViewModel(inviteApi: inviteApi)
    }
    
    func fetch() {
        self.loading.onNext(true)
        self.personApi.get_personQuery(name: query.value, surname: query.value, lastname: query.value, region: choosedRegion.value, limit: Constants.Values.LIMIT_ALL) { result in
            switch result {
            case .success(let persons):
                var resultArray = [TeamAddPlayerModelItem]()
                
                var findedPersons = persons
                
                let teamInvites = self.teamPersonInvitesViewModel.teamPersonInvites.value
                let teamPlayers = self.team.value?.players ?? []
                
                for i in 0..<findedPersons.count {
                    
                    if let teamIn = teamPlayers.filter({ teamPlayer -> Bool in
                        return teamPlayer.person?.orEqual(findedPersons[i].id, { person -> Bool in
                            return person.id == findedPersons[i].id
                        }) ?? false
                    }).first {
                        resultArray.append(TeamAddPlayerModelItem(person: findedPersons[i], status: .accepted))
                        continue
                    }
                    else
                    if let playerStatus = teamInvites.filter({ teamInvite -> Bool in
                        return teamInvite.person?.orEqual(findedPersons[i].id, { person -> Bool in
                            return person.id == findedPersons[i].id
                        }) ?? false
                    }).first {
                        if playerStatus.status == .pending {
                            resultArray.append(TeamAddPlayerModelItem(person: findedPersons[i], status: playerStatus.status))
                        } else {
                            resultArray.append(TeamAddPlayerModelItem(person: findedPersons[i]))
                        }
                        
                    }
                    else
                    {
                        resultArray.append(TeamAddPlayerModelItem(person: findedPersons[i]))
                    }
                }
                
                self.findedTeamPersons.accept(resultArray)
                
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
