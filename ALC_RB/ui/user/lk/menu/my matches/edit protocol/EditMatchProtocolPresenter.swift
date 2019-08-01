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
    func requestEditProtocolSuccess(match: SoloMatch)
    func requestEditProtocolFailure(error: Error)
    
    func requestAcceptProtocolSuccess(message: SingleLineMessage)
    func requestAcceptProtocolFailure(error: Error)
}

class EditMatchProtocolPresenter: MvpPresenter<EditMatchProtocolViewController> {
    
    let dataManager = ApiRequests()
    
    func getClubs(id: String, getting: @escaping (Clubs) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.clubs))
            .validate()
            .responseClubs { response in
                switch response.result {
                case .success:
                    if let clubs = response.result.value {
                        getting(clubs)
                    }
                case .failure:
                    debugPrint("failure getting clubs with id : \(id) \n message is \(String(describing: response.result.value))")
                }
        }
    }
    
    func getClubImage(id club: String, getting: @escaping (UIImage) -> ()) {
        getClubs(id: club) { (clubs) in
            Alamofire
                .request(ApiRoute.getImageURL(image: (clubs.clubs.first?.logo)!))
                .responseImage(completionHandler: { response in
                    if let img = response.result.value {
                        debugPrint("get club image complete")
                        getting(img)
                    }
                })
        }
    }
    
    func requestEditProtocol(token: String, editProtocol: EditProtocol) {
        dataManager.post_changeProtocol(token: token, newProtocol: editProtocol, success: { soloMatch in
            self.getView().requestEditProtocolSuccess(match: soloMatch)
        }) { error in
            self.getView().requestEditProtocolFailure(error: error)
        }
    }
    
    func requestAcceptProtocol(token: String, matchId: String) {
//        dataManager.post_acceptProtocol(token: token, id: matchId, success: { message in
//            self.getView().requestAcceptProtocolSuccess(message: message)
//        }) { error in
//            self.getView().requestAcceptProtocolFailure(error: error)
//        }
        dataManager.post_acceptProtocol(token: token, id: matchId, success: { match in
            
        }, message: { message in
            
        }) { error in
            
        }
    }
}
