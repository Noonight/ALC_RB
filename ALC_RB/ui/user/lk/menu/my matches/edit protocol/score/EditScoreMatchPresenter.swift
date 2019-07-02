//
//  ScoreMatchPresenter.swift
//  ALC_RB
//
//  Created by ayur on 14.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class EditScoreMatchPresenter: MvpPresenter<EditScoreMatchTableViewController> {
    
    func getClubs(id: String, getting: @escaping (Clubs) -> ()) {
        //debugPrint("presenter : getClubs called")
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
                
                //                if let club = response.result.value {
                //                    debugPrint("get club complete \(club.clubs.first?.logo)")
                //                    getting(club)
                //                }
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
    
}
