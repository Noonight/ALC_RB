//
//  MatchApi.swift
//  ALC_RB
//
//  Created by mac on 12.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class MatchApi: ApiRequests {
    
    func get_match(id: String? = nil, league: String? = nil, limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[Match], RequestError>) -> ()) {
        let params = ParamBuilder<Match.CodingKeys>()
            .add(key: .id, value: id)
            .add(key: .league, value: league)
            .limit(limit)
            .offset(offset)
            .get()
        get_match(params: params, resultMy: resultMy)
    }
    
    func get_match(params: [String : Any], limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[Match], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.match), method: .get, parameters: params)
            .responseResultMy([Match].self, resultMy: resultMy)
    }
    
    func get_userRefereeMatches(resultMy: @escaping (ResultMy<[Match], RequestError>) -> ()) {
        guard let userId = UserDefaultsHelper().getAuthorizedUser()?.person.id else { return }
        let params = ParamBuilder<Match.CodingKeys>()
            .add(key: "referees.person", value: userId)
            .add(key: .played, value: false)
            .select("referees.person referees._id")
            .get()
        get_match(params: params, resultMy: resultMy)
    }
    
    // required: _id={match.id}&_select=playersList&_populate=playersList
    func get_matchPlayers(inMatch: Match, resultMy: @escaping (ResultMy<Match, RequestError>) -> ()) {
        let params = ParamBuilder<Match.CodingKeys>()
            .add(key: .id, value: inMatch.id)
            .select(.playersList)
            .populate(.playersList)
            .get()
        get_match(params: params) { result in
            switch result {
            case .success(let findedMatches):
                var inMatch = inMatch
                guard let match = findedMatches.first else { return }
                inMatch.playersList = match.playersList
                resultMy(.success(inMatch))
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
    
    func get_mainRefMatchesModelsGroupedByLeague(resultMy: @escaping (ResultMy<[ScheduleGroupByLeagueMatches], RequestError>) -> ()) {
        let leagueApi = LeagueApi()
        leagueApi.get_userMainRefLeagues { result in
            switch result {
            case .success(let findedLeagues):
                
                let params1 = ParamBuilder<Match.CodingKeys>()
                    .add(key: .league, value: StrBuilder().setSeparatorStyle(.comma).add(.comma).add(findedLeagues.map { $0.id }))
                    .populate(StrBuilder().add([.teamOne, .teamTwo, .league, .place]).add("referees.person"))
                    .get()
                self.get_match(params: params1, resultMy: { result1 in
                    switch result1 {
                    case .success(let findedMatches):
                        
                        var resultArr = [ScheduleGroupByLeagueMatches]()
                        
                        for league in findedLeagues {
                            var matches = [MatchScheduleModelItem]()
                            for match in findedMatches {
                                if league.id == match.league?.getId() ?? match.league?.getValue()?.id {
                                    matches.append(MatchScheduleModelItem(match: match))
                                }
                            }
                            resultArr.append(ScheduleGroupByLeagueMatches(title: league.name!, matches: matches))
                        }
                        
                        resultMy(.success(resultArr))
                        
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
                })
                
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
    
    func get_upcomingMatches(limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, resultMy: @escaping (ResultMy<[Match], RequestError>) -> ()) {
        
        // get active leagues
        // get matches moreOrEqualThan current date
        let leagueApi = LeagueApi()
        
        let group = DispatchGroup()
        
        var mMessage: SingleLineMessage?
        var mError: Error?
        var notExpectedData: Bool = false
        var upcomingMatches = [Match]()
        
        group.enter()
        
        leagueApi.get_league(
            params: ParamBuilder<League.CodingKeys>()
                .select(
                    StrBuilder()
                        .add(.id)
                )
                .add(key: .status, value: League.Status.started.ck)
                .get()
        ) { result in
            switch result {
            case .success(let leagues):
                
                group.enter()
                
                let params =
                    ParamBuilder<Match.CodingKeys>()
                        .add(key: .played, value: false)
                        .add(key: .league, value: StrBuilder().add(leagues.map({ $0.id })))
                        .limit(limit)
                        .offset(offset)
                        .get()
                Alamofire
                    .request(ApiRoute.getApiURL(.match), method: .get, parameters: params)
                    .responseResultMy([Match].self, resultMy: { result in
                        switch result {
                        case .success(let matches):
                            upcomingMatches = matches
                        case .message(let message):
                            Print.m(message.message)
                            mMessage = message
                        case .failure(.error(let error)):
                            Print.m(error)
                            mError = error
                        case .failure(.notExpectedData):
                            Print.m("not expected data")
                            notExpectedData = true
                        }
                        group.leave()
                    })
                
            case .message(let message):
                Print.m(message.message)
                mMessage = message
            case .failure(.error(let error)):
                Print.m(error)
                mError = error
            case .failure(.notExpectedData):
                Print.m("not expected data")
                notExpectedData = true
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = mError {
                resultMy(.failure(.error(error)))
            }
            if let message = mMessage {
                resultMy(.message(message))
            }
            if notExpectedData == true {
//                Print.m("not expected data!!! TEST:")
                resultMy(.failure(.notExpectedData))
            }
            resultMy(.success(upcomingMatches))
        }
    }
    
    // MARK: - POST
    
    // without role check
    func post_changePlayers(match: Match, resultMy: @escaping (ResultMy<Match, RequestError>) -> ()) {
        guard let userToken = UserDefaultsHelper().getToken() else { return }
        Alamofire
            .request(ApiRoute.getApiURL(.matchChangePlayers, id: match.id), method: .post, parameters: match.postPlayersList, encoding: JSONEncoding.default, headers: ["auth": userToken])
            .responseResultMy(Match.self, resultMy: resultMy)
    }
    
    // MARK: - PATCH
    
    func patch_matchReferees(match: Match, resultMy: @escaping (ResultMy<Match, RequestError>) -> ()) {
        guard let userToken = UserDefaultsHelper().getToken() else { return }
        Alamofire
            .request(ApiRoute.getApiURL(.match, id: match.id), method: .patch, parameters: match.patchReferees, encoding: JSONEncoding.default, headers: ["auth": userToken])
            .logBody()
            .responseResultMy(Match.self, resultMy: resultMy)
    }
}
