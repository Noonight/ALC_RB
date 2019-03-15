// To parse the JSON, add this file to your project and do:
//
//   let players = try Players(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePlayers { response in
//     if let players = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct Players: Codable {
    var people: [Person]
    let count: Int
    
    
    
    enum CodingKeys: String, CodingKey {
        case people = "people"
        case count = "count"
    }
}

struct Person: Codable {
    let surname: String
    let name: String
    let lastname: String
    let birthdate: String
    let photo: String?
    let desc: String
    var participationMatches: [Match]
    var pastLeagues: [PastLeague]
    let id: String
    let login: String
    let password: String
    let type: String
    var pendingTeamInvites: [PendingTeamInvite]
    var participation: [Participation]
    let createdAt: String
    let updatedAt: String
    let v: Int
    let club: String?
    
    enum CodingKeys: String, CodingKey {
        case surname = "surname"
        case name = "name"
        case lastname = "lastname"
        case birthdate = "birthdate"
        case photo = "photo"
        case desc = "desc"
        case participationMatches = "participationMatches"
        case pastLeagues = "pastLeagues"
        case id = "_id"
        case login = "login"
        case password = "password"
        case type = "type"
        case pendingTeamInvites = "pendingTeamInvites"
        case participation = "participation"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
        case club = "club"
    }
    
    func getFullName() -> String {
        let fullName = "\(surname) \(name) \(lastname)"
        if (fullName.count > 3) {
            return fullName
        }
        return "Не указано"
    }
}

struct PendingTeamInvite: Codable {
    let id: String
    let league: String
    let team: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case league = "league"
        case team = "team"
    }
}

extension PendingTeamInvite {
    
    init() {
        id = ""
        league = ""
        team = ""
    }
    
    init(_ id: String,_ league: String,_ team: String) {
        self.id = id
        self.league = league
        self.team = team
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PendingTeamInvite.self, from: data)
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
        id: String? = nil,
        league: String? = nil,
        team: String? = nil
        ) -> PendingTeamInvite {
        return PendingTeamInvite(
            id: id ?? self.id,
            league: league ?? self.league,
            team: team ?? self.team
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: Convenience initializers and mutators

extension Players {
    
    init() {
        people = []
        count = 0
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Players.self, from: data)
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
        people: [Person]? = nil,
        count: Int? = nil
        ) -> Players {
        return Players(
            people: people ?? self.people,
            count: count ?? self.count
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Person {
    
    init() {
        surname = ""
        name = ""
        lastname = ""
        birthdate = ""
        photo = ""
        desc = ""
        participationMatches = []
        pastLeagues = []
        id = ""
        login = ""
        password = ""
        type = ""
        pendingTeamInvites = []
        participation = []
        createdAt = ""
        updatedAt = ""
        v = -1
        club = ""
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Person.self, from: data)
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
        photo: String?? = nil,
        desc: String? = nil,
        participationMatches: [Match]? = nil,
        pastLeagues: [PastLeague]? = nil,
        id: String? = nil,
        login: String? = nil,
        password: String? = nil,
        type: String? = nil,
        pendingTeamInvites: [PendingTeamInvite]? = nil,
        participation: [Participation]? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        v: Int? = nil,
        club: String?? = nil
        ) -> Person {
        return Person(
            surname: surname ?? self.surname,
            name: name ?? self.name,
            lastname: lastname ?? self.lastname,
            birthdate: birthdate ?? self.birthdate,
            photo: photo ?? self.photo,
            desc: desc ?? self.desc,
            participationMatches: participationMatches ?? self.participationMatches,
            pastLeagues: pastLeagues ?? self.pastLeagues,
            id: id ?? self.id,
            login: login ?? self.login,
            password: password ?? self.password,
            type: type ?? self.type,
            pendingTeamInvites: pendingTeamInvites ?? self.pendingTeamInvites,
            participation: participation ?? self.participation,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            v: v ?? self.v,
            club: club ?? self.club
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
    func responsePlayers(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Players>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
