//
//  NewsDetailPresenter.swift
//  ALC_RB
//
//  Created by user on 04.12.18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class NewsDetailPresenter: MvpPresenter<NewsDetailViewController> {
    
//    func getImage(imageName: String) {
//        Alamofire
//            .request(ApiRoute.getImageURL(image: imageName))
//            .responseData { (response) in
//                if response.error == nil {
//                    //print(response.result)
//
//                    if let data = response.data {
//                        self.getView().onGetImageSuccess(UIImage(data: data)!)
//                    }
//                }
//        }
//    }
    func getImage(imageName: String) {
        Alamofire
            .request(ApiRoute.getImageURL(image: imageName))
            .responseImage { response in
                if let img = response.result.value {
                    self.getView().onGetImageSuccess(img)
                }
//            .responseData { (response) in
//                if response.error == nil {
//                    //print(response.result)
//
//                    if let data = response.data {
//                        self.getView().onGetImageSuccess(UIImage(data: data)!)
//                    }
//                }
        }
    }
    
    func getImage(imageName: String, setImage: @escaping (UIImage) -> ()) {
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
