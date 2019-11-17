//
//  NewsApi.swift
//  ALC_RB
//
//  Created by ayur on 17.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class NewsApi: ApiRequests {
    
    func get_news(id: String? = nil, tourneys: [String]? = nil, limit: Int? = nil, offset: Int? = nil, resultMy: @escaping (ResultMy<[News], RequestError>) -> ()) {
        let params = ParamBuilder<News.CodingKeys>()
            .add(key: .id, value: id)
            .add(key: .tourney, value: StrBuilder().add(tourneys))
            .limit(limit)
            .offset(offset)
            .get()
        
        get_news(params: params, resultMy: resultMy)
    }
    
    func get_news(params: [String : Any], resultMy: @escaping (ResultMy<[News], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.news), method: .get, parameters: params)
            .responseResultMy([News].self, resultMy: resultMy)
    }
}
