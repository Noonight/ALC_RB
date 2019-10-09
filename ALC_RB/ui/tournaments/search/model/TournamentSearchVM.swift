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
    var isSearching: Bool {
        get {
            if self.searchingQuery == nil && self.choosedRegion == nil
            {
                return false
            }
            return true
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
    func prepareCurrentCount() -> Int {
        if self.isSearching == true
        {
            return self.filteredTourneysMIs.count - 1
        }
        return self.tourneyMIs.count - 1
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
            self.filteredTourneysMIs = self.getSelectedTourneysAndNot(tourneys: tourneys)
            return
        }
        self.tourneyMIs = getSelectedTourneysAndNot(tourneys: tourneys)
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
