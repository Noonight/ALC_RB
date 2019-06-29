//
//  EditMatchReferee.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 29/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct EditMatchReferees {
    var id = "" // match id
    var referees: [EditMatchReferee] = []
    
    init(id: String, referees: [EditMatchReferee]) {
        self.id = id
        self.referees = referees
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields.id.value() : self.id,
            Fields.referees.value() : self.referees
        ]
    }
    
    enum Fields: String {
        case id = "_id"
        case referees = "referees"
        
        func value() -> String {
            return self.rawValue
        }
    }
}

struct EditMatchReferee {
    var type = "" // match id
    var person = ""
    
    init(type: String, person: String) {
        self.type = type
        self.person = person
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields.type.value() : self.type,
            Fields.person.value() : self.person
        ]
    }
    
    enum Fields: String {
        case type = "type"
        case person = "person"
        
        func value() -> String {
            return self.rawValue
        }
    }
}
