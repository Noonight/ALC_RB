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
            .responseUpcomingMatches { response in
                
                //print(response.data)
                //print(response.error)
                //try! print(response.result.value?.jsonString())
                //print(response.request)
                
                if let upcomingMatches = response.result.value {
                    self.getView().onGetUpcomingMatchesSuccesful(data: upcomingMatches)
                }
        }
    }
    
}
