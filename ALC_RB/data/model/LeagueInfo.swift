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
    var league: LILeague
    
    enum CodingKeys: String, CodingKey {
        case league = "league"
    }
}

struct LILeague: Codable {
    let status: String?
    var matches: [LIMatch]?
    let id: String?
    let tourney: String?
    let name: String?
    var beginDate: String?
    var endDate: String?
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
    
    func convertToLeague() -> League {
        func getMatchArray() -> [String] {
            return (self.matches?.map({ liMatch -> String in
                return liMatch.id
            }))!
        }
        func getTeamArray() -> [Team] {
            return (self.teams?.map({ team -> Team in
                return team.convertToTeam()
            }))!
        }
        return League().with(status: status, matches: getMatchArray(), id: id, tourney: tourney, name: name, beginDate: beginDate, endDate: endDate, transferBegin: transferBegin, transferEnd: transferEnd, playersMin: playersMin, playersMax: playersMax, playersCapacity: playersCapacity, yellowCardsToDisqual: yellowCardsToDisqual, ageAllowedMin: ageAllowedMin, ageAllowedMax: ageAllowedMax, maxTeams: maxTeams, teams: getTeamArray())
    }
    
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
    var played: Bool
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
    let id: String // m.b. id of match
    let eventType: String
    let player: String
    let time: String
    
    func toDictionary() -> [String: Any] {
        return [
            CodingKeys.id.rawValue : id,
            CodingKeys.eventType.rawValue : eventType,
            CodingKeys.player.rawValue : player,
            CodingKeys.time.rawValue : time
        ]
    }
    
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
        case "penaltyFailure":
            return .penaltyFailure
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
        case penaltyFailure = "ПН"
        case non = "-"
    }
    
    enum SystemEventType: String {
        case goal, yellowCard, redCard, foul, autoGoal, penalty, penaltyFailure, non
        
        func getImage() -> UIImage? {
            switch self {
            case .goal:
                return UIImage(named: "ic_green_footbal")
            case .foul:
                return UIImage(named: "ic_faul")
            case .penalty:
                return UIImage(named: "ic_green_footbal_with_P")
            case .penaltyFailure:
                return UIImage(named: "ic_gray_footbal_with_P")
            case .yellowCard:
                return UIImage(named: "ic_yellowCard")
            case .redCard:
                return UIImage(named: "ic_redCard")
            case .autoGoal:
                return UIImage(named: "ic_goal")
            case .non:
                return UIImage(named: "ic_settings")
            }
        }
    }
    
    func getSystemEventType() -> SystemEventType {
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
        case "penaltyFailure":
            return .penaltyFailure
        default:
            return .non
        }
    }
    
    func getSystemEventImage() -> UIImage? {
        switch getSystemEventType() {
        case .goal:
            return UIImage(named: "ic_green_footbal")
        case .foul:
            return UIImage(named: "ic_faul")
        case .penalty:
//            let image = UIImage(named: "ic_green_footbal")
//            return image?.addText(textToDraw: NSString(string: "П"), atCorner: 2, textColor: .black, textFont: UIFont.systemFont(ofSize: 25))
            return UIImage(named: "ic_green_footbal_with_P")
        case .penaltyFailure:
//            let image = UIImage(named: "ic_gray_footbal")
//            return image?.addText(textToDraw: NSString(string: "П"), atCorner: 2, textColor: .black, textFont: UIFont.systemFont(ofSize: 25))
            return UIImage(named: "ic_gray_footbal_with_P")
        case .yellowCard:
            return UIImage(named: "ic_yellowCard")
        case .redCard:
            return UIImage(named: "ic_redCard")
        case .autoGoal:
            return UIImage(named: "ic_goal")
        case .non:
            return UIImage(named: "ic_settings")
        }
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
    
    init(id: String, person: String, type: String) {
        self.id = id
        self.person = person
        self.type = type
    }
    
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
    
    func convertToReferee() -> Referee {
        return Referee(id: id, person: person, type: type)
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
    var players: [LIPlayer]?
    let id: String?
    let name: String?
    let creator: String?
    let club: String?
    
    func isContainsPlayersWithActiveDisquals() -> Bool {
        guard let curPlayers = players else { return false }
        for player in curPlayers {
            if player.activeDisquals != 0
            {
                return true
            }
        }
        return false
    }
    
    func countOfPlayersWithActiveDisquals() -> Int {
        guard let curPlayers = players else { return 0 }
        var counter = 0
        for player in curPlayers {
            if player.activeDisquals != 0
            {
                counter += 1
            }
        }
        return counter
    }
    
    func convertToTeam() -> Team {
        func getPlayersArray() -> [Player] {
            return (players?.map({ player -> Player in
                return player.convertToPlayer()
            }))!
        }
        return Team().with(status: status, place: place, playoffPlace: playoffPlace, madeToPlayoff: madeToPlayoff, group: group, goals: goals, goalsReceived: goalsReceived, wins: wins, losses: losses, draws: draws, groupScore: groupScore, id: id, name: name, creator: creator, players: getPlayersArray(), club: club)
    }
    
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
    var inviteStatus: String
    var number: String
    var activeYellowCards: Int
    var yellowCards: Int
    var redCards: Int
    var activeDisquals: Int
    var disquals: Int
    var matches: Int
    var goals: Int
    var id: String
    var playerId: String
    
    init() {
        self.inviteStatus = InviteStatus.accepted.rawValue
        self.number = "00"
        self.activeYellowCards = 0
        self.yellowCards = 0
        self.redCards = 0
        self.activeDisquals = 0
        self.disquals = 0
        self.matches = 0
        self.goals = 0
        self.id = ""
        self.playerId = ""
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
    
    func convertToPlayer() -> Player {
        return Player().with(inviteStatus: inviteStatus, number: number, activeYellowCards: activeYellowCards, yellowCards: yellowCards, redCards: redCards, activeDisquals: activeDisquals, disquals: disquals, matches: matches, goals: goals, id: id, playerID: playerId)
    }
    
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
        
        var player = LIPlayer()
        player.inviteStatus = inviteStatus ?? self.inviteStatus
        player.number = number ?? self.number
        player.activeYellowCards = activeYellowCards ?? self.activeYellowCards
        player.yellowCards = yellowCards ?? self.yellowCards
        player.redCards = redCards ?? self.redCards
        player.activeDisquals = activeDisquals ?? self.activeDisquals
        player.disquals = disquals ?? self.disquals
        player.matches = matches ?? self.matches
        player.goals = goals ?? self.goals
        player.id = id ?? self.id
        player.playerId = playerId ?? self.playerId
        
        return player
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
