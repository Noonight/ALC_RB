//
//  UpcomingGamesPresenter.swift
//  ALC_RB
//
//  Created by ayur on 07.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire

class UpcomingGamesPresenter: MvpPresenter<UpcomingGamesTableViewController> {
    
    func getUpcomingGames() {
        Alamofire
            .request(ApiRoute.getApiURL(.upcomingMatches))
            .responseMmUpcomingMatches(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let upcomingMatches = response.result.value {
                        self.getView().onGetUpcomingMatchesSuccesful(data: upcomingMatches)
                    }
                case .failure(let error):
                    self.getView().onGetUpcomingMatchesFailure(error: error)
                }
            })
//            .responseUpcomingMatches { response in
//
//                switch response.result {
//                case .success:
//                    if let upcomingMatches = response.result.value {
//                        self.getView().onGetUpcomingMatchesSuccesful(data: upcomingMatches)
//                    }
//                case .failure(let error):
//                    self.getView().onGetUpcomingMatchesFailure(error: error)
//                }
//        }
    }
    
    func findClub(clubId: String, get_club: @escaping (Club?) -> ()) {
        var club: Club?
        Alamofire
            .request(ApiRoute.getApiURL(.clubs))
            .responseClubs { response in
                if let clubs = response.result.value {
                    
                    for i in clubs.clubs {
                        if (i.id == clubId) {
                            club = i
                            get_club(club)
                        }
                    }
                    
                }
        }
        //print("DEBUG: club - \(club)")
//        return club
    }

    
}
