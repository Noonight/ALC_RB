//
//  RegionRequests.swift
//  ALC_RB
//
//  Created by mac on 08.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class RegionApi: ApiRequests {
    
    func get_region(id: String? = nil, name: String? = nil, limit: Int? = nil, offset: Int? = nil, resultMy: @escaping (ResultMy<[RegionMy], RequestError>) -> ()) {
        let params = ParamBuilder<RegionMy.CodingKeys>()
            .add(key: .id, value: id)
            .add(key: .name, value: name)
            .limit(limit)
            .offset(offset)
            .get()
        get_region(params: params, resultMy: resultMy)
    }
    
    func get_region(params: [String : Any], resultMy: @escaping (ResultMy<[RegionMy], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.region), method: .get, parameters: params, encoding: URLEncoding(destination: .queryString))
            .responseResultMy([RegionMy].self, resultMy: resultMy)
    }
    
}
