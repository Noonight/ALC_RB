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
    
    func onRequestAddPlayerToTeamSuccess(singleLineMessage: SingleLineMessage)
    func onRequestAddPlayerToTeamFailure(singleLineMessage: SingleLineMessage)
    func onRequestAddPlayerToTeamError(error: Error)
    
    func onFetchQueryPersonsSuccess(players: Players)
    func onFetchQueryPersonsFailure(error: Error)
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
        apiService.post_addPlayerToTeam(token: token, addPlayerToTeam: addPlayerToTeam, response_success: { (singleLineMessage) in
            self.getView().onRequestAddPlayerToTeamSuccess(singleLineMessage: singleLineMessage)
        }, response_failure: { (error) in
            self.getView().onRequestAddPlayerToTeamError(error: error)
        }) { (singleLineMessage) in
            self.getView().onRequestAddPlayerToTeamFailure(singleLineMessage: singleLineMessage)
        }
    }
    
    func findPersons(query: String) {
        apiService.get_playersWithQuery(query: query, get_success: { (players) in
            self.getView().onFetchQueryPersonsSuccess(players: players)
        }) { (error) in
            self.getView().onFetchQueryPersonsFailure(error: error)
        }
    }
}
