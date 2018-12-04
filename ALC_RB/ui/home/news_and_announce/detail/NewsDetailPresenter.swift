//
//  NewsDetailPresenter.swift
//  ALC_RB
//
//  Created by user on 04.12.18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire

class NewsDetailPresenter: MvpPresenter<NewsDetailViewController> {
    
    func getImage(imageName: String) {
        Alamofire
            .request(ApiRoute.getImageURL(image: imageName))
            .responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    
                    if let data = response.data {
                        self.getView().onGetImageSuccess(UIImage(data: data)!)
                    }
                }
        }
    }
    
}
