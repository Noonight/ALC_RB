//
//  NewsFewPresenter.swift
//  ALC_RB
//
//  Created by user on 29.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire

protocol NewsAnnounceView: MvpView {
    func onFetchNewsSuccess(news: News)
    func onFetchNewsFailure(error: Error)
    
    func onFetchAnnouncesSuccess(announces: Announce)
    func onFetchAnnouncesFailure(error: Error)
}

class NewsAnnouncePresenter: MvpPresenter<NewsAnnounceTableViewController> {
    
    func getFewNews(closure: @escaping () -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.news))
            .responseNews { response in
                switch response.result {
                case .success(let value):
                    self.getView().onFetchNewsSuccess(news: value)
                    closure()
                case .failure(let error):
                    self.getView().onFetchNewsFailure(error: error)
                }
        }
    }
    
    func getFewAnnounces(closure: @escaping () -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.announce))
            .responseAnnounce{ response in
                switch response.result {
                case .success(let value):
                    self.getView().onFetchAnnouncesSuccess(announces: value)
                    closure()
                case .failure(let error):
                    self.getView().onFetchAnnouncesFailure(error: error)
                }
        }
    }
}
