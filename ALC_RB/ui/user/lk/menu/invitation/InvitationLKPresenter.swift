//
//  InvitationLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 11.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

protocol InvitationLKView: MvpView {
    
    func acceptRequestSuccess(soloPerson: SinglePerson)
    func acceptRequestFailureMessage(message: SingleLineMessage)
    func acceptRequestFailure(error: Error)
    
    func getTournamentsSuccess(tournaments: [Tourney])
    func getTournamentsFailure(error: Error)
    
    func getTournamentLeagueSuccess(liLeagueInfo: [League])
    func getTournamentLeagueFailure(error: Error)
    
    func getPlayersSuccess(players: [Person])
    func getPlayersFailure(error: Error)
    
    func getClubsSuccess(clubs: [Club])
    func getClubsFailure(error: Error)
    
    func onRefreshUserSuccess(authUser: AuthUser)
    func onRefreshUserFailure(error: Error)
}

class InvitationLKPresenter: MvpPresenter<InvitationLKTableViewController> {
    
    let teamAPi = TeamApi()
    let personApi = PersonApi()
    
    func acceptRequest(token: String, acceptInfo: AcceptRequest) {
        Print.m("requst \n token == \(token) \n acceptInfo == \(acceptInfo.toParams())")
        teamAPi.post_teamAcceptRequest(token: token, acceptInfo: acceptInfo, response_success: { soloPerson in
            self.getView().acceptRequestSuccess(soloPerson: soloPerson)
        }, response_message: { message in
            self.getView().acceptRequestFailureMessage(message: message)
        }) { (error) in
            self.getView().acceptRequestFailure(error: error)
        }
    }
    
    func getTournaments() {
//        apiService.get_tournamets(get_success: { (tournaments) in
//            self.getView().getTournamentsSuccess(tournaments: tournaments)
//        }) { (error) in
//            self.getView().getTournamentsFailure(error: error)
//        }
    }
    
    func getTournamentLeague(id: String) {
//        apiService.get_tournamentLeague(id: id, get_success: { (liLeagueInfo) in
//            self.getView().getTournamentLeagueSuccess(liLeagueInfo: liLeagueInfo)
//        }) { (error) in
//            self.getView().getTournamentsFailure(error: error)
//        }
    }
    
    func refreshUser(token: String) {
        personApi.get_refreshAuthUser(token: token) { result in
            switch result {
            case .success(let authUser):
                self.getView().onRefreshUserSuccess(authUser: authUser)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
                self.getView().onRefreshUserFailure(error: error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
//    func getPlayersWithQuery(query: String) {
//        apiService.get_playersWithQuery(query: query, get_success: { (players) in
//
//        }) { (error) in
//
//        }
//    }
    
    func getPlayers() {
        personApi.get_person(limit: Constants.Values.LIMIT_ALL) { result in
            switch result {
            case .success(let persons):
                self.getView().getPlayersSuccess(players: persons)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
                self.getView().getPlayersFailure(error: error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
//        apiService.get_players(limit: 32575, offset: 0, get_success: { (players) in
//            self.getView().getPlayersSuccess(players: players)
//        }) { (error) in
//            self.getView().getPlayersFailure(error: error)
//        }
    }
    
    func getClubs() {
//        apiService.get_clubs(get_success: { (clubs) in
//            self.getView().getClubsSuccess(clubs: clubs)
//        }) { (error) in
//            self.getView().getClubsFailure(error: error)
//        }
    }
    
    func getTournamentImage(photoUrl: String, get_image_success: @escaping (UIImage) -> (), get_image_failure: @escaping (Error) -> ()) {
        // DEPRECATED: use  kingfisher
//        apiService.get_image(imagePath: photoUrl, get_success: { (image) in
//            get_image_success(image)
//        }) { (error) in
//            get_image_failure(error)
//        }
    }
    
}
