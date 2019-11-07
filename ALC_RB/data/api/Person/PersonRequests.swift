//
//  PersonRequests.swift
//  ALC_RB
//
//  Created by mac on 07.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class PersonApi : ApiRequests {
    
    func get_person
        (
        name: String? = nil,
        surname: String? = nil,
        lastname: String? = nil,
        limit: Int? = Constants.Values.LIMIT,
        offset: Int? = 0,
        resultMy: @escaping (ResultMy<[Person], Error>) -> ()
        )
    {
        var parameters: Parameters = [:]
        if let mName = name {
            parameters["name"] = mName
        }
        if let mSurname = surname {
            parameters["surname"] = mSurname
        }
        if let mLastname = lastname {
            parameters["lastname"] = mLastname
        }
        if let mLimit = limit {
            parameters["limit"] = mLimit
        }
        if let mOffset = offset {
            parameters["offset"] = mOffset
        }
        Alamofire
            .request(ApiRoute.getApiURL(.person), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
//            .responseData(completionHandler: { response in
//                let decoder = ISO8601Decoder.getDecoder()
//                do {
//                    if let persons = try? decoder.decode([Person].self, from: response.data!) {
//
//                    }
//                    if let message = try? decoder.decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
//                }
//                if response.result.isFailure {
//                    resultMy(.failure(response.error!))
//                }
//            })
        
        }
    }
    
    func get_personQuery
        (
        name: String? = nil,
        surname: String? = nil,
        lastname: String? = nil,
        limit: Int? = Constants.Values.LIMIT,
        offset: Int? = 0
        )
    {
        var parameters: Parameters = [:]
        if let mName = name {
            parameters["name"] = mName
        }
        if let mSurname = surname {
            parameters["surname"] = mSurname
        }
        if let mLastname = lastname {
            parameters["lastname"] = mLastname
        }
        if let mLimit = limit {
            parameters["limit"] = mLimit
        }
        if let mOffset = offset {
            parameters["offset"] = mOffset
        }
        
    }
    
}
