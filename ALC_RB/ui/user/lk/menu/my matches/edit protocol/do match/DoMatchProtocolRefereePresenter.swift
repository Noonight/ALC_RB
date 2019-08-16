//
//  DoMatchProtocolRefereePresenter.swift
//  ALC_RB
//
//  Created by ayur on 26.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol DoMatchProtocolRefereeView: MvpView {

    func onSaveProtocolSuccess(match: SoloMatch)
    func onSaveProtocolFailure(error: Error)

    func onAcceptProtocolSuccess(message: SingleLineMessage)
    func onAcceptProtocolFailure(error: Error)

}

class DoMatchProtocolRefereePresenter: MvpPresenter<DoMatchProtocolRefereeViewController> {
    
    let dataManager = ApiRequests()

    func saveProtocol(token: String, editedProtocol: EditProtocol) {
        dataManager.post_changeProtocol(token: token, newProtocol: editedProtocol, success: { match in
            self.getView().onSaveProtocolSuccess(match: match)
        }, message: { message in
            
        }) { error in
            self.getView().onSaveProtocolFailure(error: error)
        }
    }
    
    func saveProtocol(token: String, editedProtocol: EditProtocol, ok: @escaping (SoloMatch) -> (), r_message: @escaping (SingleLineMessage) -> (), failure: @escaping (Error) -> ()) {
        dataManager.post_changeProtocol(token: token, newProtocol: editedProtocol, success: { match in
            ok(match)
        }, message: { message in
            r_message(message)
        }) { error in
            failure(error)
        }
    }
    
//    func acceptProtocol(token: String, matchId: String) {
//        dataManager.post_acceptProtocol(token: token, id: matchId, success: { message in
//            self.getView().onAcceptProtocolSuccess(message: message)
//        }) { error in
//            self.getView().onAcceptProtocolFailure(error: error)
//        }
//    }
    
    func acceptProtocol(token: String, matchId: String, ok: @escaping (SoloMatch) -> (), response_message: @escaping (SingleLineMessage) -> (), failure: @escaping (Error) -> ()) {
//        dataManager.post_acceptProtocol(token: token, id: matchId, success: { message in
//            ok(message)
//        }) { error in
//            failure(error)
//        }
        dataManager.post_acceptProtocol(token: token, id: matchId, success: { match in
            ok(match)
        }, message: { message in
            response_message(message)
        }) { error in
            failure(error)
        }
    }
    
}
