//
//  MatchProtocolPresenter.swift
//  ALC_RB
//
//  Created by mac on 08.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol EditMatchProtocolView : MvpView {
    func requestEditProtocolSuccess(match: Match)
    func requestEditProtocolMessage(message: SingleLineMessage)
    func requestEditProtocolFailure(error: Error)
    
    func requestAcceptProtocolSuccess(message: SingleLineMessage)
    func requestAcceptProtocolFailure(error: Error)
}

class EditMatchProtocolPresenter: MvpPresenter<EditMatchProtocolViewController> {
    
    let dataManager = ApiRequests()
    
    func requestEditProtocol(token: String, editProtocol: EditProtocol) {

//        dataManager.post_changeProtocol(token: token, newProtocol: editProtocol) { result in
//            switch result {
//            case .success(let match):
//                self.getView().requestEditProtocolSuccess(match: match)
//            case .message(let message):
//                self.getView().requestEditProtocolMessage(message: message)
//            case .failure(let error):
//                self.getView().requestEditProtocolFailure(error: error)
//            }
//        }
    }
}
