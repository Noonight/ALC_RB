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
    
    func get_tourneyModelItemsQuery(leagueName: String? = nil, region: RegionMy? = nil, resultMy: @escaping (ResultMy<[TourneyModelItem], RequestError>) -> ()) {
        
        let leagueApi = LeagueApi()
        let params = ParamBuilder<League.CodingKeys>()
            .add(key: .name, value: leagueName)
//            .add(key: .region, value: region?.id)
            .select(.tourney)
            .populate(.tourney)
            .get()
        leagueApi.get_league(params: params) { result in
            switch result {
            case .success(let filteredLeagues):
                self.get_tourneyModelItems(tourneys: filteredLeagues.map { $0.tourney!.getValue()! }) { result in
                    switch result {
                    case .success(let tourneyModelItems):
                        
                        // FILTER BY REGION
                        if region != nil {
                            let resultArr = tourneyModelItems.filter({ tourneyMI -> Bool in
                                let mRegion = tourneyMI.tourney.region
                                return mRegion?.getId() ?? mRegion?.getValue()?.id == region?.id
                            })
                            
                            resultMy(.success(resultArr))
                        }
                        
                        resultMy(.success(tourneyModelItems))
                        
                    case .message(let message):
                        Print.m(message.message)
                        
                    case .failure(.error(let error)):
                        Print.m(error)
                        
                    case .failure(.notExpectedData):
                        Print.m("not expected data")
                    }
                }
            case .message(let message):
                Print.m(message.message)
                resultMy(.message(message))
            case .failure(.error(let error)):
                Print.m(error)
                resultMy(.failure(.error(error)))
            case .failure(.notExpectedData):
                Print.m("not expected data")
                resultMy(.failure(.notExpectedData))
            }
        }
        
    }
    
    func get_tourneyModelItems(tourneys: [Tourney]?, limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[TourneyModelItem], RequestError>) -> ()) {
        
        let leagueApi = LeagueApi()
        var mMessage: SingleLineMessage?
        var mError: Error?
        var notExpectedData = false
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
                    
                case .failure(.error(let error)):
                    
                    mError = error
                 
                case .failure(.notExpectedData):
                    
                    notExpectedData = true
                    
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
                resultMy(.failure(.error(error)))
            }
            if notExpectedData == true {
                resultMy(.failure(.notExpectedData))
            }
            
            resultMy(.success(tourneyModelItems))
        }
        
    }
    
}
