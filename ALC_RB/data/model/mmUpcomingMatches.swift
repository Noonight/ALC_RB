// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mmUpcomingMatches = try MmUpcomingMatches(json)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMmUpcomingMatches { response in
//     if let mmUpcomingMatches = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - MmUpcomingMatches
struct MmUpcomingMatches: Codable {
    let matches: [MmMatch]?
    let count: Int?
    
    init() {
        matches = []
        count = 0
    }
    
    enum CodingKeys: String, CodingKey {
        case matches = "matches"
        case count = "count"
    }
}

// MARK: MmUpcomingMatches convenience initializers and mutators

extension MmUpcomingMatches {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MmUpcomingMatches.self, from: data)
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
        matches: [MmMatch]?? = nil,
        count: Int?? = nil
        ) -> MmUpcomingMatches {
        return MmUpcomingMatches().with(matches: matches ?? self.matches,
                                        count: count ?? self.count)
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMmMatch { response in
//     if let mmMatch = response.result.value {
//       ...
//     }
//   }

// MARK: - MmMatch
struct MmMatch: Codable {
    let id: String?
    let date: String?
    let stage: Bool?
    let played: Bool?
    let tour: String?
    let playersList: [JSONAny]?
    let place: String?
    let winner: JSONNull?
    let score: String?
    let fouls: JSONNull?
    let autoGoals: JSONNull?
    let teamOne: MmTeam?
    let teamTwo: MmTeam?
    let league: String?
    let events: [JSONAny]?
    let referees: [MmReferee]?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?
    let leagueId: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date = "date"
        case stage = "stage"
        case played = "played"
        case tour = "tour"
        case playersList = "playersList"
        case place = "place"
        case winner = "winner"
        case score = "score"
        case fouls = "fouls"
        case autoGoals = "autoGoals"
        case teamOne = "teamOne"
        case teamTwo = "teamTwo"
        case league = "league"
        case events = "events"
        case referees = "referees"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
        case leagueId = "leagueId"
    }
}

// MARK: MmMatch convenience initializers and mutators

extension MmMatch {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MmMatch.self, from: data)
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
        id: String?? = nil,
        date: String?? = nil,
        stage: Bool?? = nil,
        played: Bool?? = nil,
        tour: String?? = nil,
        playersList: [JSONAny]?? = nil,
        place: String?? = nil,
        winner: JSONNull?? = nil,
        score: String?? = nil,
        fouls: JSONNull?? = nil,
        autoGoals: JSONNull?? = nil,
        teamOne: MmTeam?? = nil,
        teamTwo: MmTeam?? = nil,
        league: String?? = nil,
        events: [JSONAny]?? = nil,
        referees: [MmReferee]?? = nil,
        createdAt: String?? = nil,
        updatedAt: String?? = nil,
        v: Int?? = nil,
        leagueId: String?? = nil
        ) -> MmMatch {
        return MmMatch(
            id: id ?? self.id,
            date: date ?? self.date,
            stage: stage ?? self.stage,
            played: played ?? self.played,
            tour: tour ?? self.tour,
            playersList: playersList ?? self.playersList,
            place: place ?? self.place,
            winner: winner ?? self.winner,
            score: score ?? self.score,
            fouls: fouls ?? self.fouls,
            autoGoals: autoGoals ?? self.autoGoals,
            teamOne: teamOne ?? self.teamOne,
            teamTwo: teamTwo ?? self.teamTwo,
            league: league ?? self.league,
            events: events ?? self.events,
            referees: referees ?? self.referees,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            v: v ?? self.v,
            leagueId: leagueId ?? self.leagueId
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMmReferee { response in
//     if let mmReferee = response.result.value {
//       ...
//     }
//   }

// MARK: - MmReferee
struct MmReferee: Codable {
    let id: String?
    let person: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case person = "person"
        case type = "type"
    }
}

// MARK: MmReferee convenience initializers and mutators

extension MmReferee {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MmReferee.self, from: data)
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
        id: String?? = nil,
        person: String?? = nil,
        type: String?? = nil
        ) -> MmReferee {
        return MmReferee(
            id: id ?? self.id,
            person: person ?? self.person,
            type: type ?? self.type
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMmTeam { response in
//     if let mmTeam = response.result.value {
//       ...
//     }
//   }

// MARK: - MmTeam
struct MmTeam: Codable {
    let status: String?
    let place: Int?
    let playoffPlace: JSONNull?
    let madeToPlayoff: Bool?
    let group: String?
    let goals: Int?
    let goalsReceived: Int?
    let wins: Int?
    let losses: Int?
    let draws: Int?
    let groupScore: Int?
    let id: String?
    let creator: String?
    let club: String?
    let name: String?
    let players: [MmPlayer]?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case place = "place"
        case playoffPlace = "playoffPlace"
        case madeToPlayoff = "madeToPlayoff"
        case group = "group"
        case goals = "goals"
        case goalsReceived = "goalsReceived"
        case wins = "wins"
        case losses = "losses"
        case draws = "draws"
        case groupScore = "groupScore"
        case id = "_id"
        case creator = "creator"
        case club = "club"
        case name = "name"
        case players = "players"
    }
}

// MARK: MmTeam convenience initializers and mutators

extension MmTeam {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MmTeam.self, from: data)
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
        status: String?? = nil,
        place: Int?? = nil,
        playoffPlace: JSONNull?? = nil,
        madeToPlayoff: Bool?? = nil,
        group: String?? = nil,
        goals: Int?? = nil,
        goalsReceived: Int?? = nil,
        wins: Int?? = nil,
        losses: Int?? = nil,
        draws: Int?? = nil,
        groupScore: Int?? = nil,
        id: String?? = nil,
        creator: String?? = nil,
        club: String?? = nil,
        name: String?? = nil,
        players: [MmPlayer]?? = nil
        ) -> MmTeam {
        return MmTeam(
            status: status ?? self.status,
            place: place ?? self.place,
            playoffPlace: playoffPlace ?? self.playoffPlace,
            madeToPlayoff: madeToPlayoff ?? self.madeToPlayoff,
            group: group ?? self.group,
            goals: goals ?? self.goals,
            goalsReceived: goalsReceived ?? self.goalsReceived,
            wins: wins ?? self.wins,
            losses: losses ?? self.losses,
            draws: draws ?? self.draws,
            groupScore: groupScore ?? self.groupScore,
            id: id ?? self.id,
            creator: creator ?? self.creator,
            club: club ?? self.club,
            name: name ?? self.name,
            players: players ?? self.players
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMmPlayer { response in
//     if let mmPlayer = response.result.value {
//       ...
//     }
//   }

// MARK: - MmPlayer
struct MmPlayer: Codable {
    let inviteStatus: String?
    let number: String?
    let activeYellowCards: Int?
    let yellowCards: Int?
    let redCards: Int?
    let activeDisquals: Int?
    let disquals: Int?
    let matches: Int?
    let goals: Int?
    let id: String?
    let playerId: String?
    
    enum CodingKeys: String, CodingKey {
        case inviteStatus = "inviteStatus"
        case number = "number"
        case activeYellowCards = "activeYellowCards"
        case yellowCards = "yellowCards"
        case redCards = "redCards"
        case activeDisquals = "activeDisquals"
        case disquals = "disquals"
        case matches = "matches"
        case goals = "goals"
        case id = "_id"
        case playerId = "playerId"
    }
}

// MARK: MmPlayer convenience initializers and mutators

extension MmPlayer {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MmPlayer.self, from: data)
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
        inviteStatus: String?? = nil,
        number: String?? = nil,
        activeYellowCards: Int?? = nil,
        yellowCards: Int?? = nil,
        redCards: Int?? = nil,
        activeDisquals: Int?? = nil,
        disquals: Int?? = nil,
        matches: Int?? = nil,
        goals: Int?? = nil,
        id: String?? = nil,
        playerId: String?? = nil
        ) -> MmPlayer {
        return MmPlayer(
            inviteStatus: inviteStatus ?? self.inviteStatus,
            number: number ?? self.number,
            activeYellowCards: activeYellowCards ?? self.activeYellowCards,
            yellowCards: yellowCards ?? self.yellowCards,
            redCards: redCards ?? self.redCards,
            activeDisquals: activeDisquals ?? self.activeDisquals,
            disquals: disquals ?? self.disquals,
            matches: matches ?? self.matches,
            goals: goals ?? self.goals,
            id: id ?? self.id,
            playerId: playerId ?? self.playerId
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decod

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
    func responseMmUpcomingMatches(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<MmUpcomingMatches>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
