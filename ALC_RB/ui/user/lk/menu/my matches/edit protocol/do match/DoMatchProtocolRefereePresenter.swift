//
//  DoMatchProtocolRefereePresenter.swift
//  ALC_RB
//
//  Created by ayur on 26.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol DoMatchProtocolRefereeView: MvpView {

    func onSaveProtocolSuccess(match: Match)
    func onSaveProtocolFailure(error: Error)

    func onAcceptProtocolSuccess(message: SingleLineMessage)
    func onAcceptProtocolFailure(error: Error)

}

class DoMatchProtocolRefereePresenter: MvpPresenter<DoMatchProtocolRefereeViewController> {
    
    let dataManager = ApiRequests()
    
    func saveProtocol(token: String, editedProtocol: EditProtocol, ok: @escaping (Match) -> (), r_message: @escaping (SingleLineMessage) -> (), failure: @escaping (Error) -> ()) {
        dataManager.post_changeProtocol(token: token, newProtocol: editedProtocol) { result in
            switch result {
            case .success(let match):
                ok(match)
            case .message(let message):
                r_message(message)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
//    func acceptProtocol(token: String, matchId: String) {
//        dataManager.post_acceptProtocol(token: token, id: matchId, success: { message in
//            self.getView().onAcceptProtocolSuccess(message: message)
//        }) { error in
//            self.getView().onAcceptProtocolFailure(error: error)
//        }
//    }
    
    func acceptProtocol(token: String, matchId: String, ok: @escaping (Match) -> (), response_message: @escaping (SingleLineMessage) -> (), failure: @escaping (Error) -> ()) {
        dataManager.post_acceptProtocol(token: token, id: matchId) { result in
            switch result {
            case .success(let match):
                ok(match)
            case .message(let message):
                response_message(message)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
}
