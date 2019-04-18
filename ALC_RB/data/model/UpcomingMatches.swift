// To parse the JSON, add this file to your project and do:
//
//   let upcomingMatches = try UpcomingMatches(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseUpcomingMatches { response in
//     if let upcomingMatches = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct UpcomingMatches: Codable {
    var matches: [Match]
    var count: Int
}

struct Match: Codable {
    var id, date: String
    var stage, played: Bool
    var tour: String
    var playersList: [JSONAny]
    var place: String
    var winner/*, score*/, fouls, autoGoals: JSONNull?
    var score: String
    var league: String
    var teamOne, teamTwo: Team
    var events, referees: [JSONAny]
    var createdAt, updatedAt: String
    var v: Int
    var leagueID: String
    
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date, stage, played, tour, playersList, place, winner, score, fouls, autoGoals, league, teamOne, teamTwo, events, referees, createdAt, updatedAt
        case v = "__v"
        case leagueID = "leagueId"
    }
}

struct Team: Codable {
    var status: String
    var place: Int
    var playoffPlace: JSONNull?
    var madeToPlayoff: Bool
    var group: String
    var goals, goalsReceived, wins, losses: Int
    var draws, groupScore: Int
    var id, name, creator: String
    var players: [Player]
    var club: String
    
    func getTeamStatus() -> TeamStatus {
        if status == TeamStatus.approved.rawValue {
            return TeamStatus.approved
        }
        if status == TeamStatus.rejected.rawValue {
            return TeamStatus.rejected
        }
        if status == TeamStatus.pending.rawValue {
            return TeamStatus.pending
        }
        
        return TeamStatus.fail
    }
    
    enum TeamStatus: String {
        case approved = "Approved"
        case pending = "Pending"
        case rejected = "Rejected"
        
        case fail = "Error"
    }
    
    enum CodingKeys: String, CodingKey {
        case status, place, playoffPlace, madeToPlayoff, group, goals, goalsReceived, wins, losses, draws, groupScore
        case id = "_id"
        case name, creator, players, club
    }
}

struct Player: Codable {
    var inviteStatus: String
    var number: String
    var activeYellowCards, yellowCards, redCards, activeDisquals: Int
    var disquals, matches, goals: Int
    var id, playerID: String
    
    init() {
        inviteStatus = InviteStatus.pending.rawValue
        number = ""
        activeYellowCards = -1
        yellowCards = -1
        redCards = -1
        activeDisquals = -1
        disquals = -1
        matches = -1
        goals = -1
        id = ""
        playerID = ""
    }
    
    func toDictionary() -> [String: Any] {
        return [
            CodingKeys.inviteStatus.rawValue : inviteStatus,
            CodingKeys.number.rawValue : number,
            CodingKeys.activeYellowCards.rawValue : activeYellowCards,
            CodingKeys.yellowCards.rawValue : yellowCards,
            CodingKeys.redCards.rawValue : redCards,
            CodingKeys.activeDisquals.rawValue : activeDisquals,
            CodingKeys.disquals.rawValue : disquals,
            CodingKeys.matches.rawValue : matches,
            CodingKeys.goals.rawValue : goals,
            CodingKeys.id.rawValue : id,
            CodingKeys.playerID.rawValue : playerID
        ]
    }
    
    func getInviteStatus() -> InviteStatus {
        if inviteStatus.contains(InviteStatus.accepted.rawValue) {
            return InviteStatus.accepted
        }
        if inviteStatus.contains(InviteStatus.approved.rawValue) {
            return InviteStatus.approved
        }
        if inviteStatus.contains(InviteStatus.rejected.rawValue) {
            return InviteStatus.rejected
        }
        if inviteStatus.contains(InviteStatus.pending.rawValue) {
            return InviteStatus.pending
        }
        return .noData
    }
    
    enum CodingKeys: String, CodingKey {
        case inviteStatus, number, activeYellowCards, yellowCards, redCards, activeDisquals, disquals, matches, goals
        case id = "_id"
        case playerID = "playerId"
    }
}

enum InviteStatus: String, Codable {
    case accepted = "Accepted"
    case approved = "Approved"
    
    case rejected = "Rejected"
    case pending = "Pending"
    
    case noData = "No data"
}

// MARK: Convenience initializers and mutators

extension UpcomingMatches {
    
    init() {
        matches = []
        count = 0
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UpcomingMatches.self, from: data)
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
        matches: [Match]? = nil,
        count: Int? = nil
        ) -> UpcomingMatches {
        return UpcomingMatches(
            matches: matches ?? self.matches,
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

extension Match {
    
    init() {
        id = ""
        date = ""
        stage = false
        played = false
        tour = ""
        playersList = []
        place = ""
        winner = nil
        score = ""
        fouls = nil
        autoGoals = nil
        league = ""
        teamOne = Team()
        teamTwo = Team()
        events = []
        referees = []
        createdAt = ""
        updatedAt = ""
        v = -1
        leagueID = ""
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Match.self, from: data)
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
        date: String? = nil,
        stage: Bool? = nil,
        played: Bool? = nil,
        tour: String? = nil,
        playersList: [JSONAny]? = nil,
        place: String? = nil,
        winner: JSONNull?? = nil,
        //score: JSONNull?? = nil,
        score: String? = "",
        fouls: JSONNull?? = nil,
        autoGoals: JSONNull?? = nil,
        league: String? = nil,
        teamOne: Team? = nil,
        teamTwo: Team? = nil,
        events: [JSONAny]? = nil,
        referees: [JSONAny]? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        v: Int? = nil,
        leagueID: String? = nil
        ) -> Match {
        
        var match = Match()
        match.id = id ?? self.id
        match.date = date ?? self.date
        match.stage = stage ?? self.stage
        match.played = played ?? self.played
        match.tour = tour ?? self.tour
        match.playersList = playersList ?? self.playersList
        match.place = place ?? self.place
        match.winner = winner ?? self.winner
        match.score = score ?? self.score
        match.fouls = fouls ?? self.fouls
        match.autoGoals = autoGoals ?? self.autoGoals
        match.league = league ?? self.league
        match.teamOne = teamOne ?? self.teamOne
        match.teamTwo = teamTwo ?? self.teamTwo
        match.events = events ?? self.events
        match.referees = referees ?? self.referees
        match.createdAt = createdAt ?? self.createdAt
        match.updatedAt = updatedAt ?? self.updatedAt
        match.v = v ?? self.v
        match.leagueID = leagueID ?? self.leagueID
        
//        return Match(
//            id: id ?? self.id,
//            date: date ?? self.date,
//            stage: stage ?? self.stage,
//            played: played ?? self.played,
//            tour: tour ?? self.tour,
//            playersList: playersList ?? self.playersList,
//            place: place ?? self.place,
//            winner: winner ?? self.winner,
//            score: score ?? self.score,
//            fouls: fouls ?? self.fouls,
//            autoGoals: autoGoals ?? self.autoGoals,
//            league: league ?? self.league,
//            teamOne: teamOne ?? self.teamOne,
//            teamTwo: teamTwo ?? self.teamTwo,
//            events: events ?? self.events,
//            referees: referees ?? self.referees,
//            createdAt: createdAt ?? self.createdAt,
//            updatedAt: updatedAt ?? self.updatedAt,
//            v: v ?? self.v,
//            leagueID: leagueID ?? self.leagueID
//        )
        return match
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Team {
    
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
        self = try newJSONDecoder().decode(Team.self, from: data)
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
        id: String? = nil,
        name: String? = nil,
        creator: String? = nil,
        players: [Player]? = nil,
        club: String? = nil
        ) -> Team {
        
        var team = Team()
        team.status = status ?? self.status
        team.place = place ?? self.place
        team.playoffPlace = playoffPlace ?? self.playoffPlace
        team.madeToPlayoff = madeToPlayoff ?? self.madeToPlayoff
        team.group = group ?? self.group
        team.goals = goals ?? self.goals
        team.goalsReceived = goalsReceived ?? self.goalsReceived
        team.wins = wins ?? self.wins
        team.losses = losses ?? self.losses
        team.draws = draws ?? self.draws
        team.groupScore = groupScore ?? self.groupScore
        team.id = id ?? self.id
        team.name = name ?? self.name
        team.creator = creator ?? self.creator
        team.players = players ?? self.players
        team.club = club ?? self.club
        
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
//            id: id ?? self.id,
//            name: name ?? self.name,
//            creator: creator ?? self.creator,
//            players: players ?? self.players,
//            club: club ?? self.club
//        )
        return team
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Player {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Player.self, from: data)
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
        playerID: String? = nil
        ) -> Player {
        var player = Player()
        player.inviteStatus = inviteStatus ?? self.inviteStatus
        player.number = number ?? self.number
        player.activeYellowCards = activeYellowCards ?? self.activeYellowCards
        player.yellowCards = yellowCards ?? self.yellowCards
        player.redCards = redCards ?? self.redCards
        player.activeDisquals = activeDisquals ?? self.activeDisquals
        player.inviteStatus = inviteStatus ?? self.inviteStatus
        player.disquals = disquals ?? self.disquals
        player.number = number ?? self.number
        player.matches = matches ?? self.matches
        player.goals = goals ?? self.goals
        player.id = id ?? self.id
        player.playerID = playerID ?? self.playerID
        return player
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    let value: Any
    
    public required init() {
        value = ""
    }
    
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }
    
    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }
    
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
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
    func responseUpcomingMatches(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<UpcomingMatches>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
