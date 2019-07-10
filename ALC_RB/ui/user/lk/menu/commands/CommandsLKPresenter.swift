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
    
    func getTournamentsSuccess(tournaments: Tournaments)
    func getTournamentsFailure(error: Error)
    
    func getRefreshUserSuccessful(authUser: AuthUser)
    func getRefreshUserFailure(error: Error)
    
}

class CommandsLKPresenter : MvpPresenter<CommandsLKTableViewController> {
    
    let apiService = ApiRequests()
    
    func getTournaments() {
        apiService.get_tournamets(get_success: { (tournaments) in
            self.getView().getTournamentsSuccess(tournaments: tournaments)
        }) { (error) in
            self.getView().getTournamentsFailure(error: error)
        }
    }
    
    func refreshUser(token: String) {
        apiService.get_refreshAuthUser(token: token, success: { authUser in
            self.getView().getRefreshUserSuccessful(authUser: authUser)
        }) { error in
            self.getView().getRefreshUserFailure(error: error)
        }
    }
    
}

