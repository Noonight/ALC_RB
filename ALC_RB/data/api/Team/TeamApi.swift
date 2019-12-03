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
            .responseResultMy([Team].self, resultMy: resultMy)
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
    
    func post_changePlayerNubmer(teamId: String, personId: String, number: Int, resultMy: @escaping (ResultMy<TeamPlayersStatus, RequestError>) -> ()) {
        guard let userToken = UserDefaultsHelper().getToken() else { return }
        Alamofire
            .request(ApiRoute.getApiURL(.teamChangePersonNubmer, ids: teamId, personId), method: .patch, parameters: ["number": number], encoding: JSONEncoding.default, headers: ["auth" : userToken])
            .responseResultMy(TeamPlayersStatus.self, resultMy: resultMy)
    }
    
}
