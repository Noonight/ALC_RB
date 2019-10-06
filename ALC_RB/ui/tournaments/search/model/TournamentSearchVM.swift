//
//  TournamentSearchVM.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 06/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TournamentSearchVM {
    
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
    
    func updateTourneysMI(tourneysMI: [TourneyModelItem]) {
        self.tourneyMIs = tourneysMI
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
    
    func findRegionByName(name: String) -> RegionMy? {
        return self.regions.filter { region -> Bool in
            return region.name == name
        }.first
    }
    
}
