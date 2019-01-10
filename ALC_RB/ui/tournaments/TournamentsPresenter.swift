//
//  TournamentsPresenter.swift
//  ALC_RB
//
//  Created by ayur on 12.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire

protocol TournamentsView: MvpView, ActivityIndicator {
    func onGetTournamentSuccess(tournament: Tournaments)
}

class TournamentsPresenter: MvpPresenter<TournamentsTableViewController> {
    
    func getTournaments() {
        
        self.getView().showLoading()
        debugPrint("Indicator show loading start")
        Alamofire
            .request(ApiRoute.getApiURL(.tournaments))
            .responseTournaments { response in
                if let tournaments = response.result.value {
                    self.getView().onGetTournamentSuccess(tournament: tournaments)
                    self.getView().hideLoading()
                }
        }
        
    }
    
}
