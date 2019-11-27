//
//  TournamentSearchPresenter.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 04/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TournamentSearchPresenter {
    
    private let regionApi: RegionApi
    private let tourneyApi: TourneyApi
    
    init(tourneyApi: TourneyApi, regionApi: RegionApi) {
        self.tourneyApi = tourneyApi
        self.regionApi = regionApi
    }
    
    func fetchRegions(success: @escaping ([RegionMy]) -> (), r_message: @escaping (SingleLineMessage) -> (), r_error: @escaping (Error) -> ()) {
        self.regionApi.get_region { resultMy in
            switch resultMy {
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
        self.tourneyApi.get_tourney(name: name, region: region?.id, limit: limit, offset: offset) { tourneys in
            switch tourneys
            {
            case .success(let tourney):
//                Print.m(tourney)
//                dump(tourney)
                success(tourney)
            case .message(let message):
                r_message(message)
            case .failure(let error):
                r_error(error)
            }
        }
    }
    
}
