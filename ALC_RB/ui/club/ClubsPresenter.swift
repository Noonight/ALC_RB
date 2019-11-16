//
//  File.swift
//  ALC_RB
//
//  Created by ayur on 13.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol ClubsTableView: MvpView {
    
    func onGetClubsSuccess(_ club: [Club])
    func onGetClubsFailure(_ error: Error)
    
}

class ClubsPresenter: MvpPresenter<ClubsTableViewController> {
    
    let dataManager = ApiRequests()
    let clubApi = ClubApi()
    
    func getClubs() {
        
        clubApi.get_club { result in
            switch result {
            case .success(let clubs):
                self.getView().onGetClubsSuccess(clubs)
            case .message(let msg):
                Print.m(msg.message)
            case .failure(.error(let error)):
                Print.m(error)
                self.getView().onGetClubsFailure(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
    func getImage(imageName: String, setImage: @escaping (UIImage) -> ()) {
        Alamofire
            .request(ApiRoute.getImageURL(image: imageName))
            .responseImage { response in
                if let img = response.result.value {
                    setImage(img)
                }
        }
    }
    
}
