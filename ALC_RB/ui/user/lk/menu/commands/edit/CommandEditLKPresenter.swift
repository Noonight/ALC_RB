//
//  CommandEditLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CommandEditLKView: MvpView {
    
    func onGetPersonsComplete(players: [Person])
    func onGetPersonsFailure(error: Error)
    
    func onEditCommandSuccess(editTeamResponse: EditTeamResponse)
    func onEditCommandFailure(error: Error)
    func onEditCommandSingleLineMessageSuccess(singleLineMessage: SingleLineMessage)
    
}

class CommandEditLKPresenter: MvpPresenter<CommandEditLKViewController> {
    
    var loading = PublishSubject<Bool>()
    var error = PublishSubject<Error?>()
    var message = PublishSubject<SingleLineMessage>()
    
    let apiService = ApiRequests()
    let personApi = PersonApi()
    
    func getPersons() {
        personApi.get_person(offset: Constants.Values.LIMIT_ALL) { result in
            switch result {
            case .success(let persons):
                self.getView().onGetPersonsComplete(players: persons)
            case .failure(.error(let error)):
                self.getView().onGetPersonsFailure(error: error)
            default: Print.m("not used")
            }
        }
//        apiService.get_players(limit: 32575, offset: 0, get_success: { (players) in
//            self.getView().onGetPersonsComplete(players: players)
//        }, get_failure: { (error) in
//            self.getView().onGetPersonsFailure(error: error)
//        })
    }
    
    func editCommand(token: String, editTeam: EditTeam) {
        apiService.post_editTeam(token: token, editTeam: editTeam, response_success: { (editTeamResponse) in
            self.getView().onEditCommandSuccess(editTeamResponse: editTeamResponse)
        }, response_failure: { (error) in
            self.getView().onEditCommandFailure(error: error)
        }) { (singleLineResponse) in
            self.getView().onEditCommandSingleLineMessageSuccess(singleLineMessage: singleLineResponse)
        }
    }
    
}
