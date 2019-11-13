//
//  _Person.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 18.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct _Person: Codable {
    let surname: String?
    let name: String?
    let lastname: String?
    let birthdate: String?
    let photo: String?
    let desc: String?
    let participationMatches: [_Match]?
    let pastLeagues: [_PastLeague]?
    let id: String?
    let login: String?
    let password: String?
    let type: String?
    let pendingTeamInvites: [_PendingTeamInvite]?
    let participation: [_Participation]?
    let createdAt: Date?
    let updatedAt: Date?
    let v: Int?
    let club: String?
    let region: String?
    
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
        case region = "region"
    }
}
