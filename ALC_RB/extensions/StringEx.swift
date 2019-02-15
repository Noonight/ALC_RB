//
//  StringEx.swift
//  ALC_RB
//
//  Created by ayur on 15.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

public extension String {
    func isNumber() -> Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil && self.rangeOfCharacter(from: CharacterSet.letters) == nil
    }
}
