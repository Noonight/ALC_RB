//
//  TournamentDetailPresenter.swift
//  ALC_RB
//
//  Created by ayur on 13.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire

protocol LeagueDetailView: MvpView {
    func onGetLeagueInfoSeccess()
}

class LeagueDetailPresenter: MvpPresenter<LeagueDetailViewController> {
    
    func getTournamentInfo(id: String) {
        
        Alamofire
            .request(ApiRoute.getApiLeagueURL(id))
            .responseLILeagueInfo { response in
                if let leagueInfo = response.result.value {
                    self.getView().onGetLeagueInfoSuccess(leagueInfo: leagueInfo)
                }
        }
        
    }
    
}
