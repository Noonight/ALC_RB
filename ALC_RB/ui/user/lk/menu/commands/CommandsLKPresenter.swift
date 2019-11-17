//
//  CommandsLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 24.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

protocol CommandsLKView : MvpView {
    
    func getTournamentsSuccess(tournaments: [Tourney])
    func getTournamentsFailure(error: Error)
    
    func getRefreshUserSuccessful(authUser: AuthUser)
    func getRefreshUserFailure(error: Error)
    
    func onFetchSuccess()
    func onFetchFailure()
}

class CommandsLKPresenter : MvpPresenter<CommandsLKTableViewController> {
    
    let personApi = PersonApi()
    let tourneyApi = TourneyApi()
    
    func getTournaments(closure: @escaping () -> ()) {
        tourneyApi.get_tourney { result in
            switch result {
            case .success(let tourneys):
                self.getView().getTournamentsSuccess(tournaments: tourneys)
            case .message(let msg):
                Print.m(msg.message)
            case .failure(.error(let error)):
                self.getView().getTournamentsFailure(error: error)
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
//        apiService.get_tournamets(get_success: { (tournaments) in
//            self.getView().getTournamentsSuccess(tournaments: tournaments)
//            closure()
//        }) { (error) in
//            self.getView().getTournamentsFailure(error: error)
//        }
    }
    
    func refreshUser(token: String, closure: @escaping ()->()) {
        personApi.get_refreshAuthUser(token: token, success: { authUser in
            self.getView().getRefreshUserSuccessful(authUser: authUser)
            closure()
        }) { error in
            self.getView().getRefreshUserFailure(error: error)
        }
    }
    
    func fetch() {
        defer {
            Print.m("fetch failure")
            self.getView().onFetchFailure() // nothing to download
        }
        let group = DispatchGroup()
        group.enter()
        self.refreshUser(token: UserDefaultsHelper().getAuthorizedUser()!.token) {
            group.leave()
        }
        group.enter()
        self.getTournaments() {
            group.leave()
        }
        group.notify(queue: .main) {
            self.getView().onFetchSuccess()
            return
        }
    }
}

