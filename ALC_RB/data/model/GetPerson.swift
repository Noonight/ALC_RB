//
//  GetPerson.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 03/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

struct GetPerson: Codable {
    let person: GetPerson.Person?
    
    enum CodingKeys: String, CodingKey {
        case person = "person"
    }
    
    struct Person: Codable {
        var surname: String
        var name: String
        var lastname: String
        var birthdate: String
        var photo: String?
        var desc: String
        var participationMatches: [String]
        var pastLeagues: [PastLeague]
        var id: String
        var login: String
        var password: String
        var type: String
        var pendingTeamInvites: [PendingTeamInvite]
        var participation: [Participation]
        var createdAt: String
        var updatedAt: String
        var v: Int
        var club: String?
        
        enum TypeOfPerson: String {
            case player = "player"
            case referee = "referee"
            case mainReferee = "mainReferee"
            case notFind = "error type"
        }
        
        enum CodingKeys: String, CodingKey {
            case surname = "surname"
            case name = "name"
            case lastname = "lastname"
            case birthdate = "birthdate"
            case photo = "photo"
            case desc = "desc"
            case participationMatches = "participationMatches"
            case pastLeagues = "pastLeagues"
            case id = "_id"
            case login = "login"
            case password = "password"
            case type = "type"
            case pendingTeamInvites = "pendingTeamInvites"
            case participation = "participation"
            case createdAt = "createdAt"
            case updatedAt = "updatedAt"
            case v = "__v"
            case club = "club"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.surname = try container.decodeIfPresent(String.self, forKey: .surname) ?? ""
            self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
            self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname) ?? ""
            self.birthdate = try container.decodeIfPresent(String.self, forKey: .birthdate) ?? ""
            self.photo = try container.decodeIfPresent(String.self, forKey: .photo) ?? ""
            self.desc = try container.decodeIfPresent(String.self, forKey: .desc) ?? ""
            self.participationMatches = try container.decodeIfPresent([String].self, forKey: .participationMatches) ?? []
            self.pastLeagues = try container.decodeIfPresent([PastLeague].self, forKey: .pastLeagues) ?? []
            self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
            self.login = try container.decodeIfPresent(String.self, forKey: .login) ?? ""
            self.password = try container.decodeIfPresent(String.self, forKey: .password) ?? ""
            self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
            self.pendingTeamInvites = try container.decodeIfPresent([PendingTeamInvite].self, forKey: .pendingTeamInvites) ?? []
            self.participation = try container.decodeIfPresent([Participation].self, forKey: .participation) ?? []
            self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
            self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
            self.v = try container.decodeIfPresent(Int.self, forKey: .v) ?? -1
            self.club = try container.decodeIfPresent(String.self, forKey: .club) ?? ""
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
        
        struct PastLeague: Codable {
            
            var _id: String
            var name: String
            var tourney: String
            var teamName: String
            var place: String
            var id: String
            
            enum CodingKeys: String, CodingKey {
                case _id = "_id"
                case name = "name"
                case tourney = "tourney"
                case teamName = "teamName"
                case place = "place"
                case id = "id"
            }
            
            init() {
                _id = ""
                name = ""
                tourney = ""
                teamName = ""
                place = ""
                id = ""
            }
            
            init(_id: String, name: String, tourney: String, teamName: String, place: String, id: String) {
                self._id = _id
                self.name = name
                self.tourney = tourney
                self.teamName = teamName
                self.place = place
                self.id = id
            }
            
            init(data: Data) throws {
                self = try newJSONDecoder().decode(PastLeague.self, from: data)
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
                _id: String? = nil,
                name: String? = nil,
                tourney: String? = nil,
                teamName: String? = nil,
                place: String? = nil,
                id: String? = nil
                ) -> PastLeague {
                return PastLeague(
                    _id: _id ?? self._id,
                    name: name ?? self.name,
                    tourney: tourney ?? self.tourney,
                    teamName: teamName ?? self.teamName,
                    place: place ?? self.place,
                    id: id ?? self.id
                )
            }
            
            func jsonData() throws -> Data {
                return try newJSONEncoder().encode(self)
            }
            
            func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
                return String(data: try self.jsonData(), encoding: encoding)
            }
        }

    }
    
    struct PastLeague: Codable {
        
        var name: String
        var tourney: String
        var teamName: String
        var place: String
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case tourney = "tourney"
            case teamName = "teamName"
            case place = "place"
        }
        
        init() {
            name = ""
            tourney = ""
            teamName = ""
            place = ""
        }
        
        init(name: String, tourney: String, teamName: String, place: String) {
            self.name = name
            self.tourney = tourney
            self.teamName = teamName
            self.place = place
        }
        
        init(data: Data) throws {
            self = try newJSONDecoder().decode(PastLeague.self, from: data)
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
            name: String? = nil,
            tourney: String? = nil,
            teamName: String? = nil,
            place: String? = nil
            ) -> PastLeague {
            return PastLeague(
                name: name ?? self.name,
                tourney: tourney ?? self.tourney,
                teamName: teamName ?? self.teamName,
                place: place ?? self.place
            )
        }
        
        func jsonData() throws -> Data {
            return try newJSONEncoder().encode(self)
        }
        
        func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
            return String(data: try self.jsonData(), encoding: encoding)
        }
    }

}

extension GetPerson {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GetPerson.self, from: data)
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
        person: GetPerson.Person?? = nil
        ) -> GetPerson {
        return GetPerson(
            person: person ?? self.person
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension GetPerson.Person {
    
    init() {
        surname = ""
        name = ""
        lastname = ""
        birthdate = ""
        photo = ""
        desc = ""
        participationMatches = []
        pastLeagues = []
        id = ""
        login = ""
        password = ""
        type = ""
        pendingTeamInvites = []
        participation = []
        createdAt = ""
        updatedAt = ""
        v = -1
        club = ""
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GetPerson.Person.self, from: data)
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
        birthdate: String? = nil,
        photo: String?? = nil,
        desc: String? = nil,
        participationMatches: [String]? = nil,
        pastLeagues: [GetPerson.Person.PastLeague]? = nil,
        id: String? = nil,
        login: String? = nil,
        password: String? = nil,
        type: String? = nil,
        pendingTeamInvites: [PendingTeamInvite]? = nil,
        participation: [Participation]? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        v: Int? = nil,
        club: String?? = nil
        ) -> GetPerson.Person {
        var person = GetPerson.Person()
        person.surname = surname ?? self.surname
        person.name = name ?? self.name
        person.lastname = lastname ?? self.lastname
        person.birthdate = birthdate ?? self.birthdate
        person.photo = photo ?? self.photo
        person.desc = desc ?? self.desc
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
        
        return person
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

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
    func responseGetPerson(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<GetPerson>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
