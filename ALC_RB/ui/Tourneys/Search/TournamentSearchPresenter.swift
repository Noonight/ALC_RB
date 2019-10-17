//
//  TournamentSearchPresenter.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 04/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TournamentSearchPresenter {
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetchRegions(success: @escaping ([RegionMy]) -> (), r_message: @escaping (SingleLineMessage) -> (), r_error: @escaping (Error) -> ()) {
        self.dataManager.get_regions { resultMy in
            switch resultMy
            {
            case .success(let regions):
                success(regions)
            case .message(let message):
                r_message(message)
            case .failure(let error):
                r_error(error)
            }
        }
    }
    
    func fetchTourneys(name: String?, region: RegionMy? = nil, limit: Int? = 20, offset: Int? = 0, success: @escaping ([Tourney]) -> (), r_message: @escaping (SingleLineMessage) -> (), r_error: @escaping (Error) -> ()) {
        self.dataManager.get_tourney(name: name, region: region, limit: limit, offset: offset) { tourneys in
            switch tourneys
            {
            case .success(let tourney):
                Print.m(tourney)
                success(tourney)
            case .message(let message):
                r_message(message)
            case .failure(let error):
                r_error(error)
            }
        }
    }
    
    func findTournaments(success: @escaping ([Tourney]) -> ()) {
        
    }
    
}
