//
//  Enum + CK.swift
//  ALC_RB
//
//  Created by mac on 13.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension RawRepresentable where RawValue: CustomStringConvertible {
    var ck: String {
        return rawValue.description
    }
}
