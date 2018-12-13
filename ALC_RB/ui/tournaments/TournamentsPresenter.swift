//
//  TournamentsPresenter.swift
//  ALC_RB
//
//  Created by ayur on 12.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire

class TournamentsPresenter: MvpPresenter<TournamentsTableViewController> {
    
    func getTournaments() {
        
        Alamofire
            .request(ApiRoute.getApiURL(.tournaments))
            .responseTournaments { response in
                if let tournaments = response.result.value {
                    self.getView().onGetTournamentSuccess(tournament: tournaments)
                }
        }
        
    }
    
}
