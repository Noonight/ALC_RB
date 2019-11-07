//
//  IdRefObject.swift
//  ALC_RB
//
//  Created by mac on 07.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

public enum IdRefObject<T: Codable>: Codable {
    case id(String)
    case object(T)
    case arrObject([T])
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
//        self = try ((try? container.decode(String.self)).map(IdRefObject.id)
//            .or((try? container.decode(T.self)).map(IdRefObject.object))
//            .or((try? container.decode([T].self)).map(IdRefObject.arrObject))
//            .resolve(with: DecodingError.typeMismatch(IdRefObject.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))))
        
        if let value = try? container.decode(String.self) {
            self = .id(value)
        }
        else
        if let value = try? container.decode(T.self) {
            self = .object(value)
        }
        else
        if let value = try? container.decode([T].self) {
            self = .arrObject(value)
        }
        else
        {
            throw DecodingError.typeMismatch(IdRefObject.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        throw EncodingError.invalidValue(IdRefObject.self, EncodingError.Context(codingPath: [], debugDescription: "not supported yet"))
    }
}

fileprivate extension Optional {
    func or(_ other: Optional) -> Optional {
        switch self {
        case .none: return other
        case .some: return self
        }
    }
    
    func resolve(with error: @autoclosure () -> Error) throws -> Wrapped {
        switch self {
        case .none: throw error()
        case .some(let wrapped): return wrapped
        }
    }
}
