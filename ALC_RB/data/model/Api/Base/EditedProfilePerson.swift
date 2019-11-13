// To parse the JSON, add this file to your project and do:
//
//   let editedProfile = try EditedProfile(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseEditedProfile { response in
//     if let editedProfile = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct EditedProfile: Codable {
    let person: EditedProfilePerson
    
    enum CodingKeys: String, CodingKey {
        case person = "person"
    }
}

struct EditedProfilePerson: Codable {
    let surname: String
    let name: String
    let lastname: String
    let birthdate: String
    let photo: String
    let desc: String
    let participationMatches: [JSONAny]
    let id: String
    let login: String
    let password: String
    let type: String
    let pendingTeamInvites: [JSONAny]
    let participation: [JSONAny]
    let pastLeagues: [JSONAny]
    let createdAt: String
    let updatedAt: String
    let v: Int
    let club: String
    
    
    
    enum CodingKeys: String, CodingKey {
        case surname = "surname"
        case name = "name"
        case lastname = "lastname"
        case birthdate = "birthdate"
        case photo = "photo"
        case desc = "desc"
        case participationMatches = "participationMatches"
        case id = "_id"
        case login = "login"
        case password = "password"
        case type = "type"
        case pendingTeamInvites = "pendingTeamInvites"
        case participation = "participation"
        case pastLeagues = "pastLeagues"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
        case club = "club"
    }
}

// MARK: Convenience initializers and mutators

extension EditedProfile {
    init(data: Data) throws {
        self = try JSONDecoder().decode(EditedProfile.self, from: data)
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
        person: EditedProfilePerson? = nil
        ) -> EditedProfile {
        return EditedProfile(
            person: person ?? self.person
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension EditedProfilePerson {
    init(data: Data) throws {
        self = try JSONDecoder().decode(EditedProfilePerson.self, from: data)
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
        surname: String? = nil,
        name: String? = nil,
        lastname: String? = nil,
        birthdate: String? = nil,
        photo: String? = nil,
        desc: String? = nil,
        participationMatches: [JSONAny]? = nil,
        id: String? = nil,
        login: String? = nil,
        password: String? = nil,
        type: String? = nil,
        pendingTeamInvites: [JSONAny]? = nil,
        participation: [JSONAny]? = nil,
        pastLeagues: [JSONAny]? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        v: Int? = nil,
        club: String? = nil
        ) -> EditedProfilePerson {
        return EditedProfilePerson(
            surname: surname ?? self.surname,
            name: name ?? self.name,
            lastname: lastname ?? self.lastname,
            birthdate: birthdate ?? self.birthdate,
            photo: photo ?? self.photo,
            desc: desc ?? self.desc,
            participationMatches: participationMatches ?? self.participationMatches,
            id: id ?? self.id,
            login: login ?? self.login,
            password: password ?? self.password,
            type: type ?? self.type,
            pendingTeamInvites: pendingTeamInvites ?? self.pendingTeamInvites,
            participation: participation ?? self.participation,
            pastLeagues: pastLeagues ?? self.pastLeagues,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            v: v ?? self.v,
            club: club ?? self.club
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
    func responseEditedProfile(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<EditedProfile>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
