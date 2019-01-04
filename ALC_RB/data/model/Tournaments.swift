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
    let count: Int
}

struct League: Codable {
    let status: String
    let matches: [String]
    let id, tourney, name, beginDate: String
    let endDate: String
    let maxTeams: Int
    let teams: [Team]
    let transferBegin, transferEnd: String
    let playersMin, playersMax, playersCapacity, yellowCardsToDisqual: Int
    let ageAllowedMin, ageAllowedMax: Int
    
    
    
    enum CodingKeys: String, CodingKey {
        case status, matches
        case id = "_id"
        case tourney, name, beginDate, endDate, maxTeams, teams, transferBegin, transferEnd, playersMin, playersMax, playersCapacity, yellowCardsToDisqual, ageAllowedMin, ageAllowedMax
    }
}

//struct Team: Codable {
//    let status: String
//    let place: Int
//    let playoffPlace: JSONNull?
//    let madeToPlayoff: Bool
//    let group: String
//    let goals, goalsReceived, wins, losses: Int
//    let draws, groupScore: Int
//    let players: [Player]
//    let id, name, creator, club: String
//
//    enum CodingKeys: String, CodingKey {
//        case status, place, playoffPlace, madeToPlayoff, group, goals, goalsReceived, wins, losses, draws, groupScore, players
//        case id = "_id"
//        case name, creator, club
//    }
//}

//struct Player: Codable {
//    let inviteStatus: InviteStatus
//    let number: String
//    let activeYellowCards, yellowCards, redCards, activeDisquals: Int
//    let disquals, matches, goals: Int
//    let id, playerId: String
//
//    enum CodingKeys: String, CodingKey {
//        case inviteStatus, number, activeYellowCards, yellowCards, redCards, activeDisquals, disquals, matches, goals
//        case id = "_id"
//        case playerId
//    }
//}
//
//enum InviteStatus: String, Codable {
//    case accepted = "Accepted"
//}

// MARK: Convenience initializers and mutators

extension Tournaments {
    
    init() {
        leagues = []
        count = 0
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Tournaments.self, from: data)
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
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension League {
    
    init() {
        status = ""
        matches = [String]()
        id = ""
        tourney = ""
        name = ""
        beginDate = ""
        endDate = ""
        maxTeams = -1
        teams = []
        transferBegin = ""
        transferEnd = ""
        playersMin = -1
        playersMax = -1
        playersCapacity = -1
        yellowCardsToDisqual = -1
        ageAllowedMin = -1
        ageAllowedMax = -1
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(League.self, from: data)
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
        status: String? = nil,
        matches: [String]? = nil,
        id: String? = nil,
        tourney: String? = nil,
        name: String? = nil,
        beginDate: String? = nil,
        endDate: String? = nil,
        maxTeams: Int? = nil,
        teams: [Team]? = nil,
        transferBegin: String? = nil,
        transferEnd: String? = nil,
        playersMin: Int? = nil,
        playersMax: Int? = nil,
        playersCapacity: Int? = nil,
        yellowCardsToDisqual: Int? = nil,
        ageAllowedMin: Int? = nil,
        ageAllowedMax: Int? = nil
        ) -> League {
        return League(
            status: status ?? self.status,
            matches: matches ?? self.matches,
            id: id ?? self.id,
            tourney: tourney ?? self.tourney,
            name: name ?? self.name,
            beginDate: beginDate ?? self.beginDate,
            endDate: endDate ?? self.endDate,
            maxTeams: maxTeams ?? self.maxTeams,
            teams: teams ?? self.teams,
            transferBegin: transferBegin ?? self.transferBegin,
            transferEnd: transferEnd ?? self.transferEnd,
            playersMin: playersMin ?? self.playersMin,
            playersMax: playersMax ?? self.playersMax,
            playersCapacity: playersCapacity ?? self.playersCapacity,
            yellowCardsToDisqual: yellowCardsToDisqual ?? self.yellowCardsToDisqual,
            ageAllowedMin: ageAllowedMin ?? self.ageAllowedMin,
            ageAllowedMax: ageAllowedMax ?? self.ageAllowedMax
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//extension Team {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(Team.self, from: data)
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
//        status: String? = nil,
//        place: Int? = nil,
//        playoffPlace: JSONNull?? = nil,
//        madeToPlayoff: Bool? = nil,
//        group: String? = nil,
//        goals: Int? = nil,
//        goalsReceived: Int? = nil,
//        wins: Int? = nil,
//        losses: Int? = nil,
//        draws: Int? = nil,
//        groupScore: Int? = nil,
//        players: [Player]? = nil,
//        id: String? = nil,
//        name: String? = nil,
//        creator: String? = nil,
//        club: String? = nil
//        ) -> Team {
//        return Team(
//            status: status ?? self.status,
//            place: place ?? self.place,
//            playoffPlace: playoffPlace ?? self.playoffPlace,
//            madeToPlayoff: madeToPlayoff ?? self.madeToPlayoff,
//            group: group ?? self.group,
//            goals: goals ?? self.goals,
//            goalsReceived: goalsReceived ?? self.goalsReceived,
//            wins: wins ?? self.wins,
//            losses: losses ?? self.losses,
//            draws: draws ?? self.draws,
//            groupScore: groupScore ?? self.groupScore,
//            players: players ?? self.players,
//            id: id ?? self.id,
//            name: name ?? self.name,
//            creator: creator ?? self.creator,
//            club: club ?? self.club
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
//extension Player {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(Player.self, from: data)
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
//        inviteStatus: InviteStatus? = nil,
//        number: String? = nil,
//        activeYellowCards: Int? = nil,
//        yellowCards: Int? = nil,
//        redCards: Int? = nil,
//        activeDisquals: Int? = nil,
//        disquals: Int? = nil,
//        matches: Int? = nil,
//        goals: Int? = nil,
//        id: String? = nil,
//        playerId: String? = nil
//        ) -> Player {
//        return Player(
//            inviteStatus: inviteStatus ?? self.inviteStatus,
//            number: number ?? self.number,
//            activeYellowCards: activeYellowCards ?? self.activeYellowCards,
//            yellowCards: yellowCards ?? self.yellowCards,
//            redCards: redCards ?? self.redCards,
//            activeDisquals: activeDisquals ?? self.activeDisquals,
//            disquals: disquals ?? self.disquals,
//            matches: matches ?? self.matches,
//            goals: goals ?? self.goals,
//            id: id ?? self.id,
//            playerId: playerId ?? self.playerId
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

// MARK: Encode/decode helpers

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
    func responseTournaments(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Tournaments>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
