//
//  CommandAddPlayerPresenter.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 25/04/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol CommandAddPlayerView: MvpView {
    func onFetchPersonsSuccess(players: Players)
    func onFetchPersonsFailure(error: Error)
    
    func onRequestAddPlayerToTeamSuccess(liLeagueInfo: LILeagueInfo)
    func onRequestAddPlayerToTeamMessage(singleLineMessage: SingleLineMessage)
    func onRequestAddPlayerToTeamError(error: Error)
    
    func onFetchQueryPersonsSuccess(players: Players)
    func onFetchQueryPersonsFailure(error: Error)
    
    func onFetchSuccessful(player: Players)
    func onFetchFailure(error: Error)
    
    func onFetchScrollSuccessful(players: Players)
    func onFetchScrollFailure(error: Error)
}

class CommandAddPlayerPresenter: MvpPresenter<CommandAddPlayerTableViewController> {
    let apiService = ApiRequests()
    
    func fetchPersons(limit: Int = 20, offset: Int) {
        apiService.get_players(limit: limit, offset: offset, get_success: { (players) in
            self.getView().onFetchPersonsSuccess(players: players)
        }) { (error) in
            self.getView().onFetchPersonsFailure(error: error)
        }
    }
    
    func addPlayerToTeamForLeague(token: String, addPlayerToTeam: AddPlayerToTeam) {
        apiService.post_addPlayerToTeam(token: token, addPlayerToTeam: addPlayerToTeam, response_success: { liLeagueInfo in
            self.getView().onRequestAddPlayerToTeamSuccess(liLeagueInfo: liLeagueInfo)
        }, response_failure: { error in
            self.getView().onRequestAddPlayerToTeamError(error: error)
        }) { message in
            self.getView().onRequestAddPlayerToTeamMessage(singleLineMessage: message)
        }
    }
    
    func findPersons(query: String) {
        apiService.get_playersWithQuery(query: query, get_success: { (players) in
            self.getView().onFetchQueryPersonsSuccess(players: players)
        }) { (error) in
            self.getView().onFetchQueryPersonsFailure(error: error)
        }
    }
    
    func fetchInfScroll(limit: Int = 20, offset: Int = 0) {
        apiService.get_players(limit: limit, offset: offset, get_success: { players in
//            self.getView().onFetchPersonsSuccess(players: players)
            self.getView().onFetchScrollSuccessful(players: players)
        }) { error in
//            self.getView().onFetchFailure(error: error)
            self.getView().onFetchScrollFailure(error: error)
        }
    }
    // only first 20
    func fetch() {
        apiService.get_players(limit: 20, offset: 0, get_success: { players in
            self.getView().onFetchSuccessful(player: players)
        }) { error in
            self.getView().onFetchFailure(error: error)
        }
    }
}
