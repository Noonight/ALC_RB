// To parse the JSON, add this file to your project and do:
//
//   let clubs = try [Club](json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseClubs { response in
//     if let clubs = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct Club: Codable {
    var info, addLogo, addInfo, id: String?
    var name: String?
    var owner: Owner?
    var v: Int?
    var logo: String?

    
    init(info: String, addLogo: String, addInfo:String, id: String, name: String, owner: Owner, v: Int, logo: String) {
        self.info = info
        self.addLogo = addLogo
        self.addInfo = addInfo
        self.id = id
        self.name = name
        self.owner = owner
        self.v = v
        self.logo = logo
    }
    
    enum CodingKeys: String, CodingKey {
        case info, addLogo, addInfo
        case id = "_id"
        case name, owner
        case v = "__v"
        case logo
    }
}

// MARK: Convenience initializers and mutators

extension Club {
    
    init() {
        info = ""
        addLogo = ""
        addInfo = ""
        id = ""
        name = ""
        owner = Owner()
        v = -1
        logo = ""
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Club.self, from: data)
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
        info: String? = nil,
        addLogo: String? = nil,
        addInfo: String? = nil,
        id: String? = nil,
        name: String? = nil,
        owner: Owner? = nil,
        v: Int? = nil,
        logo: String? = nil
        ) -> Club {
        var club = Club()
        club.info = info ?? self.info
        club.addLogo = addLogo ?? self.addLogo
        club.addInfo = addInfo ?? self.addInfo
        club.id = id ?? self.id
        club.name = name ?? self.name
        club.owner = owner ?? self.owner
        club.v = v ?? self.v
        club.logo = logo ?? self.logo
        return club
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
    func responseClubs(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<[Club]>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
