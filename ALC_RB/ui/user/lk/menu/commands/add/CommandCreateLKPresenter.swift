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
    
    func onGetTournamentsSuccess(tournaments: [Tourney])
    func onGetTournamentsFailure(error: Error)
    
    func onGetClubsSuccess(clubs: [Club])
    func onGetClubsFailure(error: Error)
    
    func onCreateTeamSuccess(team: SingleTeam)
    func onCreateTeamFailure(error: Error)
    func onCreateTeamMessage(message: SingleLineMessage)
}

class CommandCreateLKPresenter : MvpPresenter<CommandCreateLKViewController> {
    
    let apiService = ApiRequests()
    let tourneyApi = TourneyApi()
    let leagueApi = LeagueApi()
    let clubApi = ClubApi()
    
    var createTeamCache: CreateTeamInfo?
    
    func getTournaments() {
        tourneyApi.get_tourney { result in
            switch result {
            case .success(let tourneys):
                self.getView().onGetTournamentsSuccess(tournaments: tourneys)
            case .message(let msg):
                Print.m(msg.message)
            case .failure(.error(let error)):
                Print.m(error)
                self.getView().onGetTournamentsFailure(error: error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
    func getClubs() {
        clubApi.get_club { result in
            switch result {
            case .success(let clubs):
                self.getView().onGetClubsSuccess(clubs: clubs)
            case .message(let msg):
                Print.m(msg.message)
            case .failure(.error(let error)):
                Print.m(error)
                self.getView().onGetClubsFailure(error: error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
    func createTeam(token: String, teamInfo: CreateTeamInfo) {
        self.createTeamCache = teamInfo
        // DEPRECATED: CREATE TEAM NOT WORKS
//        apiService.post_createTeam(token: token, teamInfo: teamInfo, response_success: { (soloTeam) in
//            self.getView().onCreateTeamSuccess(team: soloTeam)
//        }, response_failure: { (error) in
//            self.getView().onCreateTeamFailure(error: error)
//        }) { (singleLineMessage) in
//            self.getView().onCreateTeamMessage(message: singleLineMessage)
//        }
    }
    
    func createTeamNEW(token: String, teamInfo: CreateTeamInfo) {
//        apiService.post_createTeam(token: token, teamInfo: teamInfo, response_success: { (soloTeam) in
//            self.getView().onCreateTeamSuccess(team: soloTeam)
//        }, response_failure: { (error) in
//            self.getView().onCreateTeamFailure(error: error)
//        }) { (singleLineMessage) in
//            self.getView().onCreateTeamMessage(message: singleLineMessage)
//        }
    }
    
}
