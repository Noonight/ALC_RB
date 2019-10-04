//
//  TournamentsPresenter.swift
//  ALC_RB
//
//  Created by ayur on 12.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire

protocol TournamentsView: MvpView, ActivityIndicatorProtocol {
    func onGetTournamentSuccess(tournament: Tournaments)
    func onGetTournamentFailure(error: Error)
}

class TournamentsPresenter: MvpPresenter<TournamentsTableViewController> {
    
    let dataManager = ApiRequests()
    
    func getTournaments() {
        dataManager.get_tournamets(get_success: { tournaments in
            self.getView().onGetTournamentSuccess(tournament: tournaments)
        }) { error in
            self.getView().onGetTournamentFailure(error: error)
        }
    }
}
