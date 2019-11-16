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

class MatchProtocolPresenter: MvpPresenter<MatchProtocolViewController> {
    
//    func getClubs(id: String, getting: @escaping ([Club]) -> ()) {
//        Alamofire
//            .request(ApiRoute.getApiURL(.clubs))
//            .validate()
//            .responseClubs { response in
//                switch response.result {
//                case .success:
//                    if let clubs = response.result.value {
//                        getting(clubs)
//                    }
//                case .failure:
//                    debugPrint("failure getting clubs with id : \(id) \n message is \(String(describing: response.result.value))")
//                }
//        }
//    }
//
//    func getClubImage(id club: String, getting: @escaping (UIImage) -> ()) {
//        getClubs(id: club) { (clubs) in
//            guard let clubFirstLogo = clubs.first?.logo else { return }
//            Alamofire
//                .request(ApiRoute.getImageURL(image: clubFirstLogo))
//                .responseImage(completionHandler: { response in
//                    if let img = response.result.value {
//                        debugPrint("get club image complete")
//                        getting(img)
//                    }
//                })
//        }
//    }
}
