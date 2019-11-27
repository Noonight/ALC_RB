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
    
    func getFullName() -> String {
        let fullName = "\(surname ?? "") \(name ?? "") \(lastname ?? "")"
        if (fullName.count > 0) {
            return fullName
        }
        return "Не указано"
    }
    
    // Surname, First Name, First Patronymic
    func getSurnameNP() -> String {
        let emptyChar = Character(" ")
        let surnameNP = "\(surname ?? "") \(name?.first ?? emptyChar) \(lastname?.first ?? emptyChar)"
        if (surnameNP.count > 4) {
            return surnameNP
        }
        return "Не указано"
    }
}

extension Person {
    
    init() {
        
        id = ""
        
        region = nil
        surname = nil
        name = nil
        lastname = nil
        birthdate = nil
        photo = nil
        
        login = nil
        password = nil
        
        createdAt = nil
        updatedAt = nil
        v = nil
        
        favoriteTourney = nil
    }
    
    func getDicitionary() -> [String : Any] {
        var d = [CodingKeys : Any]()
        d[.id] = id
        d[.region] = region?.getId() ?? region?.getValue()?.id
        d[.surname] = surname
        d[.name] = name
        d[.lastname] = lastname
        d[.birthdate] = birthdate
        d[.photo] = photo
        d[.login] = login
        d[.password] = password
        d[.favoriteTourney] = favoriteTourney?.map { $0.getId() }
        
        return d.get()
    }
    
    func with(
        
        id: String? = nil,
        
        surname: String? = nil,
        name: String? = nil,
        lastname: String? = nil,
        birthdate: Date? = nil,
        photo: String?? = nil,
        
        login: String? = nil,
        password: String? = nil,
        
        favoriteTourney: [IdRefObjectWrapper<Tourney>]? = nil,
        
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        v: Int? = nil
        
        ) -> Person {
        var person = Person()
        
        person.id = id ?? self.id
        
        person.surname = surname ?? self.surname
        person.name = name ?? self.name
        person.lastname = lastname ?? self.lastname
        person.birthdate = birthdate ?? self.birthdate
        person.photo = photo ?? self.photo
        
        person.login = login ?? self.login
        person.password = password ?? self.password
        
        person.favoriteTourney = favoriteTourney ?? self.favoriteTourney
        
        person.createdAt = createdAt ?? self.createdAt
        person.updatedAt = updatedAt ?? self.updatedAt
        person.v = v ?? self.v
        
        
        return person
    }
}
