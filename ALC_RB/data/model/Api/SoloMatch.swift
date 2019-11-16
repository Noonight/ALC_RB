//
//  SoloMatch.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 30/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

struct SoloMatch: Codable {
    let match: Match?
    
    enum CodingKeys: String, CodingKey {
        case match = "match"
    }
}

extension SoloMatch {
    init(data: Data) throws {
        self = try JSONDecoder().decode(SoloMatch.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        match: Match?? = nil
        ) -> SoloMatch {
        return SoloMatch(
            match: match ?? self.match
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try ISO8601Decoder.getDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseSoloMatch(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<SoloMatch>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
