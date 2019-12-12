//
//  TeamApi.swift
//  ALC_RB
//
//  Created by ayur on 17.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class TeamApi: ApiRequests {
    
    func get_team(id: String? = nil, name: String? = nil, limit: Int? = nil, offset: Int? = nil, resultMy: @escaping (ResultMy<[Team], RequestError>) -> ()) {
        let params = ParamBuilder<Team.CodingKeys>()
            .add(key: .id, value: id)
            .add(key: .name, value: name)
            .limit(limit)
            .offset(offset)
            .get()
        Alamofire
            .request(ApiRoute.getApiURL(.team), method: .get, parameters: params)
            .responseResultMy([Team].self, resultMy: resultMy)
    }
    
    func get_team(params: [String: Any], resultMy: @escaping (ResultMy<[Team], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.team), method: .get, parameters: params)
            .logURL()
            .logBody()
            .responseResultMy([Team].self, resultMy: resultMy)
    }
    
    // required: _id={team.id}&_select=players&_populate=players
    func get_teamPlayers(inTeam: Team? = nil, params: [String: Any], resultMy: @escaping (ResultMy<Team, RequestError>) -> ()) {
        let personApi = PersonApi()
        get_team(params: params) { result in
            switch result {
            case .success(let findedTeam):
                
                guard var findedTeam = findedTeam.first else { return }
                
                var findedTeamPlayers = findedTeam.players
                
                let personIds = findedTeamPlayers?.map({ playerStatus -> String in
                    return playerStatus.person?.getId() ?? (playerStatus.person?.getValue()?.id)!
                })
                
                if personIds?.count ?? 0 != 0 {
                    var params1 = [String:Any]()
                    if personIds?.count ?? 0 == 1 {
                        params1 = ParamBuilder<Person.CodingKeys>()
                            .add(key: .id, value: StrBuilder().add(personIds))
                            .get()
                    } else {
                        params1 = ParamBuilder<Person.CodingKeys>()
                            .add(key: .id, value: StrBuilder().setSeparatorStyle(.comma).add(.comma).add(personIds))
                            .get()
                    }
                    personApi.get_person(params: params1) { resultPerson in
                        switch resultPerson {
                        case .success(let persons):
                            
                            if persons.count != 0 {
                                if findedTeamPlayers != nil {
                                    for i in 0..<findedTeamPlayers!.count {
                                        
                                        if let person = persons.filter({ mPerson -> Bool in
                                            return mPerson.id == findedTeamPlayers![i].person?.getId()
                                        }).first {
                                            
                                            findedTeamPlayers![i].person = IdRefObjectWrapper<Person>(person)
                                            
                                        }
                                    }
                                }
                            }

                            if var inTeam = inTeam {
                                inTeam.players = findedTeamPlayers
                                inTeam.trainer = findedTeam.trainer
                                resultMy(.success(inTeam))
                            } else {
                                findedTeam.players = findedTeamPlayers
                                resultMy(.success(findedTeam))
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
                } else {
                    if var inTeam = inTeam {
                        inTeam.players = findedTeamPlayers
                        inTeam.trainer = findedTeam.trainer
                        resultMy(.success(inTeam))
                    } else {
                        findedTeam.players = findedTeamPlayers
                        resultMy(.success(findedTeam))
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
    
    func post_team(team: Team, resultMy: @escaping (ResultMy<Team, RequestError>) -> ()) {
        guard let userToken = UserDefaultsHelper().getToken() else { return }
        Alamofire
            .request(ApiRoute.getApiURL(.team), method: .post, parameters: team.postMap, headers: ["auth" : userToken])
            .responseResultMy(Team.self, resultMy: resultMy)
    }
    
    func post_teamParticipationRequest(teamParticipationRequest: TeamParticipationRequest, resultMy: @escaping (ResultMy<TeamParticipationRequest, RequestError>) -> ()) {
        guard let userToken = UserDefaultsHelper().getToken() else { return }
        Alamofire
            .request(ApiRoute.getApiURL(.team_participation_request), method: .post, parameters: teamParticipationRequest.postMap, headers: ["auth" : userToken])
            .responseResultMy(TeamParticipationRequest.self, resultMy: resultMy)
    }
    
    func patch_team(team: Team, resultMy: @escaping (ResultMy<Team, RequestError>) -> ()) {
        
        guard let userToken = UserDefaultsHelper().getToken() else { return }
        Print.m("PATH: DATA ")
        Print.m(team.patchMap)
        Alamofire
            .request(ApiRoute.getApiURL(.team, id: team.id), method: .patch, parameters: team.patchMap, headers: ["auth" : userToken])
            .responseResultMy(Team.self, resultMy: resultMy)
    }
    
    func post_changePlayerNubmer(teamId: String, personId: String, number: Int, resultMy: @escaping (ResultMy<Player, RequestError>) -> ()) {
        guard let userToken = UserDefaultsHelper().getToken() else { return }
        Alamofire
            .request(ApiRoute.getApiURL(.teamChangePersonNubmer, ids: teamId, personId), method: .patch, parameters: ["number": number], encoding: JSONEncoding.default, headers: ["auth" : userToken])
            .responseResultMy(Player.self, resultMy: resultMy)
    }
    
}
