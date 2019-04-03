//
//  CommandEditLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol CommandEditLKView: MvpView {
    
    func onGetPersonsComplete(players: Players)
    func onGetPersonsFailure(error: Error)
    
}

class CommandEditLKPresenter: MvpPresenter<CommandEditLKViewController> {
    
    let apiService = ApiRequests()
    
    func getPersons() {
        apiService.get_players(limit: 32575, offset: 0, get_success: { (players) in
            self.getView().onGetPersonsComplete(players: players)
        }, get_failure: { (error) in
            self.getView().onGetPersonsFailure(error: error)
        })
    }
    
}
