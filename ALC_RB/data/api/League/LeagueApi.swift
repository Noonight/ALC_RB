//
//  LeagueApi.swift
//  ALC_RB
//
//  Created by mac on 13.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class LeagueApi: ApiRequests {
    
    func get_league(id: String? = nil, name: String? = nil, status: League.Status? = nil, tourneys: [String]? = nil, limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[League], RequestError>) -> ()) {
        let params = ParamBuilder<League.CodingKeys>()
                    .add(key: .id, value: id)
                    .add(key: .name, value: name)
                    .add(key: .status, value: status?.ck)
//                    .add(key: .tourney, value: StrBuilder<League.CodingKeys>().add(.comma).add(tourneys.map({ "\($0)," })))
                    .add(key: .tourney, value: StrBuilder().add(.comma).add(tourneys))
//                    .populate(StrBuilder().add([.ageAllowedMax, .beginDate, .creator]))
                    .limit(limit)
                    .offset(offset)
                    .get()
        
        get_league(params: params, resultMy: resultMy)
    }
    
    func get_league(params: [String : Any], resultMy: @escaping (ResultMy<[League], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.league), method: .get, parameters: params)
            .responseResultMy([League].self, resultMy: resultMy)
    }
    
    func get_userMainRefLeagues(resultMy: @escaping (ResultMy<[League], RequestError>) -> ()) {
        guard let userId = UserDefaultsHelper().getAuthorizedUser()?.person.id else { return }
        let params = ParamBuilder<League.CodingKeys>()
            .add(key: .status, value: StrBuilder().setSeparatorStyle(.comma).add(.comma).add([League.Status.pending.rawValue, League.Status.started.rawValue]))
            .add(key: .mainReferee, value: userId)
//            .select(.mainReferee)
            .select(StrBuilder().add([.mainReferee, .name]))
            .get()
        get_league(params: params, resultMy: resultMy)
    }
    
    func get_leagueModelItems(tourney: Tourney?, resultMy: @escaping (ResultMy<[LeagueModelItem], RequestError>) -> ()) {
        guard let mTourney = tourney else {
            resultMy(.success([]))
            return
        }
        let params = ParamBuilder<League.CodingKeys>()
            .add(key: .tourney, value: mTourney.id)
            .get()
        get_league(params: params) { result in
            switch result {
            case .success(let leagues):
                resultMy(.success(leagues.map { LeagueModelItem(league: $0) } ))
            case .message(let msg):
                Print.m(msg.message)
                resultMy(.message(msg))
            case .failure(.error(let error)):
                Print.m(error)
                resultMy(.failure(.error(error)))
            case .failure(.notExpectedData):
                Print.m("not expected data")
                resultMy(.success([]))
            }
        }
    }
}
