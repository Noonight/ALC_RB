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
import Kingfisher

class PlayersLeagueDetailPresenter: MvpPresenter<PlayersLeagueDetailViewController> {
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
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
//        Alamofire
//            .request(ApiRoute.getApiURL(.soloUser, id: id))
//            .validate()
//            .responseSoloPerson { (response) in
//                switch response.result {
//                case .success:
//                    if let user = response.result.value {
//                        get_user(user)
//                    }
//                case .failure:
//                    debugPrint("getting user failure")
//                }
//        }
        // TODO: make person request
        
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
                case .success(let value):
                    
                    if let urlPhoto = value.club.logo {
                        let url = ApiRoute.getImageURL(image: urlPhoto)
                        let downloader = KingfisherManager.shared
                        let cellImageSize = CGSize(width: 22, height: 22)
                        let processor = DownsamplingImageProcessor(size: cellImageSize)
                            .append(another: CroppingImageProcessorCustom(size: cellImageSize))
                            .append(another: RoundCornerImageProcessor(cornerRadius: cellImageSize.getHalfWidthHeight()))
                        downloader.downloader.downloadImage(
                            with: url,
                            options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1)),
                                .cacheOriginalImage
                        ]) {
                            result in
                            switch result {
                            case .success(let value):
                                
                                get_club_image(value.image)
                                
                            case .failure(let error):
                                get_club_image(#imageLiteral(resourceName: "ic_logo"))
                            }
                        }
                    }
                    else
                    {
                        get_club_image(#imageLiteral(resourceName: "ic_logo"))
                    }
                    
//                    if let club = response.result.value {
//                        Alamofire
//                            .request(ApiRoute.getImageURL(image: club.club.addLogo ?? ""))
//                            .responseImage(completionHandler: { (reseponseImage) in
//                                if let img = reseponseImage.result.value {
//                                    get_club_image(img)
//                                }
//                            })
//                    }
                case .failure:
                    debugPrint("get club failure \(String(describing: response.request?.url))")
        }
        }
    }
}
