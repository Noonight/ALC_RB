//
//  PlayersLeagueDetailPresenter.swift
//  ALC_RB
//
//  Created by ayur on 30.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class PlayersLeagueDetailPresenter: MvpPresenter<PlayersLeagueDetailViewController> {
    
    func getUserPhotoByUploadImage(userImage image: String, get_image: @escaping (UIImage) -> ()) {
        Alamofire
            .request(ApiRoute.getImageURL(image: image))
            .validate()
            .responseImage { (response) in
                switch response.result {
                case .success:
                    if let img = response.result.value {
                        get_image(img)
                        debugPrint("get image here iss --_-----_----->>>>314159265359")
                    }
                case .failure:
//                    debugPrint("getting user image failure                        \(ApiRoute.getImageURL(image: image))")
                    debugPrint(ApiRoute.getImageURL(image: image))
                }
        }
    }
    
    func getUser(user id: String, get_user: @escaping (SoloPerson) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.soloUser, id: id))
            .validate()
            .responseSoloPerson { (response) in
                switch response.result {
                case .success:
                    if let user = response.result.value {
                        get_user(user)
                    }
                case .failure:
                    debugPrint("getting user failure")
                }
        }
    }
    
    func getUserPhotoName(user id: String, get_name: @escaping (String) -> (), get_photo: @escaping (UIImage) -> ()) {
        getUser(user: id) { (person) in
            get_name(person.person.getFullName())
            self.getUserPhotoByUploadImage(userImage: person.person.photo!, get_image: { (img) in
                get_photo(img)
            })
        }
    }
    
    func getClubImageByClubId(user id: String, get_club_image: @escaping (UIImage) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.clubs, id: id))
            .validate()
            .responseSoloClub { (response) in
                switch response.result {
                case .success:
                    if let club = response.result.value {
                        Alamofire
                            .request(ApiRoute.getImageURL(image: club.club.addLogo))
                            .responseImage(completionHandler: { (reseponseImage) in
                                if let img = reseponseImage.result.value {
                                    get_club_image(img)
                                }
                            })
                    }
                case .failure:
                    debugPrint("get club failure \(response.request?.url)")
        }
        }
    }
}
