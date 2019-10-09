//
//  TournamentSearchVM.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 06/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TournamentSearchVM {
    
    private lazy var localTourneys = LocalTourneys()
    private lazy var userDefaultsHelper = UserDefaultsHelper()
    
    private var regions: [RegionMy] = []
    private var choosedRegion: RegionMy?
    private var searchingQuery: String?
    
    private var tourneyMIs: [TourneyModelItem] = []
    private var filteredTourneysMIs: [TourneyModelItem] = []
    
    private var previousTourneys: Int = 0 {
        didSet {
            Print.m(self.previousTourneys)
        }
    }
    private var previousFilteredTourneys: Int = 0
    
    var isSearching: Bool {
        get {
            if self.searchingQuery == nil && self.choosedRegion == nil
            {
                return false
            }
            return true
        }
    }
    var isInfinite: Bool {
        get {
//            if self.isSearching
//            {
//                Print.m("\(filteredTourneysMIs.count) >= \(previousFilteredTourneys)")
//                if filteredTourneysMIs.count >= previousFilteredTourneys
//                {
//                    return true
//                }
//                else
//                {
//                    return false
//                }
//            }
//            else
//            {
//                Print.m("\(tourneyMIs.count) >= \(previousTourneys)")
//                if tourneyMIs.count >= previousTourneys
//                {
//                    return true
//                }
//                else
//                {
//                    return false
//                }
//            }
            return false
        }
    }
    
    // MARK: PREPARE
    
    func prepareRegions() -> [RegionMy] {
        return self.regions
    }
    // ------
    func prepareSearchingQuery() -> String? {
        return self.searchingQuery
    }
    
    func prepareChoosedRegion() -> RegionMy? {
        return self.choosedRegion
    }
    // ------
    func prepareTourneyMIs() -> [TourneyModelItem] {
        if self.isSearching == true
        {
            return self.filteredTourneysMIs
        }
        return self.tourneyMIs
    }
    // ------
    func prepareOffset() -> Int {
        return 0
//        if self.isSearching == true
//        {
//            return self.previousFilteredTourneys
//        }
//        return self.previousTourneys
    }
    
    // MARK: UPDATE
    
    func updateRegions(newRegions: [RegionMy]) {
        self.regions = newRegions
    }
    // ------
    func updateSearchingQuery(newQuery: String?) {
        self.searchingQuery = newQuery
    }
    
    func updateChoosenRegion(newRegion: RegionMy?) {
        self.choosedRegion = newRegion
    }
    // ------
    func updateTourneys(tourneys: [Tourney]) {
        if self.isSearching == true
        {
            if self.isInfinite == true
            {
                self.filteredTourneysMIs.append(contentsOf: self.getSelectedTourneysAndNot(tourneys: tourneys))
                self.previousFilteredTourneys = self.filteredTourneysMIs.count
                return
            }
            else
            {
                self.filteredTourneysMIs = self.getSelectedTourneysAndNot(tourneys: tourneys)
                return
            }
        }
        else
        {
            if self.isInfinite == true
            {
                self.tourneyMIs.append(contentsOf: self.getSelectedTourneysAndNot(tourneys: tourneys))
                self.previousTourneys = self.tourneyMIs.count
                return
            }
            else
            {
                self.tourneyMIs = getSelectedTourneysAndNot(tourneys: tourneys)
                return
            }
        }
        
    }
}

// MARK: HELPERS

extension TournamentSearchVM {
    
    func getParticipationTourneys() -> [Participation] {
        return userDefaultsHelper.getAuthorizedUser()?.person.participation ?? []
    }
    
    func getSelectedTourneysAndNot(tourneys: [Tourney]) -> [TourneyModelItem] {
        let alreadyChoosedTourneys = self.localTourneys.getLocalTourneyIds()
        
        var resultArray: [TourneyModelItem] = []
        
        if alreadyChoosedTourneys.count != 0
        {
            if tourneys.count - 1 >= 0
            {
                for i in 0...tourneys.count - 1
                {
                    if alreadyChoosedTourneys.count - 1 >= 0
                    {
                        for j in 0...alreadyChoosedTourneys.count - 1
                        {
                            if tourneys[i].id == alreadyChoosedTourneys[j].id
                            {
                                let tourneyModelItem = TourneyModelItem(item: tourneys[i])
                                tourneyModelItem.isSelected = true
                                resultArray.append(tourneyModelItem)
                            }
                            else
                            {
                                resultArray.append(TourneyModelItem(item: tourneys[i]))
                            }
                        }
                    }
                    else
                    {
                        for j in 0...alreadyChoosedTourneys.count
                        {
                            if tourneys[i].id == alreadyChoosedTourneys[j].id
                            {
                                let tourneyModelItem = TourneyModelItem(item: tourneys[i])
                                tourneyModelItem.isSelected = true
                                resultArray.append(tourneyModelItem)
                            }
                            else
                            {
                                
                                resultArray.append(TourneyModelItem(item: tourneys[i]))
                            }
                        }
                    }
                    
                }
            }
            else
            {
                for i in 0...tourneys.count
                {
                    if alreadyChoosedTourneys.count - 1 >= 0
                    {
                        for j in 0...alreadyChoosedTourneys.count - 1
                        {
                            if tourneys[i].id == alreadyChoosedTourneys[j].id
                            {
                                let tourneyModelItem = TourneyModelItem(item: tourneys[i])
                                tourneyModelItem.isSelected = true
                                resultArray.append(tourneyModelItem)
                            }
                            else
                            {
                                resultArray.append(TourneyModelItem(item: tourneys[i]))
                            }
                        }
                    }
                    else
                    {
                        for j in 0...alreadyChoosedTourneys.count
                        {
                            if tourneys[i].id == alreadyChoosedTourneys[j].id
                            {
                                let tourneyModelItem = TourneyModelItem(item: tourneys[i])
                                tourneyModelItem.isSelected = true
                                resultArray.append(tourneyModelItem)
                            }
                            else
                            {
                                resultArray.append(TourneyModelItem(item: tourneys[i]))
                            }
                        }
                    }
                    
                }
            }
        }
        else
        {
            resultArray = tourneys.map({ tourney -> TourneyModelItem in
                return TourneyModelItem(item: tourney)
            })
        }
        
        return resultArray
    }
    
    func findRegionByName(name: String) -> RegionMy? {
        return self.regions.filter { region -> Bool in
            return region.name == name
        }.first
    }
    
}
