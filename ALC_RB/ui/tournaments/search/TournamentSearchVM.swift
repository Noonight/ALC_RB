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
    
    // MARK: PREPARE
    
    func prepareRegions() -> [RegionMy] {
        return self.regions
    }
    
    func prepareChoosedRegion() -> RegionMy? {
        return self.choosedRegion
    }
    
    // MARK: UPDATE
    
    func updateRegions(newRegions: [RegionMy]) {
        self.regions = newRegions
    }
    
    func updateChoosenRegion(newRegion: RegionMy) {
        self.choosedRegion = newRegion
    }
    
}

// MARK: HELPERS

extension TournamentSearchVM {
    
    func findRegionByName(name: String) -> RegionMy? {
        return self.regions.filter { region -> Bool in
            return region.name == name
        }.first
    }
    
}
