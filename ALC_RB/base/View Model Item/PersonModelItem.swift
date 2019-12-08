//
//  PersonModelItem.swift
//  ALC_RB
//
//  Created by ayur on 28.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class PersonModelItem {
    
    var person: Person
    
    init(person: Person) {
        self.person = person
    }
    
    var name: String? {
        return person.name
    }
    
    var fullName: String? {
        return person.getFullName()
    }
    
    var fullNameNP: String? {
        return person.getSurnameNP()
    }
    
    var age: String? {
        guard let birthdate = person.birthdate else { return nil }
        return String(Date().year - birthdate.year)
    }
    
    var birthDate: String? {
        guard let birthdate = person.birthdate else { return nil }
        return birthdate.toFormat(.local)
    }
    
    var birthTime: String? {
        guard let birthdate = person.birthdate else { return nil }
        return birthdate.toFormat(.localTime)
    }
    
    var photoPath: String? {
        return person.photo
    }
    
}
