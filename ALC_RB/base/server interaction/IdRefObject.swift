//
//  IdRefObject.swift
//  ALC_RB
//
//  Created by mac on 07.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class IdRefObjectWrapper<T>: Codable where T : Codable {
    var value: IdRefObject<T>
    
    init(_ value: String) {
        self.value = IdRefObject<T>.id(value)
    }
    
    init(_ value: T) {
        self.value = IdRefObject<T>.object(value)
    }
    
    func toData() -> Data {
//        let data = try! JSONEncoder().encode(self)
//        let data = try! PropertyListEncoder().encode(self)
        
//        return NSKeyedArchiver.archivedData(withRootObject: self)
        return data
    }
    
    static func fromData(data: Data?) -> IdRefObjectWrapper<T>? {
        if data == nil { return nil}
//        return NSKeyedUnarchiver.unarchiveObject(with: data!) as? IdRefObjectWrapper<T>
        let lva = try! PropertyListDecoder().decode(IdRefObjectWrapper<T>.self, from: data!)
        return lva
    }
    
    func setValue(with value: IdRefObject<T>) {
        self.value = value
    }
    
    func getId() -> String? {
        switch self.value {
        case .id(let id):
            return id
        case .object:
            return nil
        }
    }
    
    func getValue() -> T? {
        switch self.value {
        case .id:
            return nil
        case .object(let obj):
            return obj
        }
        return nil
    }
    
    func map(_ set: (T) -> (T)) {
        switch self.value {
        case .id:
            assertionFailure("can't set object value with id")
        case .object(let obj):
            self.value = IdRefObject.object(set(obj))
        }
    }
    
    func isEqual(_ expression: (T) -> Bool) -> Bool {
        switch self.value {
        case .id:
            assertionFailure("use neighbour method")
        case .object(let obj):
            return expression(obj)
        }
        return false
    }
    
    func isEqual(_ expression: (String) -> Bool) -> Bool {
        switch self.value {
        case .id(let id):
            return expression(id)
        case .object:
            assertionFailure("use neighbour method")
        }
        return false
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.value = try container.decode(IdRefObject<T>.self)
        } catch {
            throw DecodingError.typeMismatch(IdRefObjectWrapper.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "SEE CODE. Mb model has changed, or smth any"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        do {
//            try container.encode(self.value)
            switch self.value {
            case .id(let id):
                try container.encode(id)
            case .object(let obj):
                try container.encode(obj)
            }
        } catch EncodingError.invalidValue(let any, let context) {
            throw EncodingError.invalidValue(any, context)
        } catch {
            throw EncodingError.invalidValue(IdRefObjectWrapper.self, EncodingError.Context(codingPath: [], debugDescription: "IdRefObjectWrapper not yet"))
        }
    }
}

extension IdRefObjectWrapper {
    
    func orEqual(_ fId: (String) -> (Bool), _ fObj: (T) -> Bool) -> Bool {
        var _id = false
        var _obj = false
        switch value {
        case .id(let id):
            _id = fId(id)
        case .object(let obj):
            _obj = fObj(obj)
        }
        if _id == true || _obj == true {
            return true
        }
//        if _id == false && _obj == false {
//            return false
//        }
        return false
    }
    
    func orEqual(_ fId: String, _ fObj: (T) -> Bool) -> Bool {
        var _id = false
        var _obj = false
        switch value {
        case .id(let id):
            if id == fId {
                _id = true
            }
        case .object(let obj):
            _obj = fObj(obj)
        }
        if _id == true || _obj == true {
            return true
        }
        //        if _id == false && _obj == false {
        //            return false
        //        }
        return false
    }
    
    func areEqual<T>(left: IdRefObjectWrapper<T>, right: IdRefObjectWrapper<T>, expression: (IdRefObjectWrapper<T>, IdRefObjectWrapper<T>) -> (Bool)) -> Bool {
        return expression(left, right)
    }
    
}

//extension IdRefObjectWrapper: RealmCollectionValue {
//    static func == (lhs: IdRefObjectWrapper<T>, rhs: IdRefObjectWrapper<T>) -> Bool {
//        if lhs.getId() == rhs.getId() {
//            return true
//        }
//        return false
//    }
//}

enum IdRefObject<T>: Codable where T : Codable {
    
    case id(String), object(T)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let id = try? container.decode(String.self) {
//            print("decode id")
            Print.m("id = \(id)")
            self = .id(id)
        } else if let object = try? container.decode(T.self) {
//            print("decode object")
            Print.m("object = \(object)")
            self = .object(object)
        } else {
            // TEST: test wrapper object here
//            try! container.decode(T.self)
            throw DecodingError.typeMismatch(IdRefObject.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        do {
            switch self {
            case .id(let id):
                try container.encode(id)
            case .object(let object):
                try container.encode(object)
            }
        } catch EncodingError.invalidValue(let any, let context) {
            throw EncodingError.invalidValue(any, context)
        } catch {
            throw EncodingError.invalidValue(IdRefObject.self, EncodingError.Context(codingPath: [], debugDescription: "IdRefObject error"))
        }
    }
}

//extension SingleValueEncodingContainer {
//
//    func encode<T>(_ type: T, value: T) throws where T: Encodable  {
//        self.encode(value, value: value)
//    }
//
//}
