//
//  Person.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 15.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Person: Codable {
    
    var id: String
    
    var region: IdRefObjectWrapper<RegionMy>?
    var surname: String?
    var name: String?
    var lastname: String?
    
    var login: String?
    var birthdate: Date?
    var password: String?
    
    var photo: String?
    
    var favoriteTourney: [IdRefObjectWrapper<Tourney>]?
    
    var createdAt: Date?
    var updatedAt: Date?
    var v: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        
        case region = "region"
        case surname = "surname"
        case name = "name"
        case lastname = "lastname"
        
        case login = "login"
        case birthdate = "birthdate"
        case password = "password"
        
        case photo = "photo"
        
        case favoriteTourney = "favoriteTourney"
        
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        
        case v = "__v"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
            
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        
        self.region = try container.decodeIfPresent(IdRefObjectWrapper<RegionMy>.self, forKey: .region) ?? nil
        self.surname = try container.decodeIfPresent(String.self, forKey: .surname) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname) ?? ""
        
        self.login = try container.decodeIfPresent(String.self, forKey: .login) ?? ""
        self.birthdate = try container.decodeIfPresent(Date.self, forKey: .birthdate) ?? Date()
        self.password = try container.decodeIfPresent(String.self, forKey: .password) ?? ""
        
        self.photo = try container.decodeIfPresent(String.self, forKey: .photo) ?? ""
        
        self.favoriteTourney = try container.decodeIfPresent([String].self, forKey: .favoriteTourney) ?? []
        
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? Date()
        
        self.v = try container.decodeIfPresent(Int.self, forKey: .v) ?? -1
    }
    
    func compareFullName(with fullName: String) -> Bool {
        return fullName.lowercased() == getFullName().lowercased()
    }
    
    func getFullName() -> String {
        let fullName = "\(surname) \(name) \(lastname)"
        if (fullName.count > 0) {
            return fullName
        }
        return "Не указано"
    }
    
    // Surname, First Name, First Patronymic
    func getSurnameNP() -> String {
        let emptyChar = Character(" ")
        let surnameNP = "\(surname) \(name.first ?? emptyChar) \(lastname.first ?? emptyChar)"
        if (surnameNP.count > 4) {
            return surnameNP
        }
        return "Не указано"
    }
    
    func getUserType() -> TypeOfPerson {
        if type == TypeOfPerson.player.rawValue {
            return TypeOfPerson.player
        }
        if type == TypeOfPerson.referee.rawValue {
            return TypeOfPerson.referee
        }
        if type == TypeOfPerson.mainReferee.rawValue {
            return TypeOfPerson.mainReferee
        }
        return TypeOfPerson.notFind
    }
}

extension Person {
    
    init() {
        surname = ""
        name = ""
        lastname = ""
        birthdate = Date()
        photo = ""
//        desc = ""
        participationMatches = nil
        pastLeagues = []
        id = ""
        login = ""
        password = ""
        type = ""
        pendingTeamInvites = []
        participation = []
        createdAt = Date()
        updatedAt = Date()
        v = -1
        club = ""
        region = ""
        favoriteTourney = []
    }
    
    init(data: Data) throws {
        self = try ISO8601Decoder.getDecoder().decode(Person.self, from: data)
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
        surname: String? = nil,
        name: String? = nil,
        lastname: String? = nil,
        birthdate: Date? = nil,
        photo: String?? = nil,
//        desc: String? = nil,
//        participationMatches: [Match]? = nil,
        participationMatches: [IdRefObjectWrapper<Match>]? = nil,
        pastLeagues: [PastLeague]? = nil,
        id: String? = nil,
        login: String? = nil,
        password: String? = nil,
        type: String? = nil,
        pendingTeamInvites: [PendingTeamInvite]? = nil,
        participation: [Participation]? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        v: Int? = nil,
        club: String?? = nil,
        favoriteTourney: [String]? = nil
        ) -> Person {
        var person = Person()
        person.surname = surname ?? self.surname
        person.name = name ?? self.name
        person.lastname = lastname ?? self.lastname
        person.birthdate = birthdate ?? self.birthdate
        person.photo = photo ?? self.photo
//        person.desc = desc ?? self.desc
        person.participationMatches = participationMatches ?? self.participationMatches
        person.pastLeagues = pastLeagues ?? self.pastLeagues
        person.id = id ?? self.id
        person.login = login ?? self.login
        person.password = password ?? self.password
        person.type = type ?? self.type
        person.pendingTeamInvites = pendingTeamInvites ?? self.pendingTeamInvites
        person.participation = participation ?? self.participation
        person.createdAt = createdAt ?? self.createdAt
        person.updatedAt = updatedAt ?? self.updatedAt
        person.v = v ?? self.v
        person.club = club ?? self.club
        person.favoriteTourney = favoriteTourney ?? self.favoriteTourney
        
        return person
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
