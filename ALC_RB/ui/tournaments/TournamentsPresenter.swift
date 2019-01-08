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
                print(response.debugDescription)
                print(response.description)
                print(response.error.debugDescription)
                try! debugPrint(response.result.value)
                if let tournaments = response.result.value {
                    debugPrint(tournaments)
                    self.getView().onGetTournamentSuccess(tournament: tournaments)
                }
        }
        
        Alamofire
            .request(ApiRoute.getApiURL(.tournaments))
            .response { (response) in
                print(response.response?.debugDescription)
        }
        
    }
    
}
