// To parse the JSON, add this file to your project and do:
//
//   let soloPerson = try SoloPerson(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseSoloPerson { response in
//     if let soloPerson = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct SoloPerson: Codable {
    let person: Person
    
    enum CodingKeys: String, CodingKey {
        case person = "person"
    }
}

//struct Person: Codable {
//    let surname: String
//    let name: String
//    let lastname: String
//    let birthdate: String
//    let photo: JSONNull?
//    let desc: String
//    let participationMatches: [JSONAny]
//    let id: String
//    let login: String
//    let password: String
//    let type: String
//    let pendingTeamInvites: [JSONAny]
//    let participation: [JSONAny]
//    let createdAt: String
//    let updatedAt: String
//    let v: Int
//    let pastLeagues: [PastLeague]
//
//    enum CodingKeys: String, CodingKey {
//        case surname = "surname"
//        case name = "name"
//        case lastname = "lastname"
//        case birthdate = "birthdate"
//        case photo = "photo"
//        case desc = "desc"
//        case participationMatches = "participationMatches"
//        case id = "_id"
//        case login = "login"
//        case password = "password"
//        case type = "type"
//        case pendingTeamInvites = "pendingTeamInvites"
//        case participation = "participation"
//        case createdAt = "createdAt"
//        case updatedAt = "updatedAt"
//        case v = "__v"
//        case pastLeagues = "pastLeagues"
//    }
//}
//
//struct PastLeague: Codable {
//    let id: String
//    let name: String
//    let tourney: String
//    let teamName: String
//    let place: String
//    let pastLeagueId: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case name = "name"
//        case tourney = "tourney"
//        case teamName = "teamName"
//        case place = "place"
//        case pastLeagueId = "id"
//    }
//}

// MARK: Convenience initializers and mutators

extension SoloPerson {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SoloPerson.self, from: data)
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
        person: Person? = nil
        ) -> SoloPerson {
        return SoloPerson(
            person: person ?? self.person
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
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
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseSoloPerson(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<SoloPerson>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
