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
    var status: String?
    
    var creator: String?
    var stages: [_Stage]?
    
    
    var matches: [LIMatch]?
    var id: String?
    var tourney: String?
    var name: String?
    var beginDate: String?
    var endDate: String?
    var maxTeams: Int?
    var teams: [LITeam]?
    var transferBegin: String?
    var transferEnd: String?
    var playersMin: Int?
    var playersMax: Int?
    var playersCapacity: Int?
    var yellowCardsToDisqual: Int?
    var ageAllowedMin: Int?
    var ageAllowedMax: Int?
    
//    func convertToLeague() -> League {
//        func getMatchArray() -> [String] {
//            return (self.matches?.map({ liMatch -> String in
//                return liMatch.id
//            }))!
//        }
//        func getMatches() -> [Match] {
//            return self.matches?.map({ match -> [Match] in
//                return Match()
//            })
//        }
//        func getTeamArray() -> [Team] {
//            return (self.teams?.map({ team -> Team in
//                return team.convertToTeam()
//            }))!
//        }
//        
//        var mStatus = League.Status(rawValue: status ?? "")
//        
//        return League().with(status: mStatus, matches: getMatchArray(), id: id, tourney: tourney, name: name, beginDate: beginDate, endDate: endDate, transferBegin: transferBegin, transferEnd: transferEnd, playersMin: playersMin, playersMax: playersMax, playersCapacity: playersCapacity, yellowCardsToDisqual: yellowCardsToDisqual, ageAllowedMin: ageAllowedMin, ageAllowedMax: ageAllowedMax, maxTeams: maxTeams, teams: getTeamArray())
//    }
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case matches = "matches"
        case stages
        case creator
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
    var date: Date?
    var stage: String?
    var round: String?
    var group: String?
    var played: Bool
    var tour: String
    var playersList: [String]
    var place: String?
    var winner: String?
    var score: String?
    var fouls: String?
    var autoGoals: String?
    var id: String
    var league: String?
    var teamOne: String?
    var teamTwo: String?
    var events: [LIEvent]
    var referees: [LIReferee]
    var createdAt: Date
    var updatedAt: Date
    var v: Int
    
    
    
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
    
    init() {
        self.id = ""
        self.eventType = ""
        self.player = ""
        self.time = ""
    }
    
    init(id: String, eventType: String, player: String, time: String) {
        self.id = id
        self.eventType = eventType
        self.player = player
        self.time = time
    }
    
    init(matchID: String, eventType: EventPlayerType, playerID: String, time: EventTime) {
        self.id = matchID
        self.eventType = eventType.rawValue
        self.player = playerID
        self.time = time.rawValue
    }
    
    init(matchID: String, eventType: EventTeamType, playerID: String, time: EventTime) {
        self.id = matchID
        self.eventType = eventType.rawValue
        self.player = playerID
        self.time = time.rawValue
    }
    
    func getEventTime() -> EventTime {
        switch time {
        case EventTime.oneHalf.rawValue:
            return EventTime.oneHalf
        case EventTime.twoHalf.rawValue:
            return EventTime.twoHalf
        case EventTime.extraTime.rawValue:
            return EventTime.extraTime
        case EventTime.penaltySeries.rawValue:
            return EventTime.penaltySeries
        default:
            return EventTime.none
        }
    }
    
    func getEventType() -> EventAllTypes {
        switch eventType {
        case EventPlayerType.goal.rawValue:
            return EventAllTypes.player(EventPlayerType.goal)
        case EventPlayerType.redCard.rawValue:
            return EventAllTypes.player(EventPlayerType.redCard)
        case EventPlayerType.yellowCard.rawValue:
            return EventAllTypes.player(EventPlayerType.yellowCard)
        case EventPlayerType.penalty.rawValue:
            return EventAllTypes.player(EventPlayerType.penalty)
        case EventPlayerType.penaltyFailure.rawValue:
            return EventAllTypes.player(EventPlayerType.penaltyFailure)
            
            // team
        case EventTeamType.autoGoal.rawValue:
            return EventAllTypes.team(EventTeamType.autoGoal)
        case EventTeamType.foul.rawValue:
            return EventAllTypes.team(EventTeamType.foul)
        case EventTeamType.penaltySeriesSuccess.rawValue:
            return EventAllTypes.team(EventTeamType.penaltySeriesSuccess)
        case EventTeamType.penaltySeriesFailure.rawValue:
            return EventAllTypes.team(EventTeamType.penaltySeriesFailure)
        default:
            return EventAllTypes.none
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            CodingKeys.id.rawValue : id,
            CodingKeys.eventType.rawValue : eventType,
            CodingKeys.player.rawValue : player,
            CodingKeys.time.rawValue : time
        ]
    }
    
//    func getEventType() -> EventType {
//        switch eventType {
//        case "goal":
//            return .goal
//        case "yellowCard":
//            return .yellowCard
//        case "redCard":
//            return .redCard
//        case "foul":
//            return .foul
//        case "autoGoal":
//            return .autoGoal
//        case "penalty":
//            return .penalty
//        case "penaltyFailure":
//            return .penaltyFailure
//        default:
//            return EventType.non
//        }
//    }
    
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
        return Referee(id: id, person: IdRefObjectWrapper<Person>(person), type: Referee.rType(rawValue: type))
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
    let playoffPlace: Int?
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
        self = try JSONDecoder().decode(LILeagueInfo.self, from: data)
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
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension LILeague {
    
//    init() {
//        status = ""
//        matches = []
//        id = ""
//        tourney = ""
//        name = ""
//        beginDate = ""
//        endDate = ""
//        maxTeams = -1
//        teams = []
//        transferBegin = ""
//        transferEnd = ""
//        playersMin = -1
//        playersMax = -1
//        playersCapacity = -1
//        yellowCardsToDisqual = -1
//        ageAllowedMin = -1
//        ageAllowedMax = -1
//    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(LILeague.self, from: data)
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
        var league = LILeague()
        league.status = status ?? self.status
        league.matches = matches ?? self.matches
        league.id = id ?? self.id
        league.tourney = tourney ?? self.tourney
        league.name = name ?? self.name
        league.beginDate = beginDate ?? self.beginDate
        league.endDate = endDate ?? self.endDate
        league.maxTeams = maxTeams ?? self.maxTeams
        league.teams = teams ?? self.teams
        league.transferBegin = transferBegin ?? self.transferBegin
        league.transferEnd = transferEnd ?? self.transferEnd
        league.playersMin = playersMin ?? self.playersMin
        league.playersMax = playersMax ?? self.playersMax
        league.playersCapacity = playersCapacity ?? self.playersCapacity
        league.yellowCardsToDisqual = yellowCardsToDisqual ?? self.yellowCardsToDisqual
        league.ageAllowedMin = ageAllowedMin ?? self.ageAllowedMin
        league.ageAllowedMax = ageAllowedMax ?? self.ageAllowedMax
        
        return league
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension LIMatch {
    
    init() {
        date = Date()
        stage = ""
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
        createdAt = Date()
        updatedAt = Date()
        v = -1
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(LIMatch.self, from: data)
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
        date: Date? = nil,
        stage: String? = nil,
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
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        v: Int? = nil
        ) -> LIMatch {
        var match = LIMatch()
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
        match.id = id ?? self.id
        match.league = league ?? self.league
        match.teamOne = teamOne ?? self.teamOne
        match.teamTwo = teamTwo ?? self.teamTwo
        match.events = events ?? self.events
        match.referees = referees ?? self.referees
        match.createdAt = createdAt ?? self.createdAt
        match.updatedAt = updatedAt ?? self.updatedAt
        match.v = v ?? self.v
        
        return match
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension LIEvent {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(LIEvent.self, from: data)
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
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension LIReferee {
    init(data: Data) throws {
        self = try JSONDecoder().decode(LIReferee.self, from: data)
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
        return try JSONEncoder().encode(self)
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
        self = try JSONDecoder().decode(LITeam.self, from: data)
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
        playoffPlace: Int? = nil,
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
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension LIPlayer {
    init(data: Data) throws {
        self = try JSONDecoder().decode(LIPlayer.self, from: data)
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
    func responseLILeagueInfo(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<LILeagueInfo>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
