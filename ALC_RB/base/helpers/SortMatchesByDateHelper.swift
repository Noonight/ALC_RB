//
//  SortMatchesByDateHelper.swift
//  ALC_RB
//
//  Created by ayur on 31.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import SwiftDate

class SortMatchesByDateHelper {
    
    static func sort(type: TypeSort, matches: [Match]) -> [Match]
    {
        var sortedArray: [Match] = []
        if type == .lowToHigh
        {
            let matchesWithDate = getMatchesWithDate(matches: matches).sorted { lMatch, rMatch -> Bool in
//                guard let leftDate = lMatch.date?.toDate()?.date else { return false }
//                guard let rightDate = rMatch.date?.toDate()?.date else { return false }
                guard let leftDate = lMatch.date else { return false }
                guard let rightDate = rMatch.date else { return false }
//                Print.m("left = \(leftDate) ------ right = \(rightDate)")
                return leftDate < rightDate
            }
            sortedArray.append(contentsOf: matchesWithDate)
            sortedArray.append(contentsOf: getMatchesWithoutDate(matches: matches))
        }
        if type == .highToLow
        {
            let matchesWithDate = getMatchesWithDate(matches: matches).sorted { lMatch, rMatch -> Bool in
//                guard let leftDate = lMatch.date?.toDate()?.date else { return false }
//                guard let rightDate = rMatch.date?.toDate()?.date else { return false }
                guard let leftDate = lMatch.date else { return false }
                guard let rightDate = rMatch.date else { return false }
                return leftDate > rightDate
            }
            sortedArray.append(contentsOf: matchesWithDate)
            sortedArray.append(contentsOf: getMatchesWithoutDate(matches: matches))
        }
        return sortedArray
    }
    
    private static func getMatchesWithoutDate(matches: [Match]) -> [Match]
    {
        var matchesWithoutDate: [Match] = []
        
        for match in matches
        {
//            if match.date?.count ?? 0 == 0
            if match.date == nil
            {
                matchesWithoutDate.append(match)
            }
        }
        
        return matchesWithoutDate
    }
    
    private static func getMatchesWithDate(matches: [Match]) -> [Match]
    {
        var matchesWithDate: [Match] = []
        
        for match in matches
        {
//            if match.date?.count ?? 0 != 0
            if match.date != nil
            {
                matchesWithDate.append(match)
            }
        }
        
        return matchesWithDate
    }
    
    enum TypeSort {
        case lowToHigh
        case highToLow
    }
    
}
