//
//  TeamPlayerInviteStatus.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct TeamPlayerInviteStatus: Codable {
    
    var id: String = ""
    
    var team: IdRefObjectWrapper<Team>? = nil
    var person: IdRefObjectWrapper<Person>? = nil
    
    var status: Status? = nil
    
    var v: Int? = nil
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        team = try container.decode(IdRefObjectWrapper<Team>.self, forKey: .team)
//        person = try container.decode(IdRefObjectWrapper<Person>.self, forKey: .person)
//        status = try! container.decode(Status.self, forKey: .status)
//    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case team
        case person
        
        case status
        
        case v = "__v"
    }
    
    enum Status: String {
        case pending = "pending"
        case accepted = "accepted"
        case rejected = "rejected"
        case blocked = "blocked"
        case canceled = "canceled"
        
        case undefined
        
        var ru: String {
            get {
                switch self {
                case .pending:
                    return "В ожидании"
                case .accepted:
                    return "Принято"
                case .rejected:
                    return "Откланено"
                case .blocked:
                    return "Заблокированно"
                case .canceled:
                    return "Отменено"
                case .undefined:
                    return "Bad"
                }
            }
        }
    }
}

extension TeamPlayerInviteStatus.Status: Codable {
    public init(from decoder: Decoder) throws {
        self = try TeamPlayerInviteStatus.Status(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .undefined
    }
}
