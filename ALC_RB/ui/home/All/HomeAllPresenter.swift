//
//  HomeAllPresenter.swift
//  ALC_RB
//
//  Created by ayur on 26.09.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class HomeAllPresenter {
    
    private let dataManager: ApiRequests!
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetchNews(success: @escaping (News) -> (), r_message: @escaping (SingleLineMessage) -> (), failureAll: @escaping (Error) -> (), failureServer: @escaping (Error) -> (), failureLocal: @escaping (Error) -> ()) {
        dataManager.get_news { result in
            switch result
            {
            case .success(let news):
                success(news)
            case .message(let message):
                r_message(message)
            case .failure(.alamofire(let error)):
                failureAll(error)
            case .failure(.server(let error)):
                failureServer(error)
            case .failure(.local(let error)):
                failureLocal(error)
            }
        }
    }
    
}
