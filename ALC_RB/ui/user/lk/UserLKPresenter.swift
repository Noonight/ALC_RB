//
//  UserLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 03.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol UserLKView: MvpView {
    
    func onRefreshUserSuccessful(authUser: AuthUser)
    func onRefreshUserFailure(authUser: Error)
}

class UserLKPresenter: MvpPresenter<UserLKViewController> {
    
    private let personApi = PersonApi()
    private let leagueApi = LeagueApi()
    
    func refreshUser(token: String) {
        personApi.get_refreshAuthUser(token: token) { result in
            switch result {
            case .success(let authUser):
                self.getView().onRefreshUserSuccessful(authUser: authUser)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
                self.getView().onRefreshUserFailure(authUser: error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
    func fetchMainRefLeagues() {
        guard let userId = UserDefaultsHelper().getAuthorizedUser()?.person.id else { return }
        let params = ParamBuilder<League.CodingKeys>()
            .add(key: .status, value: StrBuilder().add(.comma).add([League.Status.pending.rawValue, League.Status.started.rawValue]))
            .add(key: .mainReferee, value: userId)
            .select(.mainReferee)
            .get()
        leagueApi.get_league(params: params) { result in
            switch result {
            case .success(let leagues):
                
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
