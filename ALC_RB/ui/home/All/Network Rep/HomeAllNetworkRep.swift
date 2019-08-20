//
//  HomeAllNetworkRep.swift
//  ALC_RB
//
//  Created by mac on 20.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class HomeAllNetworkRep {
    
    let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetchNews(success: @escaping (News) -> (), failure: @escaping (Error) -> ()) {
        self.dataManager.get_news(success: { news  in
            success(news)
        }) { error  in
            failure(error)
        }
    }
    
    func fetchAnnounces(success: @escaping (Announce) -> (), failure: @escaping (Error) -> ()) {
        self.dataManager.get_announces(success: { announces  in
            success(announces)
        }) { error  in
            failure(error)
        }
    }
    
}
