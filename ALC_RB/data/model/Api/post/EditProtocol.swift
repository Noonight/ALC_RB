//
//  EditProtocol.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 09/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct EditProtocol: Codable {
    var id = "" // match id
    var events = EditProtocol.Events()
//    var playersList: [String] = []
    
    init() {}
    
    init(id: String, events: EditProtocol.Events/*, playersList: [String]*/) {
        self.id = id
        self.events = events
//        self.playersList = playersList
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case events = "events"
//        case playersList = "playersList"
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields.id.value() : self.id,
            Fields.events.value() : self.events.getArrayOfEventsInDictionary()//,
//            Fields.playersList.value() : self.playersList
        ]
    }
    
    enum Fields: String {
        case id = "_id"
        case events = "events"
//        case playersList = "playersList"
        
        func value() -> String {
            return self.rawValue
        }
    }
    
    struct Events: Codable {
        var events: [Event]
        
        init() {
            events = []
        }
        
        init(events: [Event]) {
            self.events = events
        }
        
        enum CodingKeys: String, CodingKey {
            case events = "events"
        }
        
//        func toDictionary() -> [String: Any] {
//            var events: [Any] = []
//            for event in self.events {
//                events.append(event.toDictionary())
//            }
//            return [CodingKeys.events.rawValue : events]
//        }
        
        func getArrayOfEventsInDictionary() -> [Any] {
            var events: [Any] = []
            for event in self.events {
                events.append(event.toDictionary())
            }
            return events
        }
    }
}
