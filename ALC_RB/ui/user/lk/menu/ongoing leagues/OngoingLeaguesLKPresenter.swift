//
//  OngoingLeaguesLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 15.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol OngoingLeaguesLKView: MvpView {
    
    func getTournamentsSuccess(tournaments: Tournaments)
    func getTournamentsFailure(error: Error)
    
    func getClubsSuccess(clubs: Clubs)
    func getClubsFailure(error: Error)
    
}

class OngoingLeaguesLKPresenter: MvpPresenter<OngoingLeaguesLKTableViewController> {
    
    let apiService = ApiRequests()
    
    func getTournaments() {
        apiService.get_tournamets(get_success: { (tournaments) in
            self.getView().getTournamentsSuccess(tournaments: tournaments)
        }) { (error) in
            self.getView().getTournamentsFailure(error: error)
        }
    }
    
    func getClubs() {
        apiService.get_clubs(get_success: { (clubs) in
            self.getView().getClubsSuccess(clubs: clubs)
        }) { (error) in
            self.getView().getClubsFailure(error: error)
        }
    }
    
    func getClubImage(imagePath: String, get_success: @escaping (UIImage) -> (), get_failure: @escaping (Error) -> ()) {
        apiService.get_image(imagePath: imagePath, get_success: { (image) in
            get_success(image)
        }) { (error) in
            get_failure(error)
        }
    }
    
}
