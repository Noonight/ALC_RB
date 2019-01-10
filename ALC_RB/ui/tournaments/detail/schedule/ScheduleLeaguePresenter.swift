//
//  ScheduleLeaguePresenter.swift
//  ALC_RB
//
//  Created by ayur on 10.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol ScheduleLeagueView: MvpView {
    func onGetClubSuccess (club: Clubs)
}

class ScheduleLeaguePresenter: MvpPresenter<ScheduleTableViewController> {
    
//    func getClub (id: String) {
//
//        Alamofire
//            .request(ApiRoute.getApiURL(.clubs, id: id))
//            .responseClubs { (response) in
//                if let club = response.result.value {
//                    self.getView().onGetClubSuccess(club: club)
//                }
//        }
//
//    }
    
    func getClub(id: String, getting: @escaping (Clubs) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.clubs, id: id))
            .responseClubs { response in
                if let club = response.result.value {
                    debugPrint("get club complete \(club.clubs.first?.logo)")
                    getting(club)
                }
        }
    }
    
    func getClubImage(id club: String, getting: @escaping (UIImage) -> ()) {
        getClub(id: club) { (clubs) in
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
