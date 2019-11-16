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
    
    func getClubs(id: String, getting: @escaping ([Club]) -> ()) {
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
            if let mClub = clubs.first {
                if let logo = mClub.logo {
                    Alamofire
                        .request(ApiRoute.getImageURL(image: logo))
                        .responseImage(completionHandler: { response in
                            if let img = response.result.value {
                                debugPrint("get club image complete")
                                getting(img)
                            }
                        })
                }
            }
        }
    }
    
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
