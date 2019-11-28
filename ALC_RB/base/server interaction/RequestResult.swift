//
//  RequestResult.swift
//  ALC_RB
//
//  Created by mac on 07.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
    
    func responseResultMy<T: Decodable>(_ type: T.Type, queue: DispatchQueue? = nil, resultMy: @escaping (ResultMy<T, RequestError>) -> ()) {
        responseData(queue: queue) { response in
//                        dump(response) // dont forgot to make tests: do responseJSON request
            let decoder = ISO8601Decoder.getDecoder()
            do {
                //                if let id = try? dei
                if let decoded = try? decoder.decode(T.self, from: response.data!) {
                    resultMy(.success(decoded))
                } else if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!) {
                    resultMy(.message(message))
                } else {
                    // TEST: here test decode
//                    try! decoder.decode(T.self, from: response.data!)
                    resultMy(.failure(.notExpectedData))
                    //                    try! decoder.decode(T.self, from: response.data!)
                }
            }
            if response.result.isFailure {
                resultMy(.failure(.error(response.error!)))
            }
        }
    }
}
