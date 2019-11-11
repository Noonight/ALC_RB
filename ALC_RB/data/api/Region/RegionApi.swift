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
    
    override func get_regions(query: String? = nil, get_result: @escaping (ResultMy<[RegionMy], Error>) -> ()) {
        
        var parameters: Parameters = [:]
        
        if query != nil {
            parameters = [
                "name" : query!
            ]
        }
        Print.m(parameters)
        
        let alamofireInstance = Alamofire.request(ApiRoute.getApiURL(.region), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
        alamofireInstance
            .responseJSON { response in
                let decoder = JSONDecoder()
                
                do
                {
                    if let myRegions = try? decoder.decode([RegionMy].self, from: response.data!)
                    {
                        get_result(.success(myRegions))
                    }
                    if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!)
                    {
                        get_result(.message(message))
                    }
                }
                
                if response.result.isFailure {
                    get_result(.failure(response.result.error!))
                }
        }
    }
    
}
