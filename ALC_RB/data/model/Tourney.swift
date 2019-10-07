//
//  File.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 06/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

struct Tourney: Codable {
    let creator: String?
    let region: String?
    let id: String?
    let name: String?
    let ageAllowedMin: Int?
    let ageAllowedMax: Int?
    let yellowCardsToDisqual: Int?
    let playersMin: Int?
    let playersMax: Int?
    let transferBegin: Date?
    let transferEnd: Date?
    let v: Int?
    let beginDate: Date?
    let endDate: Date?
    let maxTeams: Int?

    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case region = "region"
        case id = "_id"
        case name = "name"
        case ageAllowedMin = "ageAllowedMin"
        case ageAllowedMax = "ageAllowedMax"
        case yellowCardsToDisqual = "yellowCardsToDisqual"
        case playersMin = "playersMin"
        case playersMax = "playersMax"
        case transferBegin = "transferBegin"
        case transferEnd = "transferEnd"
        case v = "__v"
        case beginDate = "beginDate"
        case endDate = "endDate"
        case maxTeams = "maxTeams"
    }
}

enum DateError: String, Error {
    case invalidDate
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }

            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            let decoder = newJSONDecoder()
            
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)

            decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                let container = try decoder.singleValueContainer()
                let dateStr = try container.decode(String.self)

                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                if let date = formatter.date(from: dateStr) {
                    return date
                }
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                if let date = formatter.date(from: dateStr) {
                    return date
                }
                throw DateError.invalidDate
            })
            
            return Result { try decoder.decode(T.self, from: data) }
        }
    }

    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }

    @discardableResult
    func responseTourneys(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<[Tourney]>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
