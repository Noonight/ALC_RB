// To parse the JSON, add this file to your project and do:
//
//   let soloClub = try SoloClub(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseSoloClub { response in
//     if let soloClub = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct SoloClub: Codable {
    let club: Club
    
    enum CodingKeys: String, CodingKey {
        case club = "club"
    }
}

//struct Club: Codable {
//    let info: String
//    let addLogo: String
//    let addInfo: String
//    let id: String
//    let name: String
//    let owner: Owner
//    let v: Int
//    let logo: String
//
//    enum CodingKeys: String, CodingKey {
//        case info = "info"
//        case addLogo = "addLogo"
//        case addInfo = "addInfo"
//        case id = "_id"
//        case name = "name"
//        case owner = "owner"
//        case v = "__v"
//        case logo = "logo"
//    }
//}

//struct Owner: Codable {
//    let surname: String
//    let name: String
//    let lastname: String
//    let birthdate: String
//    let photo: String
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
//    let club: String
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
//        case club = "club"
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

extension SoloClub {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SoloClub.self, from: data)
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
        club: Club? = nil
        ) -> SoloClub {
        return SoloClub(
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

//extension Club {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(Club.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        info: String? = nil,
//        addLogo: String? = nil,
//        addInfo: String? = nil,
//        id: String? = nil,
//        name: String? = nil,
//        owner: Owner? = nil,
//        v: Int? = nil,
//        logo: String? = nil
//        ) -> Club {
//        return Club(
//            info: info ?? self.info,
//            addLogo: addLogo ?? self.addLogo,
//            addInfo: addInfo ?? self.addInfo,
//            id: id ?? self.id,
//            name: name ?? self.name,
//            owner: owner ?? self.owner,
//            v: v ?? self.v,
//            logo: logo ?? self.logo
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//extension Owner {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(Owner.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        surname: String? = nil,
//        name: String? = nil,
//        lastname: String? = nil,
//        birthdate: String? = nil,
//        photo: String? = nil,
//        desc: String? = nil,
//        participationMatches: [JSONAny]? = nil,
//        id: String? = nil,
//        login: String? = nil,
//        password: String? = nil,
//        type: String? = nil,
//        pendingTeamInvites: [JSONAny]? = nil,
//        participation: [JSONAny]? = nil,
//        createdAt: String? = nil,
//        updatedAt: String? = nil,
//        v: Int? = nil,
//        club: String? = nil,
//        pastLeagues: [PastLeague]? = nil
//        ) -> Owner {
//        return Owner(
//            surname: surname ?? self.surname,
//            name: name ?? self.name,
//            lastname: lastname ?? self.lastname,
//            birthdate: birthdate ?? self.birthdate,
//            photo: photo ?? self.photo,
//            desc: desc ?? self.desc,
//            participationMatches: participationMatches ?? self.participationMatches,
//            id: id ?? self.id,
//            login: login ?? self.login,
//            password: password ?? self.password,
//            type: type ?? self.type,
//            pendingTeamInvites: pendingTeamInvites ?? self.pendingTeamInvites,
//            participation: participation ?? self.participation,
//            createdAt: createdAt ?? self.createdAt,
//            updatedAt: updatedAt ?? self.updatedAt,
//            v: v ?? self.v,
//            club: club ?? self.club,
//            pastLeagues: pastLeagues ?? self.pastLeagues
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//extension PastLeague {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(PastLeague.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        id: String? = nil,
//        name: String? = nil,
//        tourney: String? = nil,
//        teamName: String? = nil,
//        place: String? = nil,
//        pastLeagueId: String? = nil
//        ) -> PastLeague {
//        return PastLeague(
//            id: id ?? self.id,
//            name: name ?? self.name,
//            tourney: tourney ?? self.tourney,
//            teamName: teamName ?? self.teamName,
//            place: place ?? self.place,
//            pastLeagueId: pastLeagueId ?? self.pastLeagueId
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//// MARK: Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
//
//class JSONCodingKey: CodingKey {
//    let key: String
//
//    required init?(intValue: Int) {
//        return nil
//    }
//
//    required init?(stringValue: String) {
//        key = stringValue
//    }
//
//    var intValue: Int? {
//        return nil
//    }
//
//    var stringValue: String {
//        return key
//    }
//}
//
//class JSONAny: Codable {
//    let value: Any
//
//    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
//        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
//        return DecodingError.typeMismatch(JSONAny.self, context)
//    }
//
//    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
//        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
//        return EncodingError.invalidValue(value, context)
//    }
//
//    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if container.decodeNil() {
//            return JSONNull()
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if let value = try? container.decodeNil() {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer() {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
//        if let value = try? container.decode(Bool.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Double.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(String.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decodeNil(forKey: key) {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
//        var arr: [Any] = []
//        while !container.isAtEnd {
//            let value = try decode(from: &container)
//            arr.append(value)
//        }
//        return arr
//    }
//
//    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
//        var dict = [String: Any]()
//        for key in container.allKeys {
//            let value = try decode(from: &container, forKey: key)
//            dict[key.stringValue] = value
//        }
//        return dict
//    }
//
//    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
//        for value in array {
//            if let value = value as? Bool {
//                try container.encode(value)
//            } else if let value = value as? Int64 {
//                try container.encode(value)
//            } else if let value = value as? Double {
//                try container.encode(value)
//            } else if let value = value as? String {
//                try container.encode(value)
//            } else if value is JSONNull {
//                try container.encodeNil()
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer()
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
//        for (key, value) in dictionary {
//            let key = JSONCodingKey(stringValue: key)!
//            if let value = value as? Bool {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Int64 {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Double {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? String {
//                try container.encode(value, forKey: key)
//            } else if value is JSONNull {
//                try container.encodeNil(forKey: key)
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer(forKey: key)
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
//        if let value = value as? Bool {
//            try container.encode(value)
//        } else if let value = value as? Int64 {
//            try container.encode(value)
//        } else if let value = value as? Double {
//            try container.encode(value)
//        } else if let value = value as? String {
//            try container.encode(value)
//        } else if value is JSONNull {
//            try container.encodeNil()
//        } else {
//            throw encodingError(forValue: value, codingPath: container.codingPath)
//        }
//    }
//
//    public required init(from decoder: Decoder) throws {
//        if var arrayContainer = try? decoder.unkeyedContainer() {
//            self.value = try JSONAny.decodeArray(from: &arrayContainer)
//        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
//            self.value = try JSONAny.decodeDictionary(from: &container)
//        } else {
//            let container = try decoder.singleValueContainer()
//            self.value = try JSONAny.decode(from: container)
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        if let arr = self.value as? [Any] {
//            var container = encoder.unkeyedContainer()
//            try JSONAny.encode(to: &container, array: arr)
//        } else if let dict = self.value as? [String: Any] {
//            var container = encoder.container(keyedBy: JSONCodingKey.self)
//            try JSONAny.encode(to: &container, dictionary: dict)
//        } else {
//            var container = encoder.singleValueContainer()
//            try JSONAny.encode(to: &container, value: self.value)
//        }
//    }
//}
//
//func newJSONDecoder() -> JSONDecoder {
//    let decoder = JSONDecoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        decoder.dateDecodingStrategy = .iso8601
//    }
//    return decoder
//}
//
//func newJSONEncoder() -> JSONEncoder {
//    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
//    return encoder
//}

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
    func responseSoloClub(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<SoloClub>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
