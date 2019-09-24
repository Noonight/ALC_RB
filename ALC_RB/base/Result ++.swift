//
//  Result ++.swift
//  ALC_RB
//
//  Created by mac on 22.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

enum ResultMy<T, ErrorType> {
    case success(T)
    case message(SingleLineMessage)
    case failure(ErrorType)
}

enum RequestError: Error {
    // universal
    case alamofire(Error)
    // server 500 ++
    case server(Error)
    // local 400 ++
    case local(Error)
}
