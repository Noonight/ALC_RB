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
    
    func acceptRequestSuccess(authUser: AuthUser)
    func acceptRequestFailure(error: Error)
    
    func getTournamentsSuccess(tournaments: Tournaments)
    func getTournamentsFailure(error: Error)
    
    func getTournamentLeagueSuccess(liLeagueInfo: LILeagueInfo)
    func getTournamentLeagueFailure(error: Error)
    
    func getPlayersSuccess(players: Players)
    func getPlayersFailure(error: Error)
    
    func getClubsSuccess(clubs: Clubs)
    func getClubsFailure(error: Error)
    
}

class InvitationLKPresenter: MvpPresenter<InvitationLKTableViewController> {
    
    let apiService = ApiRequests()
    
    func acceptRequest(token: String, acceptInfo: AcceptRequest) {
        apiService.post_teamAcceptRequest(token: token, acceptInfo: acceptInfo, response_success: { (authUser) in
            self.getView().acceptRequestSuccess(authUser: authUser)
        }) { (error) in
            self.getView().acceptRequestFailure(error: error)
        }
    }
    
    func getTournaments() {
        apiService.get_tournamets(get_success: { (tournaments) in
            self.getView().getTournamentsSuccess(tournaments: tournaments)
        }) { (error) in
            self.getView().getTournamentsFailure(error: error)
        }
    }
    
    func getTournamentLeague(id: String) {
        apiService.get_tournamentLeague(id: id, get_success: { (liLeagueInfo) in
            self.getView().getTournamentLeagueSuccess(liLeagueInfo: liLeagueInfo)
        }) { (error) in
            self.getView().getTournamentsFailure(error: error)
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
        apiService.get_players(limit: 32575, offset: 0, get_success: { (players) in
            self.getView().getPlayersSuccess(players: players)
        }) { (error) in
            self.getView().getPlayersFailure(error: error)
        }
    }
    
    func getClubs() {
        apiService.get_clubs(get_success: { (clubs) in
            self.getView().getClubsSuccess(clubs: clubs)
        }) { (error) in
            self.getView().getClubsFailure(error: error)
        }
    }
    
    func getTournamentImage(photoUrl: String, get_image_success: @escaping (UIImage) -> (), get_image_failure: @escaping (Error) -> ()) {
        apiService.get_image(imagePath: photoUrl, get_success: { (image) in
            get_image_success(image)
        }) { (error) in
            get_image_failure(error)
        }
    }
    
}
