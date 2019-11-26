//
//  ProtocolApi.swift
//  ALC_RB
//
//  Created by ayur on 17.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class ProtocolApi: ApiRequests {
    
    func post_acceptProtocol(token: String, id: String, resultMy: @escaping (ResultMy<Match, Error>) -> ()) {
        
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                
                multipartFormData.append(id.data(using: String.Encoding.utf8)!, withName: "_id")
                
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_accept_protocol),
                    method: .post,
                    headers: ["auth" : token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseData { response in
                        let decoder = ISO8601Decoder.getDecoder()
                        do {
                            if let match = try? decoder.decode(Match.self, from: response.data!) {
                                resultMy(.success(match))
                            }// else { try! decoder.decode(Match.self, from: response.data!) }
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
    
    //        func post_changeProtocol(token: String, newProtocol: EditProtocol, resultMy: @escaping (ResultMy<Match, Error>) -> ()) {
        //        let header: HTTPHeaders = [
        //            "Content-Type" : "application/json",
        //            "auth" : "\(token)"
        //        ]
        //
        //        let instance = Alamofire
        //            .request(ApiRoute.getApiURL(.post_edit_protcol), method: .post, parameters: newProtocol.toParams(), encoding: JSONEncoding.default, headers: header)
        //        instance
        //            .responseData(completionHandler: { response in
        //                let decoder = ISO8601Decoder.getDecoder()
        //                do {
        //                    if let match = try? decoder.decode(Match.self, from: response.data!) {
        //                        resultMy(.success(match))
        //                    }
        //                    if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!) {
        //                        resultMy(.message(message))
        //                    }
        //                }
        //                if response.result.isFailure {
        //                    resultMy(.failure(response.error!))
        //                }
        //            })
        //
        //
        //    }
        
        //    func post_changeProtocol(token: String, newProtocol: EditProtocol, success: @escaping (Match)->(), message: @escaping (SingleLineMessage) -> (), failure: @escaping (Error)->()) {
        //        let header: HTTPHeaders = [
        //            "Content-Type" : "application/json",
        //            "auth" : "\(token)"
        //        ]
        //
        //        let instance = Alamofire
        //            .request(ApiRoute.getApiURL(.post_edit_protcol), method: .post, parameters: newProtocol.toParams(), encoding: JSONEncoding.default, headers: header)
        //        instance
        //            .responseSoloMatch(completionHandler: { response in
        //                if response.response?.statusCode == 500
        //                {
        //                    instance
        //                        .responseSingleLineMessage(completionHandler: { response in
        //                            switch response.result {
        //                            case .success(let value):
        //                                message(value)
        //                            case .failure(let error):
        //                                failure(error)
        //                            }
        //                        })
        //                }
        //                else
        //                {
        //                    switch response.result {
        //                    case .success(let value):
        //                        success(value)
        //                    case .failure(let error):
        //                        failure(error)
        //                    }
        //                }
        //
        //        })
        //    }
        
        //    func post_acceptProtocol(token: String, id: String, success: @escaping (Match) -> (), message: @escaping (SingleLineMessage) -> (), failure: @escaping (Error) -> ()) {
        //
        //        Alamofire
        //            .upload(multipartFormData: { (multipartFormData) in
        //
        //                multipartFormData.append(id.data(using: String.Encoding.utf8)!, withName: "_id")
        //
        //            },
        //                    usingThreshold: UInt64(),
        //                    to: ApiRoute.getApiURL(.post_accept_protocol),
        //                    method: .post,
        //                    headers: ["auth" : token])
        //            { (result) in
        //                switch result {
        //                case .success(let upload, _, _):
        //
        //                    upload.responseJSON(completionHandler: { response in
        ////                        dump(response.result)
        //                    })
        //
        //                    upload.responseSoloMatch(completionHandler: { response in
        //                        switch response.result {
        //                        case .success(let value):
        //                            success(value)
        //                        case .failure(let error):
        //                            upload.responseSingleLineMessage(completionHandler: { response in
        //                                switch response.result {
        //                                case .success(let value):
        //                                    message(value)
        //                                case .failure(let error):
        //                                    failure(error)
        //                                }
        //                            })
        //                        }
        //                    })
        //
        //                case .failure(let error):
        //                    failure(error)
        //                }
        //        }
        //    }
        
    
    
}