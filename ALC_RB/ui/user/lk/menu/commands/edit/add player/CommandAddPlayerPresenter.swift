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
    
    func onRequestAddPlayerToTeamSuccess(soloLeague: SoloLeague)
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
    let personApi = PersonApi()
    
    func fetchPersons(limit: Int = 20, offset: Int) {
        personApi.get_person { result in
            switch result {
            case .success(let persons):
                self.getView().onFetchPersonsSuccess(players: Players(persons: persons, count: persons.count))
            case .failure(.error(let error)):
                self.getView().onFetchPersonsFailure(error: error)
            default: Print.m("not used")
            }
        }
//        apiService.get_players(limit: limit, offset: offset, get_success: { (players) in
//            self.getView().onFetchPersonsSuccess(players: players)
//        }) { (error) in
//            self.getView().onFetchPersonsFailure(error: error)
//        }
    }
    
    func addPlayerToTeamForLeague(token: String, addPlayerToTeam: AddPlayerToTeam) {
        apiService.post_addPlayerToTeam(token: token, addPlayerToTeam: addPlayerToTeam, response_success: { soloLeague in
            self.getView().onRequestAddPlayerToTeamSuccess(soloLeague: soloLeague)
        }, response_failure: { error in
            self.getView().onRequestAddPlayerToTeamError(error: error)
        }) { message in
            self.getView().onRequestAddPlayerToTeamMessage(singleLineMessage: message)
        }
    }
    
    func findPersons(query: String) {
        personApi.get_personQuery(name: query, surname: query, lastname: query) { result in
            switch result {
            case .success(let persons):
                self.getView().onFetchPersonsSuccess(players: Players(persons: persons, count: persons.count))
            case .failure(.error(let error)):
                self.getView().onFetchPersonsFailure(error: error)
            default: Print.m("not used")
            }
        }
//        apiService.get_playersWithQuery(query: query, get_success: { (players) in
//            self.getView().onFetchQueryPersonsSuccess(players: players)
//        }) { (error) in
//            self.getView().onFetchQueryPersonsFailure(error: error)
//        }
    }
    
    func fetchInfScroll(limit: Int = 20, offset: Int = 0) {
        personApi.get_personQuery(limit: limit, offset: offset) { result in
            switch result {
            case .success(let persons):
                self.getView().onFetchScrollSuccessful(players: Players(persons: persons, count: persons.count))
            case .failure(.error(let error)):
                self.getView().onFetchScrollFailure(error: error)
            default: Print.m("not used")
            }
        }
//        apiService.get_players(limit: limit, offset: offset, get_success: { players in
////            self.getView().onFetchPersonsSuccess(players: players)
//            self.getView().onFetchScrollSuccessful(players: players)
//        }) { error in
////            self.getView().onFetchFailure(error: error)
//            self.getView().onFetchScrollFailure(error: error)
//        }
    }
    // only first 20
    func fetch() {
        personApi.get_person { result in
            switch result {
            case .success(let persons):
                self.getView().onFetchSuccessful(player: Players(persons: persons, count: persons.count))
            case .failure(.error(let error)):
                self.getView().onFetchFailure(error: error)
            default: Print.m("not used")
            }
        }
//        apiService.get_players(limit: 20, offset: 0, get_success: { players in
//            self.getView().onFetchSuccessful(player: players)
//        }) { error in
//            self.getView().onFetchFailure(error: error)
//        }
    }
}
