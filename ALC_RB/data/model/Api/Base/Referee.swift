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
    
    var type: rType? // type of ref: 1 судья, 2 судья, 3 судья, Хронометрист
    
    var person: IdRefObjectWrapper<Person>? // person id
    
    init(id: String, person: IdRefObjectWrapper<Person>?, type: rType?) {
        self.id = id
        self.person = person
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type
        case person
    }
    
    enum rType: String, Codable {
        case firstReferee
        case secondReferee
        case thirdReferee
        case timekeeper
    }
}

extension Referee {
    init() {
        id = ""
        type = nil
        person = nil
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Referee.self, from: data)
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
        type: rType? = nil,
        person: IdRefObjectWrapper<Person>? = nil
        ) -> Referee {
        return Referee(
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
