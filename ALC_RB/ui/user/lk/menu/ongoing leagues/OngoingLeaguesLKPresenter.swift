//
//  OngoingLeaguesLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 15.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol OngoingLeaguesLKView: MvpView {
    
    func getTournamentsSuccess(tournaments: [Tourney])
    func getTournamentsFailure(error: Error)
    
    func getClubsSuccess(clubs: [Club])
    func getClubsFailure(error: Error)
    
    func onFetchSuccess()
    
}

class OngoingLeaguesLKPresenter: MvpPresenter<OngoingLeaguesLKTableViewController> {
    
    let apiService = ApiRequests()
    let tourneyApi = TourneyApi()
    
    func fetch() {
        let group = DispatchGroup()
        group.enter()
        self.getTournaments {
            group.leave()
        }
        group.enter()
//        self.getClubs {
//            group.leave()
//        }
        group.notify(queue: .main) {
            self.getView().onFetchSuccess()
        }
    }
    
    func getTournaments(closure: @escaping () -> ()) {
        tourneyApi.get_tourney { result in
            switch result {
            case .success(let tourneys):
                self.getView().getTournamentsSuccess(tournaments: tourneys)
            case .message(let msg):
                Print.m(msg.message)
            case .failure(.error(let error)):
                self.getView().getTournamentsFailure(error: error)
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
            closure()
        }
    }

    // DEPRECATED: clubs
//    func getClubs(closure: @escaping () -> ()) {
//        apiService.get_clubs(get_success: { (clubs) in
//            self.getView().getClubsSuccess(clubs: clubs)
//            closure()
//        }) { (error) in
//            self.getView().getClubsFailure(error: error)
//        }
//    }
    
    func getClubImage(imagePath: String, get_success: @escaping (UIImage) -> (), get_failure: @escaping (Error) -> ()) {
        apiService.get_image(imagePath: imagePath, get_success: { (image) in
            get_success(image)
        }) { (error) in
            get_failure(error)
        }
    }
    
}
