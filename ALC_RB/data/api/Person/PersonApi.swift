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
    
    func post_authorization(userData: SignIn, resultMy: @escaping (ResultMy<AuthUser, Error>) -> ()) {
        let params: [String: Any] = [
            SignIn.Fields.login.rawValue: userData.login,
            SignIn.Fields.password.rawValue: userData.password
        ]
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_auth),
                    method: .post)
            { (result) in
                //                dump(result)
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseData { response in
                        let decoder = ISO8601Decoder.getDecoder()
                        do {
                            if let authUser = try? decoder.decode(AuthUser.self, from: response.data!) {
                                resultMy(.success(authUser))
                            }
                            if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!) {
                                resultMy(.message(message))
                            }
                        }
                        if response.result.isFailure {
                            resultMy(.failure(response.error!))
                        }
                    }
                    
                case .failure(let error):
                    resultMy(.failure(error))
                }
        }
    }
    
    func post_authorization(userData: SignIn, get_auth_user: @escaping (AuthUser) -> (), get_error: @escaping (Error) -> (), get_message: @escaping (SingleLineMessage) -> ()) {
        let params: [String: Any] = [
            SignIn.Fields.login.rawValue: userData.login,
            SignIn.Fields.password.rawValue: userData.password
        ]
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_auth),
                    method: .post)
            { (result) in
                //                dump(result)
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseAuthUser { (response) in
                        //                        dump(response)
                        switch response.result {
                        case .success:
                            if let authUser = response.result.value {
                                get_auth_user(authUser)
                            }
                        case .failure(let error):
                            upload.responseSingleLineMessage(completionHandler: { response in
                                switch response.result {
                                case .success(let value):
                                    get_message(value)
                                case .failure(let error):
                                    get_error(error)
                                }
                            })
                            
                        }
                    }
                    
                case .failure(let error):
                    get_error(error)
                }
        }
    }
    
    func post_registration(userData: Registration, profileImage: UIImage?, response_success: @escaping (AuthUser) -> (), response_failure: @escaping (Error) -> (), response_message: @escaping (SingleLineMessage) -> ()) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                if let image = profileImage {
                    multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: "photo", fileName: "jpg", mimeType: "image/jpg")
                }
                for (key, value) in userData.toParams() {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_reg),
                    method: .post)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseAuthUser(completionHandler: { (response) in
                        switch response.result {
                        case .success:
                            if let newUser = response.result.value {
                                response_success(newUser)
                            }
                        case .failure(let error):
                            //                            response_failure(error)
                            upload.responseSingleLineMessage(completionHandler: { response in
                                switch response.result {
                                case .success(let value):
                                    response_message(value)
                                case .failure(let error):
                                    response_failure(error)
                                }
                            })
                        }
                    })
                    
                case .failure(let error):
                    response_failure(error)
                }
        }
    }
    
    func post_registration(userData: Registration, profileImage: UIImage?, resultMy: @escaping (ResultMy<AuthUser, Error>) -> ()) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                if let image = profileImage {
                    multipartFormData.append(image.jpegData(compressionQuality: 100.0)!, withName: "photo", fileName: "jpg", mimeType: "image/jpg")
                }
                for (key, value) in userData.toParams() {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_reg),
                    method: .post)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseString { response in
                        Print.m(response)
                        let decoder = ISO8601Decoder.getDecoder()
                        do {
                            if let authUser = try? decoder.decode(AuthUser.self, from: response.data!) {
                                resultMy(.success(authUser))
                            }
                            if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!) {
                                resultMy(.message(message))
                            }
                        }
                        if response.result.isFailure {
                            resultMy(.failure(response.error!))
                        }
                    }
                    
                case .failure(let error):
                    resultMy(.failure(error))
                }
        }
    }
    
    func post_edit_profile(token: String, profileInfo: EditProfile, profileImage: UIImage?, resultMy: @escaping (ResultMy<SinglePerson, Error>) -> ()) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                if let image = profileImage {
                    multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: "photo", fileName: "jpg", mimeType: "image/jpg")
                }
                
                for (key, value) in profileInfo.toParams() {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_edit_profile),
                    method: .post,
                    headers: ["auth" : token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseData { response in
                        let decoder = ISO8601Decoder.getDecoder()
                        do {
                            if let soloPerson = try? decoder.decode(SinglePerson.self, from: response.data!) {
                                resultMy(.success(soloPerson))
                            }
                            if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!) {
                                resultMy(.message(message))
                            }
                        }
                        if response.result.isFailure {
                            resultMy(.failure(response.error!))
                        }
                    }
                    
                case .failure(let error):
                    resultMy(.failure(error))
                }
        }
    }
    
    func get_refreshAuthUser(token: String, success: @escaping (AuthUser) -> (), failure: @escaping (Error) -> ()) {
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "auth" : "\(token)"
        ]
        Alamofire
            .request(ApiRoute.getApiURL(.refreshUser), method: .get, encoding: JSONEncoding.default, headers: header)
            .responseAuthUser { response in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failure(error)
                }
        }
    }
}
