//
//  Date ++.swift
//  ALC_RB
//
//  Created by mac on 14.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension Date {
    func toFormat(_ format: DateFormats) -> String {
        return self.toFormat(format.ck)
    }
}
