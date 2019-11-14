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
    
    func get_upcomingMatches(limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[Match], RequestError>) -> ()) {
        
        // get active leagues
        // get matches moreOrEqualThan current date
        let leagueApi = LeagueApi()
        
        let group = DispatchGroup()
        
        var mMessage: SingleLineMessage?
        var mError: Error?
        var notExpectedData: Bool = false
        var upcomingMatches = [Match]()
        
        group.enter()
        
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
                
                group.enter()
                
                let params =
                    ParamBuilder<Match.CodingKeys>()
                        .add(key: .played, value: false)
                        .add(key: .league, value: StrBuilder().add(leagues.map({ $0.id })))
                        .limit(limit)
                        .offset(offset)
                        .get()
                Alamofire
                    .request(ApiRoute.getApiURL(.match), method: .get, parameters: params)
                    .responseResultMy([Match].self, resultMy: { result in
                        switch result {
                        case .success(let matches):
                            upcomingMatches = matches
                        case .message(let message):
                            Print.m(message.message)
                            mMessage = message
                        case .failure(.error(let error)):
                            Print.m(error)
                            mError = error
                        case .failure(.notExpectedData):
                            Print.m("not expected data")
                            notExpectedData = true
                        }
                        group.leave()
                    })
                
            case .message(let message):
                Print.m(message.message)
                mMessage = message
            case .failure(.error(let error)):
                Print.m(error)
                mError = error
            case .failure(.notExpectedData):
                Print.m("not expected data")
                notExpectedData = true
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = mError {
                resultMy(.failure(.error(error)))
            }
            if let message = mMessage {
                resultMy(.message(message))
            }
            if notExpectedData == true {
                resultMy(.failure(.notExpectedData))
            }
            resultMy(.success(upcomingMatches))
        }
    }
    
    func get_match(id: String? = nil, limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[Match], RequestError>) -> ()) {
        let params = ParamBuilder<Match.CodingKeys>()
                        .add(key: .id, value: id)
                        .limit(limit)
                        .offset(offset)
                        .get()
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
