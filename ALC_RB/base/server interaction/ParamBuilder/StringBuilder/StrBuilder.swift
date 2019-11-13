//
//  SpaceStringBuilder.swift
//  ALC_RB
//
//  Created by mac on 12.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

//enum StringBuilderWrapper {
//    case result
//    case realtime
//
////    private var _builder: StringBuilder? {
////        get {
////            return self._builder
////        }
////        set(newValue) {
////            _builder = newValue
////        }
////    }
//    private var builder: StringBuilder? {
//        get {
//            return self.builder
//        }
//        set(newValue) {
//            builder = newValue
//        }
//    }
//
//    init() {
//        builder = self.i
//    }
//
//    // instance
//    var i: StringBuilder {
//        if self.builder != nil {
//            return self.builder!
//        }
//        switch self {
//        case .realtime: return StringBuilder(mode: .realtime)
//        case .result: return StringBuilder(mode: .result)
//        }
//    }
//}

class StrBuilder<T> where T: CodingKey {
    
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
    
    private var resultArray = [String]()
    private var separatorStyle: Separator = .space
    private var separatorMode: SeparatorMode = .automatically
    
    init() { }
    
    
    // setting mode change behaviour after already added strings
    func setSeparatorMode(_ newMode: SeparatorMode) -> Self {
        separatorMode = newMode
        return self
    }
    
    func setSeparatorStyle(_ separator: Separator) -> Self {
        separatorStyle = separator
        return self
    }
    
    func add(_ str: String?) -> Self {
        if str != nil {
            if separatorMode == .automatically {
                self.resultArray.append(str!)
                self.resultArray.append(separatorStyle.rawValue)
            } else {
                self.resultArray.append(str!)
            }
        }
        
        return self
    }
    
    func add(_ ids: [String]?) -> Self {
        if ids != nil {
            if separatorMode == .automatically {
                for id in ids! {
                    self.resultArray.append(id)
                    self.resultArray.append(separatorStyle.ck)
                }
            } else {
                for id in ids! {
                    self.resultArray.append(id)
                }
            }
        }
    }
    
    func add<U>(_ type: U.Type,_ cks: [U]?) -> Self where U: CodingKey {
        if cks != nil {
            if separatorMode == .automatically {
                for ck in cks! {
                    self.resultArray.append(ck.stringValue)
                    self.resultArray.append(separatorStyle.ck)
                }
            } else {
                for ck in cks! {
                    self.resultArray.append(ck.stringValue)
                }
            }
        }
    }
    
    func add<U>(_ type: U.Type,_ value: U) -> Self where U: CodingKey {
        if separatorMode == .automatically {
            self.resultArray.append(value.stringValue)
            self.resultArray.append(separatorStyle.rawValue)
        } else {
            self.resultArray.append(value.stringValue)
        }
        
        return self
    }
    
    func add(_ value: T) -> Self {
        if separatorMode == .automatically {
            self.resultArray.append(value.stringValue)
            self.resultArray.append(separatorStyle.rawValue)
        } else {
            self.resultArray.append(value.stringValue)
        }
        
        return self
    }
    
    func add(_ cks: [T]?) -> Self {
        if cks != nil {
            if separatorMode == .automatically {
                for ck in cks! {
                    self.resultArray.append(ck.stringValue)
                    self.resultArray.append(separatorStyle.ck)
                }
            } else {
                for ck in cks! {
                    self.resultArray.append(ck.stringValue)
                }
            }
        }
    }
    
    func add(_ separator: Separator) -> Self {
        self.resultArray.append(separator.rawValue)
        
        return self
    }
    
    func getStr() -> String {
        var tmpStr = String()
        removeLastSeparator()
        for i in resultArray {
            tmpStr += i
        }
        return tmpStr
    }
}

// MARK: HELPERS

extension StrBuilder {
    
    private func removeLastSeparator() {
        if resultArray.last == Separator.comma.ck ||
            resultArray.last == Separator.dot.ck ||
            resultArray.last == Separator.space.ck ||
            resultArray.last == Separator.moreThan.ck ||
            resultArray.last == Separator.moreEqualThan.ck ||
            resultArray.last == Separator.lessThan.ck ||
            resultArray.last == Separator.lessEqualThan.ck ||
            resultArray.last == Separator.notEqual.ck
        {
            resultArray.removeLast()
        }
    }
    
}
