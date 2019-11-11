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
    
    func setValue(with value: IdRefObject<T>) {
        self.value = value
    }
    
    func getValue() -> T? {
        switch self.value {
        case .id:
            assertionFailure("can't get object of id")
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
            try container.encode(self.value)
        } catch {
            throw EncodingError.invalidValue(IdRefObjectWrapper.self, EncodingError.Context(codingPath: [], debugDescription: "not supported yet"))
        }
    }
}

enum IdRefObject<T>: Codable where T : Codable {
    
    case id(String), object(T)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let id = try? container.decode(String.self) {
            print("try decode id")
            self = .id(id)
        } else if let object = try? container.decode(T.self) {
            print("try decode object")
            self = .object(object)
        } else {
            throw DecodingError.typeMismatch(IdRefObject.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .id(let id):
            try container.encode(id)
        case .object(let object):
            try container.encode(object)
        }
        throw EncodingError.invalidValue(IdRefObject.self, EncodingError.Context(codingPath: [], debugDescription: "not supported yet"))
    }
}
