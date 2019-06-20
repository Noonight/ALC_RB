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
    
    func getTournaments() {
        
        self.getView().showLoading()
        debugPrint("Indicator show loading start")
        Alamofire
            .request(ApiRoute.getApiURL(.tournaments))
            .responseTournaments { response in
                switch response.result {
                case .success:
                    if let tournaments = response.result.value {
                        self.getView().onGetTournamentSuccess(tournament: tournaments)
                        self.getView().hideLoading()
                    }
                case .failure(let error):
                    Print.m(error)
                    self.getView().onGetTournamentFailure(error: error)
                }
                
        }
        
    }
    
}
