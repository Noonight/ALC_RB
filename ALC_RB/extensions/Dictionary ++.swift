//
//  Dictionary ++.swift
//  ALC_RB
//
//  Created by ayur on 16.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension Dictionary where Key : CodingKey, Value == Any {
    
    func get() -> [String : Any] {
        var map = [String: Any]()
        self.forEach { key, value in
            map[key.stringValue] = value
        }
        return map
    }
    
}
