//
//  UpcomingGameCellPresenter.swift
//  ALC_RB
//
//  Created by ayur on 07.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire

class UpcomingGameCellPresenter: MvpPresenter<UpcomingGameTableViewCell> {
    
    func getClub1Logo(club: String) {
        let club = findClub(clubId: club)
        Alamofire
            .request(ApiRoute.getImageURL(image: club.logo))
            .response { response in
                if let data = response.data {
                    self.getView().onGetClub1LogoSuccess(image: UIImage(data: data)!)
                }
        }
    }
    
    func getClub2Logo(club: String) {
        let club = findClub(clubId: club)
        Alamofire
            .request(ApiRoute.getImageURL(image: club.logo))
            .response { response in
                if let data = response.data {
                    self.getView().onGetClub2LogoSuccess(image: UIImage(data: data)!)
                }
        }
    }
    
    func findClub(clubId: String) -> Club {
        var club: Club?
        Alamofire
            .request(ApiRoute.getApiURL(.clubs))
            .responseClubs { response in
                if let clubs = response.result.value {
                    
                    for i in clubs.clubs {
                        if (i.id == clubId) {
                            club = i
                        }
                    }
                    
                }
        }
        print("DEBUG: club - \(club)")
        return club!
    }
    
}
