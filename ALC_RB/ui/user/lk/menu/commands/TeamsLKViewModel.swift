//
//  CommandsLKViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TeamsLKViewModel {
    
    var error: Observable<Error?> {
        return Observable.combineLatest(teamOwnerVM.error, teamInVM.error) { e1, e2 in
            if e1 != nil {
                return e1
            }
            if e2 != nil {
                return e2
            }
            return nil
        }
    }
    var loading: Observable<Bool> {
        return Observable.combineLatest(teamOwnerVM.loading, teamInVM.loading) { l1, l2 in
            if l1 || l2 {
                return true
            } else {
                return false
            }
        }
    }
    var message: Observable<SingleLineMessage?> {
        return Observable.combineLatest(teamOwnerVM.message, teamInVM.message) { m1, m2 in
            if m1 != nil {
                return m1
            }
            if m2 != nil {
                return m2
            }
            return nil
        }
    }
    
    let teamOwnerVM: TeamsPersonOwnerViewModel
    let teamInVM: TeamsPersonInViewModel
    let teamEditVM: TeamEditLKViewModel
    
    init(leagueApi: LeagueApi, teamApi: TeamApi, personApi: PersonApi, inviteApi: InviteApi) {
        self.teamOwnerVM = TeamsPersonOwnerViewModel(leagueApi: leagueApi, teamApi: teamApi)
        self.teamInVM = TeamsPersonInViewModel(leagueApi: leagueApi, inviteApi: inviteApi)
        self.teamEditVM = TeamEditLKViewModel(teamApi: teamApi, personApi: personApi, inviteApi: inviteApi)
    }
    
    func fetch() {
        teamOwnerVM.fetch()
        teamInVM.fetch()
    }
    
}
