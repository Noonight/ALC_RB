//
//  TournamentsPresenter.swift
//  ALC_RB
//
//  Created by ayur on 12.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire

protocol TournamentsView: MvpView {
    func onGetTournamentSuccess(tournament: Tournaments)
}

class TournamentsPresenter: MvpPresenter<TournamentsTableViewController> {
    
    func getTournaments() {
        
        Alamofire
            .request(ApiRoute.getApiURL(.tournaments))
            .responseTournaments { response in
                if let tournaments = response.result.value {
                    debugPrint(tournaments)
                    self.getView().onGetTournamentSuccess(tournament: tournaments)
                }
        }
        
    }
    
}
