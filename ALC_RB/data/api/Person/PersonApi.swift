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
    
    func get_person(id: String? = nil, name: String? = nil, surname: String? = nil, lastname: String? = nil, region: RegionMy? = nil, limit: Int? = 20, offset: Int? = 0, populate: [String]? = nil, resultMy: @escaping (ResultMy<[Person], RequestError>) -> ()) {
        var parameters: Parameters = [:]
        if let mId = id {
            parameters["_id"] = mId
        }
        if let mName = name {
            parameters["name"] = mName
        }
        if let mSurname = surname {
            parameters["surname"] = mSurname
        }
        if let mLastname = lastname {
            parameters["lastname"] = mLastname
        }
        if let mRegion = region?.id {
            parameters["region"] = mRegion
        }
        if let mLimit = limit {
            parameters["_limit"] = mLimit
        }
        if let mOffset = offset {
            parameters["_offset"] = mOffset
        }
        if let mPopulate = populate {
            var query = ""
            for item in mPopulate {
                query += (item + " ")
            }
            parameters["_populate"] = query
        }
        //        parameters["_populate"] = "participationMatches"
        Alamofire
            .request(ApiRoute.getApiURL(.person), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            .responseResultMy([Person].self) { result in
                resultMy(result)
        }
    }
    
    func get_person(params: [String: Any], resultMy: @escaping (ResultMy<[Person], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.person), method: .get, parameters: params)
            .responseResultMy([Person].self, resultMy: resultMy)
    }

    func get_personQuery(id: String? = nil, name: String? = nil, surname: String? = nil, lastname: String? = nil, region: RegionMy? = nil, limit: Int? = 20, offset: Int? = 0, populate: [String]? = nil, resultMy: @escaping (ResultMy<[Person], RequestError>) -> ()) {
        var parameters: Parameters = [:]
        if let mId = id {
            parameters["_id"] = mId
        }
        if let mName = name {
            parameters["name"] = mName
        }
        if let mSurname = surname {
            parameters["surname"] = mSurname
        }
        if let mLastname = lastname {
            parameters["lastname"] = mLastname
        }
        if let mRegion = region?.id {
            parameters["region"] = mRegion
        }
        if let mLimit = limit {
            parameters["_limit"] = mLimit
        }
        if let mOffset = offset {
            parameters["_offset"] = mOffset
        }
        if let mPopulate = populate {
            var query = ""
            for item in mPopulate {
                query += (item + " ")
            }
            parameters["_populate"] = query
        }
        
        Alamofire
            .request(ApiRoute.getApiURL(.personQuery), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            .responseResultMy([Person].self) { result in
                resultMy(result)
        }
    }

    func get_personQuery(params: [String: Any], resultMy: @escaping (ResultMy<[Person], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.personQuery), method: .get, parameters: params)
            .responseResultMy([Person].self, resultMy: resultMy)
    }
}
