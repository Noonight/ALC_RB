//
//  ParamBuilder.swift
//  ALC_RB
//
//  Created by mac on 12.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class ParamBuilder<T> where T: CodingKey {
    
    enum CRUDParamKeys: String {
        case limit = "_limit"
        case offset = "_offset"
        case select = "_select"
        case populate = "_populate"
        case sort = "_sort"
        
        func str() -> String {
            return self.rawValue
        }
    }
    
    private var params = [String:Any]()
    
    
    init() { }
    
    func limit(_ value: Int? = Constants.Values.LIMIT) -> Self {
        if value != nil {
            params[CRUDParamKeys.limit.str()] = String(value!)
        }
        return self
    }
    
    func offset(_ value: Int? = 0) -> Self {
        if value != nil {
            params[CRUDParamKeys.offset.str()] = String(value!)
        }
        return self
    }
    
    // MARK: - SELECT
    
    func select(_ value: String?) -> Self {
        if value != nil {
            params[CRUDParamKeys.select.str()] = String(value!)
        }
        return self
    }
    
    func select(_ builder: StrBuilder<T>) -> Self {
        params[CRUDParamKeys.select.str()] = String(builder.getStr())
        return self
    }
    
    // MARK: - POPULATE
    
    func populate(_ value: String?) -> Self {
        if value != nil {
            params[CRUDParamKeys.populate.str()] = String(value!)
        }
        return self
    }
    
    func populate(_ value: T?) -> Self {
        if value != nil {
            params[CRUDParamKeys.populate.str()] = value!.stringValue
        }
        return self
    }
    
    func populate(_ builder: StrBuilder<T>) -> Self {
        params[CRUDParamKeys.populate.str()] = String(builder.getStr())
        return self
    }
    
    // MARK: - SORT
    
    func sort(_ value: String?) -> Self {
        if value != nil {
            params[CRUDParamKeys.sort.str()] = String(value!)
        }
        return self
    }
    
    func sort(_ builder: StrBuilder<T>) -> Self {
        params[CRUDParamKeys.sort.str()] = String(builder.getStr())
        return self
    }
    
    // MARK: - CUSTOM
    
    func add(key: T, value: Bool?) -> Self {
        if value != nil {
            params[key.stringValue] = String(value!)
        }
        return self
    }
    
    func add(key: String, value: Bool?) -> Self {
        if value != nil {
            params[key] = String(value!)
        }
        return self
    }
    
    func add(key: String, value builder: StrBuilder<T>) -> Self {
        if builder.getStr().isEmpty == false {
            params[key] = builder.getStr()
        }
        return self
    }
    
    func add<U>(_ type: U.Type, key: String, value builder: StrBuilder<U>) -> Self where U : CodingKey {
        if builder.getStr().isEmpty == false {
            params[key] = builder.getStr()
        }
        return self
    }
    
    func add<U>(_ type: U.Type, key: U, value: String?) -> Self where U : CodingKey {
        if value != nil {
            params[key.stringValue] = value!
        }
        return self
    }
    
    func add<U>(_ type: U.Type, key: U, value: U?) -> Self where U : CodingKey {
        if value != nil {
            params[key.stringValue] = value!.stringValue
        }
        return self
    }
    
    func add(key: T, value builder: StrBuilder<T>) -> Self {
        if builder.getStr().isEmpty == false {
            params[key.stringValue] = builder.getStr()
        }
        return self
    }
    
    func add(key: T, value: String?) -> Self {
        if value != nil {
            params[key.stringValue] = value!
        }
        return self
    }
    
//    func add<U>(key: U, value builder: StringBuilder<U>) -> Self where U : CodingKey {
//        params[key.stringValue] = builder.getStr()
//        return self
//    }
    
    func add(key: String, value: String?) -> Self {
        if value != nil {
            params[key] = value!
        }
        return self
    }
    
    // MARK: - END
    
    func get() -> [String: Any] {
        // POSSIBLE FAIL: - key of params cant be equal
        Print.m("Params: \(self.params)")
        return self.params
    }
    
}
