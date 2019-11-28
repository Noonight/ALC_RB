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
    
    let findedTeamPersons = PublishSubject<[TeamAddPlayerModelItem]?>()
    
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
                for i in 0..<findedPersons.count {
                    if let playerStatus = self.teamPersonInvitesViewModel.teamPersonInvites.value.filter({ teamPlayerInvite -> Bool in
                        return teamPlayerInvite.person?.getId() ?? teamPlayerInvite.person?.getValue()?.id == findedPersons[i].id
                    }).first {
                        resultArray.append(TeamAddPlayerModelItem(person: findedPersons[i], status: playerStatus.status))
                    } else {
                        resultArray.append(TeamAddPlayerModelItem(person: findedPersons[i]))
                    }
                }
                
                self.findedTeamPersons.onNext(resultArray)
                
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
