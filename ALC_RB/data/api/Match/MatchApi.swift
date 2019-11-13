//
//  MatchApi.swift
//  ALC_RB
//
//  Created by mac on 12.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class MatchApi: ApiRequests {
    
    func get_upcomingMatches(limit: Int = Constants.Values.LIMIT, offset: Int = 0, resultMy: @escaping (ResultMy<[Match], RequestError>) -> ()) {
        
        // get active leagues
        // get matches moreOrEqualThan current date
        let leagueApi = LeagueApi()
        
        let group = DispatchGroup()
        
        var tmpLeagues = [League]()
        
        leagueApi.get_league(
            params: ParamBuilder<League.CodingKeys>()
                .select(
                    StrBuilder()
                        .add(.id)
                )
                .add(key: .status, value: League.Status.started.ck)
                .get()
        ) { result in
            switch result {
            case .success(let leagues):
                
                let params =
                    ParamBuilder<Match.CodingKeys>()
                
                Alamofire
                    .request(ApiRoute.getApiURL(.match), method: .get, parameters: params)
                
            case .message(let message):
                Print.m(message.message)
                
            case .failure(.error(let error)):
                Print.m(error)
                
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
    func get_match(id: String? = nil, limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[Match], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.match), method: .get, parameters: params)
            .responseResultMy([Match].self, resultMy: resultMy)
    }
    
    func get_match(params: [String : Any], limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[Match], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.match), method: .get, parameters: params)
            .responseResultMy([Match].self, resultMy: resultMy)
    }
    
}
