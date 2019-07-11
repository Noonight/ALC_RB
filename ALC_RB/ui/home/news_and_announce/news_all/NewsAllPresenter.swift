//
//  NewsAllPresenter.swift
//  ALC_RB
//
//  Created by ayur on 11.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol NewsAllView: MvpView {
    func fetchNewsSuccessful(news: News)
    func fetchNewsFailure(error: Error)
}

class NewsAllPresenter: MvpPresenter<NewsAllTableViewController> {
    let dataManager = ApiRequests()
    
    func fetchNews(closure: @escaping () -> ()) {
        dataManager.get_news(success: { news in
            self.getView().fetchNewsSuccessful(news: news)
            Print.m(news)
            closure()
        }) { error in
            self.getView().fetchNewsFailure(error: error)
        }
    }
}
