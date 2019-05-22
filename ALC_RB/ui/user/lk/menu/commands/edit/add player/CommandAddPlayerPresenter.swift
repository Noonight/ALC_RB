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
    
}
