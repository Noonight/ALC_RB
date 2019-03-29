//
//  CommandCreateLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 25.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

protocol CommandCreateLKView : MvpView {
    
    func onGetTournamentsSuccess(tournaments: Tournaments)
    func onGetTournamentsFailure(error: Error)
    
    func onGetClubsSuccess(clubs: Clubs)
    func onGetClubsFailure(error: Error)
    
}

class CommandCreateLKPresenter : MvpPresenter<CommandCreateLKViewController> {
    
    let apiService = ApiRequests()
    
    func getTournaments() {
        apiService.get_tournamets(get_success: { (tournaments) in
            self.getView().onGetTournamentsSuccess(tournaments: tournaments)
        }) { (error) in
            self.getView().onGetTournamentsFailure(error: error)
        }
    }
    
    func getClubs() {
        apiService.get_clubs(get_success: { (clubs) in
            self.getView().onGetClubsSuccess(clubs: clubs)
        }) { (error) in
            self.getView().onGetClubsFailure(error: error)
        }
    }
    
    func createClub() {
        apiService.post
    }
    
}
