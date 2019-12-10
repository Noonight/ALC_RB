//
//  Request + Log it.swift
//  ALC_RB
//
//  Created by ayur on 03.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Alamofire

extension Request {
    
    func logURL(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> Self {
        
        if let url = self.request?.urlRequest.debugDescription {
            #if DEBUG
            let className = (fileName as NSString).lastPathComponent
            print("<\(className)> ->> \(functionName) [#\(lineNumber)]| REQUEST URL: \(url)\n")
            #endif
        }
        
        return self
    }
    
    func logBody(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> Self {
        
        if let requestBody = self.request?.httpBody {
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: requestBody, options: [])
                #if DEBUG
                let className = (fileName as NSString).lastPathComponent
                print("<\(className)> ->> \(functionName) [#\(lineNumber)]| REQUEST BODY: \(jsonArray)\n")
                #endif
            }
            catch {
                #if DEBUG
                let className = (fileName as NSString).lastPathComponent
                print("<\(className)> ->> \(functionName) [#\(lineNumber)]| REQUEST BODY(ERROR): \(error)\n")
                #endif
            }
        }
        
        return self
    }
    
}
