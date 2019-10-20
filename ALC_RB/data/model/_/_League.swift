//
//  Leagues.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

enum _LeagueStatus: String, Codable {
    case pending = "Pending"
    case groups = "Groups"
    case playoff = "Playoff"
    case finished = "Finished"
}

// MARK: - _League
struct _League: Codable {
    let creator: String?
    let status: _LeagueStatus?
    let matches: [String]?
    let stages: [_Stage]?
    let id: String?
    let name: String?
    let beginDate: Date?
    let endDate: Date?
    let maxTeams: Int?
    let teams: [_Team]?
    let transferBegin: Date?
    let transferEnd: Date?
    let playersMin: Int?
    let playersMax: Int?
    let playersCapacity: Int?
    let yellowCardsToDisqual: Int?
    let ageAllowedMin: Int?
    let ageAllowedMax: Int?
    let v: Int?
    let tourney: String?

    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case status = "status"
        case matches = "matches"
        case stages = "stages"
        case id = "_id"
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
        case v = "__v"
        case tourney = "tourney"
    }
}

import Foundation

typealias _Leagues = [_League]

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
    func response_Leagues(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<_Leagues>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
