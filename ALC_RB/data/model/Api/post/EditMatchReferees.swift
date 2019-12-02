//
//  EditMatchReferee.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 29/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct EditMatchReferees: Codable {
    var id = "" // match id
    var referees = EditMatchReferees.Referees()
    
    init() {
        
    }
    
    init(id: String, referees: EditMatchReferees.Referees) {
        self.id = id
        self.referees = referees
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case referees = "referees"
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields.id.value() : self.id,
            Fields.referees.value() : self.referees.getArrayOfRefereesInDictionary()
        ]
    }
    
    enum Fields: String {
        case id = "_id"
        case referees = "referees"
        
        func value() -> String {
            return self.rawValue
        }
    }
    
    struct Referees: Codable {
        var referees: [EditMatchReferee]
        
        init() {
            referees = []
        }
        
        init(referees: [EditMatchReferee]) {
            self.referees = referees
        }
        
        enum CodingKeys: String, CodingKey {
            case referees = "referees"
        }
        
        func toDictionary() -> [String: Any] {
            var referees: [Any] = []
            for referee in self.referees {
                referees.append(referee.toDictionary())
            }
            return [
                CodingKeys.referees.rawValue : referees
            ]
        }
        
        func getArrayOfRefereesInDictionary() -> [Any] {
            var referees: [Any] = []
            for referee in self.referees {
                referees.append(referee.toDictionary())
            }
            return referees
        }
    }
}

struct EditMatchReferee: Codable {
    var type: Referee.rType // match id
    var person: String // person id
    
    init(type: Referee.rType, person: String) {
        self.type = type
        self.person = person
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields.type.value() : self.type.rawValue,
            Fields.person.value() : self.person
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case person = "person"
    }
    
    enum Fields: String {
        case type = "type"
        case person = "person"
        
        func value() -> String {
            return self.rawValue
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            CodingKeys.type.rawValue : type.rawValue,
            CodingKeys.person.rawValue : person
        ]
    }
}

extension EditMatchReferees.Referees {
    
    init(data: Data) throws {
        self =  try JSONDecoder().decode(EditMatchReferees.Referees.self, from: data)
    }
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        referees: [EditMatchReferee]? = nil
        ) -> EditMatchReferees.Referees {
        return EditMatchReferees.Referees(
            referees: referees ?? self.referees
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
