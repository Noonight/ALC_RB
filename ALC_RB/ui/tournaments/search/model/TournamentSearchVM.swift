//
//  TournamentSearchVM.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 06/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TournamentSearchVM {
    
    private let localTourneys = LocalTourneys()
    
    private var regions: [RegionMy] = []
    private var choosedRegion: RegionMy?
    private var tourneyMIs: [TourneyModelItem] = []
    
    // MARK: PREPARE
    
    func prepareTourneysMI() -> [TourneyModelItem] {
        return self.tourneyMIs
    }
    
    func prepareRegions() -> [RegionMy] {
        
        return self.regions
    }
    
    func prepareChoosedRegion() -> RegionMy? {
        return self.choosedRegion
    }
    
    func prepareChoosedTourneyMI() -> [TourneyModelItem] {
        return self.tourneyMIs.filter { tourney -> Bool in
            return tourney.isSelected == true
        }
    }
    
    // MARK: UPDATE
    
    func updateTourneys(tourneys: [Tourney]) {
        self.tourneyMIs = getSelectedTourneysAndNot(tourneys: tourneys)
//        Print.m(getSelectedTourneysAndNot(tourneys: tourneys))
//        self.tourneyMIs = tourneysMI
    }
    
    func updateRegions(newRegions: [RegionMy]) {
        self.regions = newRegions
    }
    
    func updateChoosenRegion(newRegion: RegionMy) {
        self.choosedRegion = newRegion
    }
    
//    func updateChoosenTourneyMI(tourneyMI: TourneyModelItem) {
//        for i in 0...tourneyMIs.count - 1 {
//            if tourneyMI.name ==
//        }
//    }
    
}

// MARK: HELPERS

extension TournamentSearchVM {
    
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
