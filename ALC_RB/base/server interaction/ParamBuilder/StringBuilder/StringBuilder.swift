//
//  SpaceStringBuilder.swift
//  ALC_RB
//
//  Created by mac on 12.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class StringBuilder {
    
    enum Mode: String {
        case result // array
        case realtime // str
    }
    
    enum SeparatorMode: String {
        case automatically // add separator after every word automatically, but it is possible to add separator independently
        case independently // add spearator independently
    }
    
    enum Separator: String {
        case space = " "
        case comma = ","
        case dot = "."
        case moreThan = ">"
        case lessThan = "<"
        case moreEqualThan = ">="
        case lessEqualThan = "<="
        case notEqual = "!"
    }
    
    private var str = String()
    private var resultArray = [String]()
    private var separatorStyle: Separator = .space
    private var separatorMode: SeparatorMode = .automatically
    private var mode: Mode = .realtime
    
    init(mode: Mode) {
        self.mode = mode
    }
    
    // setting mode change behaviour after already added strings
    func setMode(_ newMode: SeparatorMode) -> Self {
        separatorMode = newMode
        return self
    }
    
    func setSeparator(_ separator: Separator) -> Self {
        separatorStyle = separator
        return self
    }
    
    func add(_ str: String) -> Self {
        switch mode {
        case .result:
            if separatorMode == .automatically {
                self.resultArray.append(str)
                self.resultArray.append(separatorStyle.rawValue)
            } else {
                self.resultArray.append(str)
            }
        case .realtime:
            if separatorMode == .automatically {
                self.str += str + separatorStyle.rawValue
            } else {
                self.str += str
            }
        }
        return self
    }
    
    func add<T>(_ value: T) -> Self where T: CodingKey {
        switch mode {
        case .result:
            if separatorMode == .automatically {
                self.resultArray.append(value.stringValue)
                self.resultArray.append(separatorStyle.rawValue)
            } else {
                self.resultArray.append(value.stringValue)
            }
        case .realtime:
            if separatorMode == .automatically {
                self.str += value.stringValue + separatorStyle.rawValue
            } else {
                self.str += value.stringValue
            }
        }
        
        return self
    }
    
    func add(_ separator: Separator) -> Self {
        switch mode {
        case .result:
            self.resultArray.append(separator.rawValue)
        case .realtime:
            self.str += separator.rawValue
        }
        return self
    }
    
    func getStr() -> String {
        switch mode {
        case .result:
            for i in resultArray {
                var tmpStr = String()
                tmpStr += i
                return tmpStr
            }
        case .realtime:
            if str.last == " " {
                self.str.removeLast()
            }
            return self.str
        }
        assertionFailure("Switch is not executed")
        return ""
    }
}
