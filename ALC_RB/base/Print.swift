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
//    static func d(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
//        let className = (file as NSString).lastPathComponent
//        debugPrint("\(className) -> \(function) -> \(line) :: -> :: \(message)")
//    }
//
//    // debug
//    static func d(_ message: Error, file: String = #file.components(separatedBy: "/").last ?? "", function: String = #function, line: Int = #line) {
//        debugPrint("\(file) -> \(function) -> \(line) :: -> :: \(message)")
//    }
    
    // location
    static func l(file: String = #file.components(separatedBy: "/").last ?? "", function: String = #function, line: Int = #line) {
        print("\(file) -> \(function) -> \(line)")
    }
 
    public static func debugLog(object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(object)\n")
        #endif
    }
    
    public static func d(object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(object)\n")
        #endif
    }
    
    public static func d(message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(message)\n")
        #endif
    }
    
    public static func d(error: Error, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(error)\n")
        #endif
    }
    
    public static func m(_ m: Any? = nil, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        if let mm = m {
            print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(mm)\n")
        } else {
            print("<\(className)> ->> \(functionName) [#\(lineNumber)]|\n")
        }
        #endif
    }
    
    public static func j(_ j: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(String(data: try! JSONSerialization.data(withJSONObject: j, options: .prettyPrinted), encoding: .utf8)!)\n")
        #endif
    }}
