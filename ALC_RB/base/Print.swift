//
//  Print.swift
//  ALC_RB
//
//  Created by ayur on 03.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

class Print {
    
    // debug
    static func d(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        debugPrint("\(file) -> \(function) -> \(line) :: -> :: \(message)")
    }
    
    // debug
    static func d(_ message: Error, file: String = #file, function: String = #function, line: Int = #line) {
        debugPrint("\(file) -> \(function) -> \(line) :: -> :: \(message)")
    }
    
    // location
    static func l(file: String = #file, function: String = #function, line: Int = #line) {
        print("\(file) -> \(function) -> \(line)")
    }
    
}
