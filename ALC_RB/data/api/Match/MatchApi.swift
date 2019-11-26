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
    
    func post_matchSetReferee(token: String, editMatchReferees: EditMatchReferees, resultMy: @escaping (ResultMy<Match, Error>) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "auth" : "\(token)"
        ]
        
        let request = Alamofire
            .request(ApiRoute.getApiURL(.post_edit_match_referee), method: .post, parameters: editMatchReferees.toParams(), encoding: JSONEncoding.default, headers: header)
        
        request
            .responseData { response in
//                dump(response)
                let decoder = ISO8601Decoder.getDecoder()
                do {
                    if let match = try? decoder.decode(Match.self, from: response.data!) {
                        resultMy(.success(match))
                    }
                    if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!) {
                        resultMy(.message(message))
                    }
                }
                if response.result.isFailure {
                    resultMy(.failure(response.error!))
                }
        }
    }
    
    func get_myMatchesCellModels(participationMatches: [Match], resultMy: @escaping (ResultMy<[MyMatchesRefTableViewCell.CellModel], Error>) -> ()) {
        
        var mError: Error?
        var mMessage: SingleLineMessage?
        
        let group = DispatchGroup()
        var mResult = [MyMatchesRefTableViewCell.CellModel]()
        
        for match in participationMatches {
            
            // DEPRECATED: chto to tam
            //            group.enter()
            //            getMyMatchesCell(parMatch: match) { result in
            //                switch result {
            //                case .success(let cell):
            //                    mResult.append(cell)
            //                case .message(let message):
            //                    mMessage = message
            //                case .failure(let error):
            //                    mError = error
            //                }
            //                group.leave()
            //            }
        }
        
        group.notify(queue: .main) {
            if let error = mError {
                resultMy(.failure(error))
            }
            if let message = mMessage {
                resultMy(.message(message))
            }
            resultMy(.success(mResult))
        }
    }
    
    //    func getMyMatchesCell(parMatch: Match, resultMy: @escaping (ResultMy<MyMatchesRefTableViewCell.CellModel, Error>) -> ()) {
    //
    //        var mMessage: SingleLineMessage?
    //        var mError: Error?
    //
    //        let group = DispatchGroup()
    //        var model = MyMatchesRefTableViewCell.CellModel(participationMatch: parMatch)
    //
    //        group.enter()
    //        get_tournamentLeague(id: parMatch.league) { result in
    //            switch result {
    //            case .success(let league):
    //                if let team1 = league.league.teams?.filter({ team -> Bool in
    //                    return team.id == parMatch.teamOne
    //                }).first {
    //                    model.team1Name = team1.name
    //
    //                    if team1.club?.count ?? 0 > 1 {
    //                        group.enter()
    //                        self.get_club(id: team1.club!) { cResult in
    //                            switch cResult {
    //                            case .success(let club):
    //                                model.club1 = club.club
    //                            case .message(let message):
    //                                mMessage = message
    //                            case .failure(let error):
    //                                mError = error
    //                            }
    //                            group.leave()
    //                        }
    //                    }
    //                }
    //                if let team2 = league.league.teams?.filter({ team -> Bool in
    //                    return team.id == parMatch.teamTwo
    //                }).first {
    //                    model.team2Name = team2.name
    //
    //                    if team2.club?.count ?? 0 > 1 {
    //                        group.enter()
    //                        self.get_club(id: team2.club!) { cResult in
    //                            switch cResult {
    //                            case .success(let club):
    //                                model.club2 = club.club
    //                            case .message(let message):
    //                                mMessage = message
    //                            case .failure(let error):
    //                                mError = error
    //                            }
    //                            group.leave()
    //                        }
    //                    }
    //                }
    //            case .message(let message):
    //                mMessage = message
    //            case .failure(let error):
    //                mError = error
    //            }
    //            group.leave()
    //        }
    //
    //        group.notify(queue: .main) {
    //            if let error = mError {
    //                resultMy(.failure(error))
    //            }
    //            if let message = mMessage {
    //                resultMy(.message(message))
    //            }
    //            resultMy(.success(model))
    //        }
    //    }
    
}