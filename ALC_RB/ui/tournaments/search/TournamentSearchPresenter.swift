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
    
    func fetchRegions(success: @escaping ([RegionMy]) -> (), r_message: @escaping (SingleLineMessage) -> (), localError: @escaping (Error) -> (), serverError: @escaping (Error) -> (), alamofireError: @escaping (Error) -> ()) {
        self.dataManager.get_regions { resultMy in
            switch resultMy
            {
            case .success(let regions):
                success(regions)
            case .message(let message):
                r_message(message)
            case .failure(.alamofire(let error)):
                alamofireError(error)
            case .failure(.local(let error)):
                localError(error)
            case .failure(.server(let error)):
                serverError(error)
            }
        }
    }
    
    func fetchTourneys(name: String?, limit: Int? = 20, offset: Int? = 0, success: @escaping ([Tourney]) -> (), r_message: @escaping (SingleLineMessage) -> (), localError: @escaping (Error) -> (), serverError: @escaping (Error) -> (), alamofireError: @escaping (Error) -> ()) {
        self.dataManager.get_tourney(name: name, limit: limit, offset: offset) { tourneys in
            switch tourneys
            {
            case .success(let tourney):
                success(tourney)
            case .message(let message):
                r_message(message)
            case .failure(.alamofire(let error)):
                alamofireError(error)
            case .failure(.local(let error)):
                localError(error)
            case .failure(.server(let error)):
                serverError(error)
            }
        }
    }
    
    func findTournaments(success: @escaping ([Tourney]) -> ()) {
        
    }
    
}
