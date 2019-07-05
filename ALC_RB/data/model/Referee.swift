//
//  Referee.swift
//  ALC_RB
//
//  Created by ayur on 12.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

struct Referee: Codable {
    var id: String
    var type: String // type of ref: 1 судья, 2 судья, 3 судья, Хронометрист
    var person: String // person id
    
    init(id: String, person: String, type: String) {
        self.id = id
        self.person = person
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type = "type"
        case person = "person"
    }
    
    enum RefereeType: String {
        case referee1 = "1 судья"
        case referee2 = "2 судья"
        case referee3 = "3 судья"
        case timekeeper = "Хронометрист"
        
        case invalid = "Не валидный тип судьи"
    }
    
    func getRefereeType() -> RefereeType {
        if type == RefereeType.referee1.rawValue {
            return RefereeType.referee1
        }
        if type == RefereeType.referee2.rawValue {
            return RefereeType.referee2
        }
        if type == RefereeType.referee3.rawValue {
            return RefereeType.referee3
        }
        if type == RefereeType.timekeeper.rawValue {
            return RefereeType.timekeeper
        }
        return RefereeType.invalid
    }
}

extension Referee {
    init() {
        id = ""
        type = ""
        person = ""
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Referee.self, from: data)
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
        type: String? = nil,
        person: String? = nil
        ) -> Referee {
        return Referee(
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
