//
//  NewsFewPresenter.swift
//  ALC_RB
//
//  Created by user on 29.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire

class NewsFewPresenter: MvpPresenter<NewsTableViewController> {
    
    func getFewNews() {        
        Alamofire
            .request(ApiRoute.getApiURL(.news))
            .responseNews { response in
            if let news = response.result.value {
                self.getView().onGetNewsDataSuccess(news: news)
                //try! print(news.jsonString()!)
            }
        }
        //Alamofire.req
        
    }
    
    func getFewAnnounces() {
        Alamofire
            .request(ApiRoute.getApiURL(.announce))
            .responseAnnounce{ response in
                if let announce = response.result.value {
                    self.getView().onGetAnnounceDataSuccess(announces: announce)
                    //try! print(announce.jsonString()!)
                }
        //print("presenter: getFewAnnounces")
        //return announ
        }
    
    }

}
