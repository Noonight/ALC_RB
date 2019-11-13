// To parse the JSON, add this file to your project and do:
//
//   let tournaments = try Tournaments(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseTournaments { response in
//     if let tournaments = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct Tournaments: Codable {
    var leagues: [League]
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case leagues = "leagues"
        case count = "count"
    }
}

// MARK: Convenience initializers and mutators

extension Tournaments {
    
    init() {
        leagues = []
        count = -1
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Tournaments.self, from: data)
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
        leagues: [League]? = nil,
        count: Int? = nil
        ) -> Tournaments {
        return Tournaments(
            leagues: leagues ?? self.leagues,
            count: count ?? self.count
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try JSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseTournaments(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Tournaments>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
