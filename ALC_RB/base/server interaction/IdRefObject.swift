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
        
        return try! JSONEncoder().encode(self)
//        return try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
//        return try
//        return data
    }
    
    static func fromData(data: Data?) -> IdRefObjectWrapper<T>? {
        if data == nil { return nil}
//        return NSKeyedUnarchiver.unarchiveObject(with: data!) as? IdRefObjectWrapper<T>
//        let lva = try! JSONDecoder().decode(IdRefObjectWrapper<T>.self, from: data!)
        return try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? IdRefObjectWrapper<T>
//        return lva
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
//        return nil
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
        //Print.m("Decode init Wrapper")
        var container = try! decoder.singleValueContainer()
//        //Print.m(container)
        do {
            self.value = try container.decode(IdRefObject<T>.self)
        } catch DecodingError.keyNotFound(let key, let context) {
            throw DecodingError.keyNotFound(key, context)
        } catch DecodingError.typeMismatch(let type, let context) {
            throw DecodingError.typeMismatch(type, context)
        } catch DecodingError.valueNotFound(let type, let context) {
            throw DecodingError.valueNotFound(type, context)
        } catch {
            throw DecodingError.typeMismatch(IdRefObjectWrapper.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "IdRefObjectWrapper: SEE CODE. Mb model has changed, or smth any"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        //Print.m("Encode Wrapper")
        var container = encoder.singleValueContainer()
//        var un = encoder.unkeyedContainer()
        
        do {
//            try un.encode(self.value)
            try container.encode(self.value)
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
        //Print.m("decode value")
        let container = try! decoder.singleValueContainer()
//        var container = try! decoder.unkeyedContainer()
//        let container = try decoder.container(keyedBy: Key)
//        if let id = try? container.decode(String.self) {
////            print("decode id")
//            //Print.m("Decode: id = \(id)")
//            self = .id(id)
//        } else if let object = try? container.decode(T.self) {
////            print("decode object")
//            //Print.m("Decode: object = \(object)")
//            self = .object(object)
//        } else {
//            // TEST: test wrapper object here
////            try! container.decode(T.self)
//            throw DecodingError.typeMismatch(IdRefObject.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
//        }
        do {
//            self = .id(try container.decode(String.self))
//            self = .object(try container.decode(T.self))
            if let id = try? container.decode(String.self) {
                self = .id(id)
            } else {
                self = .object(try container.decode(T.self))
            }
//            else if let object = try container.decode(T.self) {
//                self = .object(object)
//            }
        } catch DecodingError.keyNotFound(let key, let context) {
            throw DecodingError.keyNotFound(key, context)
        } catch DecodingError.typeMismatch(let type, let context) {
            throw DecodingError.typeMismatch(type, context)
        } catch DecodingError.valueNotFound(let type, let context) {
            throw DecodingError.valueNotFound(type, context)
        } catch {
            throw DecodingError.typeMismatch(IdRefObject.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "IdRefObject: Not a JSON"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        //Print.m("encode value")
//        var container = encoder.unkeyedContainer()
        var container = encoder.singleValueContainer()
        do {
            switch self {
            case .id(let id):
                //Print.m("Encode: id = \(id)")
                try container.encode(id)
            case .object(let object):
                //Print.m("Encode: object = \(object)")
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
