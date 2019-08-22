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
    
    func fetchUpcomingMatches(
        success: @escaping (MmUpcomingMatches) -> (),
        message: @escaping (SingleLineMessage) -> (),
        local_error: @escaping (Error ) -> (),
        server_error: @escaping (Error ) -> (),
        universal_error: @escaping (Error) -> ()
        )
    {
        self.dataManager.get_upcomingMatches { result  in
            switch result
            {
            case .success(let value):
                success(value)
            case .message(let value):
                message(value)
            case .failure(.alamofire(let error)):
                universal_error(error )
            case .failure(.local(let error)):
                local_error(error)
            case .failure(.server(let error)):
                server_error(error)
            }
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
