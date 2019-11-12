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
    
    func get_upcomingMatches(resultMy: @escaping (ResultMy<[Match], RequestError>) -> ()) {
        
        let params =
            ParamBuilder()
            .limit(100)
            .offset()
//            .populate(
//                StringBuilder(mode: .result)
//                    .add(Match.CodingKeys.stage)
//                    .getStr()
//            )
            .select(
                StringBuilder(mode: .realtime)
                .add(Match.CodingKeys.league)
            )
            .populate(
                StringBuilder(mode: .realtime)
                .add(Match.CodingKeys.league)
            )
            .get()
        Alamofire
            .request(ApiRoute.getApiURL(.match), method: .get, parameters: params)
            .responseResultMy([Match].self, resultMy: resultMy)
        
    }
    
}
