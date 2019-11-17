//
//  TourneyApi.swift
//  ALC_RB
//
//  Created by ayur on 16.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class TourneyApi: ApiRequests {
    
    func get_tourney(id: String? = nil, name: String? = nil, region: String? = nil, limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[Tourney], RequestError>) -> ()) {
        let params = ParamBuilder<Tourney.CodingKeys>()
            .add(key: .id, value: id)
            .add(key: .name, value: name)
            .add(key: .region, value: region)
            .limit(limit)
            .offset(offset)
            .get()
        
        get_tourney(params: params, resultMy: resultMy)
    }
    
    func get_tourney(params: [String : Any], resultMy: @escaping (ResultMy<[Tourney], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.tourney), method: .get, parameters: params, encoding: URLEncoding(destination: .queryString))
            .responseResultMy([Tourney].self, resultMy: resultMy)
    }
    
    func get_tourneyModelItems(tourneys: [Tourney]?, limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[TourneyModelItem], Error>) -> ()) {
        
        let leagueApi = LeagueApi()
        var mMessage: SingleLineMessage?
        var mError: Error?
        var tourneyModelItems: [TourneyModelItem] = []
        let group = DispatchGroup()
        
        guard let mTourneys = tourneys else { return }
        group.enter()
        
        for t in mTourneys {
            tourneyModelItems.append(TourneyModelItem(tourney: t, leagues: nil))
        }
        for i in 0..<tourneyModelItems.count {
            
            group.enter()
            
            leagueApi.get_leagueModelItems(tourney: tourneyModelItems[i].tourney) { result in
                switch result {
                case .success(let leagues):
                    
                    tourneyModelItems[i].leagues = leagues
                    
                case .message(let message):
                    
                    mMessage = message
                    
                case .failure(let error):
                    
                    mError = error
                    
                }
                group.leave()
            }
        }
        group.leave()
        
        group.notify(queue: .main) {
            
            if let message = mMessage {
                resultMy(.message(message))
            }
            if let error = mError {
                resultMy(.failure(error))
            }
            
            resultMy(.success(tourneyModelItems))
        }
        
    }
    
}
