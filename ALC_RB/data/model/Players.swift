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
    
    func findPersonBy(fullName: String) -> Person? {
        return people.filter({ person -> Bool in
            return person.compareFullName(with: fullName)
        }).first
    }
}

struct Person: Codable {
    var surname: String
    var name: String
    var lastname: String
    var birthdate: Date
    var photo: String?
//    var desc: String
//    var participationMatches: [ParticipationMatch]?
    var participationMatches: [IdRefObject<ParticipationMatch>]?
    var pastLeagues: [PastLeague]
    var id: String
    var login: String
    var password: String
    var type: String
    var pendingTeamInvites: [PendingTeamInvite]
    var participation: [Participation]
    var createdAt: Date
    var updatedAt: Date
    var v: Int
    var club: String?
    var region: String
    var favoriteTourney: [String]
    
    enum TypeOfPerson: String {
        case player = "player"
        case referee = "referee"
        case mainReferee = "mainReferee"
        case notFind = "error type"
    }
    
    enum CodingKeys: String, CodingKey {
        case surname = "surname"
        case name = "name"
        case lastname = "lastname"
        case birthdate = "birthdate"
        case photo = "photo"
//        case desc = "desc"
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
        case region = "region"
        case favoriteTourney = "favoriteTourney"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.surname = try container.decodeIfPresent(String.self, forKey: .surname) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname) ?? ""
        self.birthdate = try container.decodeIfPresent(Date.self, forKey: .birthdate) ?? Date()
        self.photo = try container.decodeIfPresent(String.self, forKey: .photo) ?? ""
//        self.desc = try container.decodeIfPresent(String.self, forKey: .desc) ?? ""
//        self.participationMatches = try container.decodeIfPresent([ParticipationMatch].self, forKey: .participationMatches) ?? []
        self.participationMatches = try container.decodeIfPresent([IdRefObject<ParticipationMatch>].self, forKey: .participationMatches) ?? []
        self.pastLeagues = try container.decodeIfPresent([PastLeague].self, forKey: .pastLeagues) ?? []
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.login = try container.decodeIfPresent(String.self, forKey: .login) ?? ""
        self.password = try container.decodeIfPresent(String.self, forKey: .password) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.pendingTeamInvites = try container.decodeIfPresent([PendingTeamInvite].self, forKey: .pendingTeamInvites) ?? []
        self.participation = try container.decodeIfPresent([Participation].self, forKey: .participation) ?? []
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? Date()
        self.v = try container.decodeIfPresent(Int.self, forKey: .v) ?? -1
        self.club = try container.decodeIfPresent(String.self, forKey: .club) ?? ""
        self.region = try container.decodeIfPresent(String.self, forKey: .region) ?? ""
        self.favoriteTourney = try container.decodeIfPresent([String].self, forKey: .favoriteTourney) ?? []
    }
    
    func compareFullName(with fullName: String) -> Bool {
        return fullName.lowercased() == getFullName().lowercased()
    }
    
    func getFullName() -> String {
        let fullName = "\(surname) \(name) \(lastname)"
        if (fullName.count > 0) {
            return fullName
        }
        return "Не указано"
    }
    
    // Surname, First Name, First Patronymic
    func getSurnameNP() -> String {
        let emptyChar = Character(" ")
        let surnameNP = "\(surname) \(name.first ?? emptyChar) \(lastname.first ?? emptyChar)"
        if (surnameNP.count > 4) {
            return surnameNP
        }
        return "Не указано"
    }
    
    func getUserType() -> TypeOfPerson {
        if type == TypeOfPerson.player.rawValue {
            return TypeOfPerson.player
        }
        if type == TypeOfPerson.referee.rawValue {
            return TypeOfPerson.referee
        }
        if type == TypeOfPerson.mainReferee.rawValue {
            return TypeOfPerson.mainReferee
        }
        return TypeOfPerson.notFind
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
        self = try ISO8601Decoder.getDecoder().decode(PendingTeamInvite.self, from: data)
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
//        return try ISO8601Decoder.getDecoder().encode(self)
        return try JSONEncoder().encode(self)
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
        self = try ISO8601Decoder.getDecoder().decode(Players.self, from: data)
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
        return try JSONEncoder().encode(self)
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
        birthdate = Date()
        photo = ""
//        desc = ""
        participationMatches = []
        pastLeagues = []
        id = ""
        login = ""
        password = ""
        type = ""
        pendingTeamInvites = []
        participation = []
        createdAt = Date()
        updatedAt = Date()
        v = -1
        club = ""
        region = ""
        favoriteTourney = []
    }
    
    init(data: Data) throws {
        self = try ISO8601Decoder.getDecoder().decode(Person.self, from: data)
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
        birthdate: Date? = nil,
        photo: String?? = nil,
//        desc: String? = nil,
//        participationMatches: [ParticipationMatch]? = nil,
        participationMatches: [IdRefObject<ParticipationMatch>]? = nil,
        pastLeagues: [PastLeague]? = nil,
        id: String? = nil,
        login: String? = nil,
        password: String? = nil,
        type: String? = nil,
        pendingTeamInvites: [PendingTeamInvite]? = nil,
        participation: [Participation]? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        v: Int? = nil,
        club: String?? = nil,
        favoriteTourney: [String]? = nil
        ) -> Person {
        var person = Person()
        person.surname = surname ?? self.surname
        person.name = name ?? self.name
        person.lastname = lastname ?? self.lastname
        person.birthdate = birthdate ?? self.birthdate
        person.photo = photo ?? self.photo
//        person.desc = desc ?? self.desc
        person.participationMatches = participationMatches ?? self.participationMatches
        person.pastLeagues = pastLeagues ?? self.pastLeagues
        person.id = id ?? self.id
        person.login = login ?? self.login
        person.password = password ?? self.password
        person.type = type ?? self.type
        person.pendingTeamInvites = pendingTeamInvites ?? self.pendingTeamInvites
        person.participation = participation ?? self.participation
        person.createdAt = createdAt ?? self.createdAt
        person.updatedAt = updatedAt ?? self.updatedAt
        person.v = v ?? self.v
        person.club = club ?? self.club
        person.favoriteTourney = favoriteTourney ?? self.favoriteTourney
        
        return person
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
            
            return Result { try ISO8601Decoder.getDecoder().decode(T.self, from: data) }
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
