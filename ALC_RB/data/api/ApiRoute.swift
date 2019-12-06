//
//  ApiRoutes.swift
//  ALC_RB
//
//  Created by user on 03.12.18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation

struct ApiRoute {
    
    static let baseRoute = "https://football.bw2api.ru/"
//    static let baseRoute = "https://footballapi.ibb.su/"
    
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
//        print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(baseRoute)\(image)\n")
        #endif
        return URL(string: "\(baseRoute)\(image)")!
    }
    
    static func getAbsoluteImageRoute(_ image: String) -> String {
        return URL(string: "\(baseRoute)\(image)")!.absoluteString
    }

    
    static func getApiURL(_ mod: Routes, id: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> URL {
        #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(baseRoute)api/\(mod.rawValue)/\(id)\n")
        #endif
        return URL(string: "\(baseRoute)api/\(mod.rawValue)/\(id)")!
    }
    
    static func getApiURL(_ mod: Routes, ids: String..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) -> URL {
        var mIds = String()
        for id in ids {
            mIds += "/\(id)"
        }
        #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> ->> \(functionName) [#\(lineNumber)]| \(baseRoute)api/\(mod.rawValue)\(mIds)\n")
        #endif
        return URL(string: "\(baseRoute)api/\(mod.rawValue)\(mIds)")!
    }
}

enum Routes: String {
    case newsOld = "news" // deprecated
    case news = "crud/news"
    case announce = "crud/announce"
    case ads = "ads" // later
//    case upcomingMatches = "matches/upcoming"
    case clubs = "clubs" // later
    case tournaments = "leagues/all" // deprecated
    case leagueInfo = "leagues/league" // deprecated
//    case getusers = "getusers" // deprecated
//    case soloUser = "getuser" // deprecated
    case person = "crud/person"
    case personQuery = "crud/person/or" // dont works without params
    case activeMatches = "matches/active"
    case refreshUser = "refresh" // get user in header token of authorized user
    case region = "crud/region"
    case tourney = "crud/tourney"
    case upcomingMatches = "upcoming/matches" // later
    case match = "crud/match"
    case league = "crud/league"
    case leagueMatches = "matches/getbyleague" // deprecated
    case personInvite = "person_invite"
    case personInviteCancel = "person_invite/cancel"
    case personInviteAccept = "person_invite/accept"
    case personInviteReject = "person_invite/reject"
    case team = "crud/team"
    case teamChangePersonNubmer = "team/person/change_number"
    
    case team_participation_request = "participation_request"
    
    case post_auth = "signin"
    case post_reg = "signup"
    case post_edit_profile = "editPlayerInfo" // later
    case post_team_acceptrequest = "team/acceptrequest"
    case post_edit_club_info = "clubs/edit" // later
//    case post_create_team = "crud/team"
    case post_edit_team = "team/edit"
    case post_add_player_team = "team/addplayer"
    case post_create_club = "clubs/add"
    case post_edit_match_referee = "matches/setreferees"
    case post_edit_protcol = "matches/changeProtocol"
    case post_accept_protocol = "matches/acceptProtocol"
}
