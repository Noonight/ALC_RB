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
    
    static func getApiURL(_ mod: Routes, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> URL {
        #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(baseRoute)api/\(mod.rawValue)\n")
        #endif
        return URL(string: "\(baseRoute)api/\(mod.rawValue)")!
    }
    
    static func getApiLeagueURL(_ id: String) -> URL {
        return URL(string: "\(baseRoute)api/\(Routes.leagueInfo.rawValue)/\(id)")!
    }
    
    static func getImageURL(image: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> URL {
        #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(baseRoute)\(image)\n")
        #endif
        return URL(string: "\(baseRoute)\(image)")!
    }

    
    static func getApiURL(_ mod: Routes, id: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> URL {
        #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(baseRoute)api/\(mod.rawValue)/\(id)\n")
        #endif
        return URL(string: "\(baseRoute)api/\(mod.rawValue)/\(id)")!
    }
}

enum Routes: String {
    case news = "news"
    case announce = "announce"
    case ads = "ads"
    case upcomingMatches = "matches/upcoming"
    case clubs = "clubs"
    case tournaments = "leagues/all"
    case leagueInfo = "leagues/league"
    case getusers = "getusers"
    case soloUser = "getuser"
    
    case post_auth = "signin"
    case post_reg = "signup"
    case post_edit_profile = "editPlayerInfo"
    case post_team_acceptrequest = "team/acceptrequest"
    case post_edit_club_info = "clubs/edit"
}
