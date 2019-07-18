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
    
    func onFetchSuccess()
    
}

class OngoingLeaguesLKPresenter: MvpPresenter<OngoingLeaguesLKTableViewController> {
    
    let apiService = ApiRequests()
    
    func fetch() {
        let group = DispatchGroup()
        group.enter()
        self.getTournaments {
            group.leave()
        }
        group.enter()
        self.getClubs {
            group.leave()
        }
        group.notify(queue: .main) {
            self.getView().onFetchSuccess()
        }
    }
    
    func getTournaments(closure: @escaping () -> ()) {
        apiService.get_tournamets(get_success: { (tournaments) in
            self.getView().getTournamentsSuccess(tournaments: tournaments)
            closure()
        }) { (error) in
            self.getView().getTournamentsFailure(error: error)
        }
    }
    
    func getClubs(closure: @escaping () -> ()) {
        apiService.get_clubs(get_success: { (clubs) in
            self.getView().getClubsSuccess(clubs: clubs)
            closure()
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
