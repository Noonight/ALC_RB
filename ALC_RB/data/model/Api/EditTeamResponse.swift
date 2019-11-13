//
//  EditTeamResponse.swift
//  ALC_RB
//
//  Created by ayur on 11.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

struct EditTeamResponse: Codable {
    var players: [Player]
    
    enum CodingKeys: String, CodingKey {
        case players = "players"
    }
}

extension EditTeamResponse {
    
    init() {
        players = []
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(EditTeamResponse.self, from: data)
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
        players: [Player]? = nil
        ) -> EditTeamResponse {
        return EditTeamResponse(
            players: players ?? self.players
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
    func responseEditTeamResponse(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<EditTeamResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
