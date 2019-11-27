//
//  Encodable + Dictionary.swift
//  ALC_RB
//
//  Created by ayur on 27.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
