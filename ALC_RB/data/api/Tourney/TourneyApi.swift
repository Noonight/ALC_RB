//
//  TourneyApi.swift
//  ALC_RB
//
//  Created by ayur on 16.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class TourneyApi: ApiRequests {
    
    func get_tourney(id: String? = nil, name: String? = nil, limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[Tourney], RequestError>) -> ()) {
        
        let params = ParamBuilder<Tourney.CodingKeys>()
            .add(key: .id, value: id)
            .add(key: .name, value: name)
            .limit(limit)
            .offset(offset)
            .get()
        Alamofire
            .request(ApiRoute.getApiURL(.tourney), method: .get, parameters: params)
            .responseResultMy([Tourney].self, resultMy: resultMy)
        
    }
    
    func get_tourney(params: [String : Any], resultMy: @escaping (ResultMy<[Tourney], RequestError>) -> ()) {
        
        Alamofire
            .request(ApiRoute.getApiURL(.tourney), method: .get, parameters: params)
            .responseResultMy([Tourney].self, resultMy: resultMy)
        
    }
    
}
