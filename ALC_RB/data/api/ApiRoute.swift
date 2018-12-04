//
//  ApiRoutes.swift
//  ALC_RB
//
//  Created by user on 03.12.18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation

struct ApiRoute {
    
    static let baseRoute = "http://footballapi.ibb.su/"
    
    static func getApiURL(_ mod: Routes) -> URL {
        return URL(string: "\(baseRoute)api/\(mod)")!
    }
    
    static func getImageURL(image: String) -> URL {
        return URL(string: "\(baseRoute)\(image)")!
    }
}

enum Routes: String {
    case news = "news"
    case announce = "announce"
    case ads = "ads"
}
