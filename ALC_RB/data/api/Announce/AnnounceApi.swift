//
//  AnnounceApi.swift
//  ALC_RB
//
//  Created by ayur on 17.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class AnnounceApi: ApiRequests {
    
    func get_announce(id: String? = nil, tourneys: [String]? = nil, limit: Int? = nil, offset: Int? = nil, resultMy: @escaping (ResultMy<[Announce], RequestError>) -> ()) {
        let params = ParamBuilder<Announce.CodingKeys>()
            .add(key: .id, value: id)
            .add(key: .tourney, value: StrBuilder().add(tourneys))
            .limit(limit)
            .offset(offset)
            .get()
        
        get_announce(params: params, resultMy: resultMy)
    }
    
    func get_announce(params: [String : Any], resultMy: @escaping (ResultMy<[Announce], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.announce), method: .get, parameters: params)
            .responseResultMy([Announce].self, resultMy: resultMy)
    }
    
}
