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
    
    func onGetClubsSuccess(_ club: Clubs)
    func onGetClubsFailure(_ error: Error)
    
}

class ClubsPresenter: MvpPresenter<ClubsTableViewController> {
    
    let dataManager = ApiRequests()
    
    func getClubs() {
        
        dataManager.get_clubs(get_success: { clubs in
            self.getView().onGetClubsSuccess(clubs)
        }) { error in
            self.getView().onGetClubsFailure(error)
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
