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
    
    func requestResultMy<T: Decodable>
        (
        queue: DispatchQueue? = nil,
        resultMy: @escaping (ResultMy<T, Error>) -> ()
        ) -> Self
    {
        responseData(queue: queue) { response in
            let decoder = ISO8601Decoder.getDecoder()
            do {
                if let decoded = try? decoder.decode(T.self, from: response.data!) {
                    resultMy(.success(decoded))
                }
                if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!) {
                    resultMy(.message(message))
                }
            }
            if response.result.isFailure {
                resultMy(.failure(response.error!))
            }
        }
    }
    
}
