// To parse the JSON, add this file to your project and do:
//
//   let authUser = try AuthUser(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAuthUser { response in
//     if let authUser = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct AuthUser: Codable {
    var person: Person
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case person = "person"
        case token = "token"
    }
}

struct AuthUserNot: Codable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}

// MARK: Convenience initializers and mutators

extension AuthUserNot {
    
    
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(AuthUserNot.self, from: data)
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
        message: String? = nil
        ) -> AuthUserNot {
        return AuthUserNot(
            message: message ?? self.message
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
    @discardableResult
    func responseAuthUserNot(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<AuthUserNot>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}


// MARK: Convenience initializers and mutators

extension AuthUser {
    
    init() {
        person = Person()
        token = " as "
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(AuthUser.self, from: data)
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
        person: Person? = nil,
        token: String? = nil
        ) -> AuthUser {
        return AuthUser(
            person: person ?? self.person,
            token: token ?? self.token
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: Encode/decode helpers

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
    func responseAuthUser(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<AuthUser>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
