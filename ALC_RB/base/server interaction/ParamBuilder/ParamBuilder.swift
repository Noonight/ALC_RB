//
//  ParamBuilder.swift
//  ALC_RB
//
//  Created by mac on 12.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class ParamBuilder {
    
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
    
    func limit(_ value: Int = Constants.Values.LIMIT) -> Self {
        params[CRUDParamKeys.limit.str()] = String(value)
        return self
    }
    
    func offset(_ value: Int = 0) -> Self {
        params[CRUDParamKeys.offset.str()] = String(value)
        return self
    }
    
    // MARK: - SELECT
    
    func select(_ value: String) -> Self {
        params[CRUDParamKeys.select.str()] = String(value)
        return self
    }
    
    func select(_ builder: StringBuilder) -> Self {
        params[CRUDParamKeys.select.str()] = String(builder.getStr())
        return self
    }
    
    // MARK: - POPULATE
    
    func populate(_ value: String) -> Self {
        params[CRUDParamKeys.populate.str()] = String(value)
        return self
    }
    
    func populate(_ builder: StringBuilder) -> Self {
        params[CRUDParamKeys.populate.str()] = String(builder.getStr())
        return self
    }
    
    // MARK: - SORT
    
    func sort(_ value: String) -> Self {
        params[CRUDParamKeys.sort.str()] = String(value)
        return self
    }
    
    func sort(_ builder: StringBuilder) -> Self {
        params[CRUDParamKeys.sort.str()] = String(builder.getStr())
        return self
    }
    
    // MARK: - CUSTOM
    
    func add(key: String, value builder: StringBuilder) -> Self {
        params[key] = builder.getStr()
        return self
    }
    
    func add<T>(key: T, value builder: StringBuilder) -> Self where T : CodingKey {
        params[key.stringValue] = builder.getStr()
        return self
    }
    
    func add(key: String, value: String) -> Self {
        params[key] = value
        return self
    }
    
    // MARK: - END
    
    func get() -> [String: Any] {
        // POSSIBLE FAIL: - key of params cant be equal
        Print.m("Params: \(self.params)")
        return self.params
    }
    
}
