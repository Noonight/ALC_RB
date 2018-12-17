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

protocol ClubsTableView {
    //func showLoading()
    //func hideLoading()
    
    func onGetClubsSuccess(_ club: Clubs)
    func onGetImageSuccess(_ img: UIImage)
}

class ClubsPresenter: MvpPresenter<ClubsTableViewController> {
    
    func getClubs() {
        
        //self.getView().showLoading()
        
        Alamofire
            .request(ApiRoute.getApiURL(.clubs))
            //.stream()
            .responseClubs { response in
                if let clubs = response.result.value {
                    self.getView().onGetClubsSuccess(clubs)
                    //self.getView().hideLoading()
                }
        }
    }
    
    func getImage(imageName: String, setImage: @escaping (UIImage) -> ()) {
//        Alamofire
//            .request(ApiRoute.getImageURL(image: imageName))
//            .responseData { (response) in
//                if response.error == nil {
//                    if let data = response.data {
//                        print(data)
//                        setImage(UIImage(data: data)!)
//                        //self.getView().onGetImageSuccess(UIImage(data: data)!)
//                    }
//                } else {
//
//                }
//        }
        //self.getView().showLoading()
        Alamofire
            .request(ApiRoute.getImageURL(image: imageName))
            .responseImage { response in
                //debugPrint(response)
                
                if let img = response.result.value {
                    setImage(img)
                    //self.getView().hideLoading()
                }
        }
    }
    
}
