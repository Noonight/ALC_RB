//
//  SortTeamsByScoreHelper.swift
//  ALC_RB
//
//  Created by ayur on 02.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class FilterTeamsByGroupHelper {
    
    struct GroupedLITeam {
        var name = ""
        var _teams: [Team] = []
        var teams: [Team] {
            get {
                return self._teams
            }
            set(newVal) {
                // TODO: score deprecated
//                let newVal = newValue.sorted(by: { lTeam, rTeam -> Bool in
//                    return lTeam.groupScore ?? 0 > rTeam.groupScore ?? 0
//                })
                self._teams = newVal
            }
        }
        
        mutating func add(team: Team) {
            self.teams.append(team)
        }
        
        init(name: String) {
            self.name = name
        }
    }
    
    static func filter(teams: [Team], groups: [Group]) -> [GroupedLITeam] {
        
        var groupedTeams = [GroupedLITeam]()
        
        for group in groups {
            var item = GroupedLITeam(name: group.name ?? "")
//            for team in group.teams ?? [] {
//                let mTeam = teams.filter { liTeam -> Bool in
//                    return liTeam.id == team.getId() ?? team?.getValue()!.id ?? ""
//                }.first
//                if mTeam != nil {
//                    item.teams.append(mTeam!)
//                }
//            }
            groupedTeams.append(item)
        }
        return groupedTeams
//        let uniqueGroups = findUniqueGroups(teams: teams)
//        var filteredTeams: [GroupedLITeam] = []
//        if uniqueGroups.count != 0
//        {
//            for i in 0...uniqueGroups.count - 1 // after index out of range
//            {
//                filteredTeams.append(FilterTeamsByGroupHelper.GroupedLITeam(name: uniqueGroups[i]))
//                //            filteredTeams[i].name = uniqueGroups[i]
//                if teams.count != 0
//                {
//                    for j in 0...teams.count - 1
//                    {
//                        if uniqueGroups[i] == teams[j].group
//                        {
//                            filteredTeams[i].add(team: teams[j])
//                        }
//                    }
//                }
//            }
//        }
//        return filteredTeams
    }
    
    private static func findUniqueGroups(teams: [Team]) -> [String] {
        var uniqueGroups: [String] = []
        for team in teams
        {
            // DEPRACATED
//            if let group = team.group
//            {
//                if uniqueGroups.contains(group) == false
//                {
//                    uniqueGroups.append(group)
//                }
//            }
        }
        return uniqueGroups
    }
    
}
