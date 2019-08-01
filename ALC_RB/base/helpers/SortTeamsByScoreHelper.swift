//
//  SortTeamsByScoreHelper.swift
//  ALC_RB
//
//  Created by ayur on 02.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class SortTeamsByScoreHelper {
    
//    static func sort(type: TypeSort, matches: [LITeam]) -> [LITeam]
//    {
//        var sortedArray: [LITeam] = []
//        if type == .lowToHigh
//        {
//            let matchesWithDate = getMatchesWithDate(matches: matches).sorted { lMatch, rMatch -> Bool in
//                guard let leftDate = lMatch.date?.toDate()?.date else { return false }
//                guard let rightDate = rMatch.date?.toDate()?.date else { return false }
//                //                Print.m("left = \(leftDate) ------ right = \(rightDate)")
//                return leftDate < rightDate
//            }
//            let playedMatches = getPlayedMatches(matches: matches).sorted { lMatch, rMatch -> Bool in
//                return lMatch.score < rMatch.g
//            }
//            sortedArray.append(contentsOf: matchesWithDate)
//            sortedArray.append(contentsOf: getPl(matches: matches))
//        }
//        if type == .highToLow
//        {
//            let matchesWithDate = getMatchesWithDate(matches: matches).sorted { lMatch, rMatch -> Bool in
//                guard let leftDate = lMatch.date?.toDate()?.date else { return false }
//                guard let rightDate = rMatch.date?.toDate()?.date else { return false }
//                return leftDate > rightDate
//            }
//            sortedArray.append(contentsOf: matchesWithDate)
//            sortedArray.append(contentsOf: getMatchesWithoutDate(matches: matches))
//        }
//        return sortedArray
//    }
//    
//    private static func getPlayedMatches(teams: [LITeam]) -> [LITeam]
//    {
//        var playedMatches: [LITeam] = []
//
//        for team in teams
//        {
//            if team.played == true
//            {
//                playedMatches.append(team)
//            }
//        }
//
//        return playedMatches
//    }
//
//    private static func getNotPlayedMatches(teams: [LITeam]) -> [LITeam]
//    {
//        var notPlayedMatchs: [LITeam] = []
//
//        for team in teams
//        {
//            if team.played == false
//            {
//                notPlayedMatchs.append(team)
//            }
//        }
//
//        return notPlayedMatchs
//    }
//
//    enum TypeSort {
//        case lowToHigh
//        case highToLow
//    }
////
}
