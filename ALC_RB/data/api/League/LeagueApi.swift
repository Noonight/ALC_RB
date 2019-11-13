//
//  LeagueApi.swift
//  ALC_RB
//
//  Created by mac on 13.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class LeagueApi: ApiRequests {
    
    func get_league(id: String? = nil, name: String? = nil, status: League.Status? = nil, for tourneys: [String]? = nil, limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[League], RequestError>) -> ()) {
        let params = ParamBuilder<League.CodingKeys>()
                    .add(key: .id, value: id)
                    .add(key: .name, value: name)
                    .add(key: .status, value: status?.ck)
//                    .add(key: .tourney, value: StrBuilder<League.CodingKeys>().add(.comma).add(tourneys.map({ "\($0)," })))
                    .add(key: .tourney, value: StrBuilder().add(.comma).add(tourneys))
//                    .populate(StrBuilder().add([.ageAllowedMax, .beginDate, .creator]))
                    .limit(limit)
                    .offset(offset)
                    .get()
        
        Alamofire
            .request(ApiRoute.getApiURL(.league), method: .get, parameters: params)
            .responseResultMy([League].self, resultMy: resultMy)
    }
    
    func get_league(params: [String : Any], resultMy: @escaping (ResultMy<[League], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.league), method: .get, parameters: params)
            .responseResultMy([League].self, resultMy: resultMy)
    }
}
