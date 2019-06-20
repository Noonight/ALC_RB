// To parse the JSON, add this file to your project and do:
//
//   let lILeagueInfo = try LILeagueInfo(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseLILeagueInfo { response in
//     if let lILeagueInfo = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct LILeagueInfo: Codable {
    let league: LILeague
    
    enum CodingKeys: String, CodingKey {
        case league = "league"
    }
}

struct LILeague: Codable {
    let status: String?
    let matches: [LIMatch]?
    let id: String?
    let tourney: String?
    let name: String?
    let beginDate: String?
    let endDate: String?
    let maxTeams: Int?
    let teams: [LITeam]?
    let transferBegin: String?
    let transferEnd: String?
    let playersMin: Int?
    let playersMax: Int?
    let playersCapacity: Int?
    let yellowCardsToDisqual: Int?
    let ageAllowedMin: Int?
    let ageAllowedMax: Int?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case matches = "matches"
        case id = "_id"
        case tourney = "tourney"
        case name = "name"
        case beginDate = "beginDate"
        case endDate = "endDate"
        case maxTeams = "maxTeams"
        case teams = "teams"
        case transferBegin = "transferBegin"
        case transferEnd = "transferEnd"
        case playersMin = "playersMin"
        case playersMax = "playersMax"
        case playersCapacity = "playersCapacity"
        case yellowCardsToDisqual = "yellowCardsToDisqual"
        case ageAllowedMin = "ageAllowedMin"
        case ageAllowedMax = "ageAllowedMax"
    }
}

struct LIMatch: Codable {
    let date: String?
    let stage: Bool
    let played: Bool
    let tour: String
    let playersList: [String]
    let place: String?
    let winner: String?
    let score: String?
    let fouls: String?
    let autoGoals: String?
    let id: String
    let league: String
    let teamOne: String?
    let teamTwo: String?
    var events: [LIEvent]
    let referees: [LIReferee]
    let createdAt: String
    let updatedAt: String
    let v: Int
    
    
    
    enum CodingKeys: String, CodingKey {
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
        case id = "_id"
        case league = "league"
        case teamOne = "teamOne"
        case teamTwo = "teamTwo"
        case events = "events"
        case referees = "referees"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }
}

struct LIEvent: Codable {
    let id: String
    let eventType: String
    let player: String
    let time: String
    
    func getEventType() -> EventType {
        switch eventType {
        case "goal":
            return .goal
        case "yellowCard":
            return .yellowCard
        case "redCard":
            return .redCard
        case "foul":
            return .foul
        case "autoGoal":
            return .autoGoal
        case "penalty":
            return .penalty
        default:
            return EventType.non
        }
    }
    
    enum EventType: String {
        case goal = "Г"
        case yellowCard = "ЖК"
        case redCard = "КК"
        case foul = "Ф"
        case autoGoal = "А"
        case penalty = "П"
        case non = "-"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case eventType = "eventType"
        case player = "player"
        case time = "time"
    }
}

struct LIReferee: Codable {
    let id: String
    let person: String
    let type: String
    
    func getType() -> RefereeTeamTableViewController.TableStruct.RefereeType {
        switch type {
        case "Инспектор":
            return .inspector
        case "1 судья":
            return .first
        case "2 судья":
            return .second
        case "3 судья":
            return .third
        case "Хронометрист":
            return .chrono
        default:
            return .first
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case person = "person"
        case type = "type"
    }
}

struct LITeam: Codable {
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
    let players: [LIPlayer]?
    let id: String?
    let name: String?
    let creator: String?
    let club: String?
    
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
        case players = "players"
        case id = "_id"
        case name = "name"
        case creator = "creator"
        case club = "club"
    }
}

struct LIPlayer: Codable {
    let inviteStatus: String
    let number: String
    let activeYellowCards: Int
    let yellowCards: Int
    let redCards: Int
    let activeDisquals: Int
    let disquals: Int
    let matches: Int
    let goals: Int
    let id: String
    let playerId: String
    
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

// MARK: Convenience initializers and mutators

extension LILeagueInfo {
    
    init() {
        league = LILeague()
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LILeagueInfo.self, from: data)
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
        league: LILeague? = nil
        ) -> LILeagueInfo {
        return LILeagueInfo(
            league: league ?? self.league
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension LILeague {
    
    init() {
        status = ""
        matches = []
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
        self = try newJSONDecoder().decode(LILeague.self, from: data)
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
        matches: [LIMatch]? = nil,
        id: String? = nil,
        tourney: String? = nil,
        name: String? = nil,
        beginDate: String? = nil,
        endDate: String? = nil,
        maxTeams: Int? = nil,
        teams: [LITeam]? = nil,
        transferBegin: String? = nil,
        transferEnd: String? = nil,
        playersMin: Int? = nil,
        playersMax: Int? = nil,
        playersCapacity: Int? = nil,
        yellowCardsToDisqual: Int? = nil,
        ageAllowedMin: Int? = nil,
        ageAllowedMax: Int? = nil
        ) -> LILeague {
        return LILeague(
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

extension LIMatch {
    
    init() {
        date = ""
        stage = false
        played = false
        tour = ""
        playersList = []
        place = ""
        winner = ""
        score = ""
        fouls = ""
        autoGoals = ""
        id = ""
        league = ""
        teamOne = ""
        teamTwo = ""
        events = []
        referees = []
        createdAt = ""
        updatedAt = ""
        v = -1
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LIMatch.self, from: data)
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
        date: String? = nil,
        stage: Bool? = nil,
        played: Bool? = nil,
        tour: String? = nil,
        playersList: [String]? = nil,
        place: String?? = nil,
        winner: String?? = nil,
        score: String?? = nil,
        fouls: String?? = nil,
        autoGoals: String?? = nil,
        id: String? = nil,
        league: String? = nil,
        teamOne: String? = nil,
        teamTwo: String? = nil,
        events: [LIEvent]? = nil,
        referees: [LIReferee]? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        v: Int? = nil
        ) -> LIMatch {
        return LIMatch(
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
            id: id ?? self.id,
            league: league ?? self.league,
            teamOne: teamOne ?? self.teamOne,
            teamTwo: teamTwo ?? self.teamTwo,
            events: events ?? self.events,
            referees: referees ?? self.referees,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            v: v ?? self.v
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension LIEvent {
    
    init() {
        id = " "
        eventType = " "
        player = " "
        time = " "
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LIEvent.self, from: data)
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
        eventType: String? = nil,
        player: String? = nil,
        time: String? = nil
        ) -> LIEvent {
        return LIEvent(
            id: id ?? self.id,
            eventType: eventType ?? self.eventType,
            player: player ?? self.player,
            time: time ?? self.time
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension LIReferee {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LIReferee.self, from: data)
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
        person: String? = nil,
        type: String? = nil
        ) -> LIReferee {
        return LIReferee(
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

extension LITeam {
    
    init() {
        status = ""
        place = -1
        playoffPlace = nil
        madeToPlayoff = false
        group = ""
        goals = -1
        goalsReceived = -1
        wins = -1
        losses = -1
        draws = -1
        groupScore = -1
        id = ""
        name = ""
        creator = ""
        players = []
        club = ""
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LITeam.self, from: data)
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
        place: Int? = nil,
        playoffPlace: JSONNull?? = nil,
        madeToPlayoff: Bool? = nil,
        group: String? = nil,
        goals: Int? = nil,
        goalsReceived: Int? = nil,
        wins: Int? = nil,
        losses: Int? = nil,
        draws: Int? = nil,
        groupScore: Int? = nil,
        players: [LIPlayer]? = nil,
        id: String? = nil,
        name: String? = nil,
        creator: String? = nil,
        club: String? = nil
        ) -> LITeam {
        return LITeam(
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
            players: players ?? self.players,
            id: id ?? self.id,
            name: name ?? self.name,
            creator: creator ?? self.creator,
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

extension LIPlayer {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LIPlayer.self, from: data)
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
        inviteStatus: String? = nil,
        number: String? = nil,
        activeYellowCards: Int? = nil,
        yellowCards: Int? = nil,
        redCards: Int? = nil,
        activeDisquals: Int? = nil,
        disquals: Int? = nil,
        matches: Int? = nil,
        goals: Int? = nil,
        id: String? = nil,
        playerId: String? = nil
        ) -> LIPlayer {
        return LIPlayer(
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
    func responseLILeagueInfo(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<LILeagueInfo>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
