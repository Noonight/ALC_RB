//
//  InviteApi.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class InviteApi: ApiRequests {
    
    func get_personInvite(id: String? = nil, teamId: String? = nil, personId: String? = nil, limit: Int? = nil, offset: Int? = nil, resultMy: @escaping (ResultMy<[TeamPlayerInviteStatus], RequestError>) -> ()) {
        let params = ParamBuilder<TeamPlayerInviteStatus.CodingKeys>()
            .add(key: .id, value: id)
            .add(key: .team, value: teamId)
            .add(key: .person, value: personId)
            .limit(limit)
            .offset(offset)
            .get()
        get_personInvite(params: params, resultMy: resultMy)
    }
    
    func get_personInvite(params: [String : Any], resultMy: @escaping (ResultMy<[TeamPlayerInviteStatus], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.personInvite), method: .get, parameters: params)
            .responseResultMy([TeamPlayerInviteStatus].self, resultMy: resultMy)
    }
    
    func post_personInvite(invite: TeamPlayerInviteStatus, resultMy: @escaping (ResultMy<TeamPlayerInviteStatus, RequestError>) -> ()) {
        guard let userToken = UserDefaultsHelper().getToken() else { return }
        Alamofire
            .request(ApiRoute.getApiURL(.personInvite), method: .post, parameters: invite.postMap, headers: ["auth":userToken])
            .responseResultMy(TeamPlayerInviteStatus.self, resultMy: resultMy)
    }
    
    func post_acceptPersonInvite(id: String, resultMy: @escaping (ResultMy<TeamPlayerInviteStatus, RequestError>) -> ()) {
        guard let userToken = UserDefaultsHelper().getToken() else { return }
        Alamofire
            .request(ApiRoute.getApiURL(.personInviteAccept, id: id), method: .post, headers: ["auth":userToken])
            .responseResultMy(TeamPlayerInviteStatus.self, resultMy: resultMy)
    }
    
    func post_rejectPersonInvite(id: String, resultMy: @escaping (ResultMy<TeamPlayerInviteStatus, RequestError>) -> ()) {
        guard let userToken = UserDefaultsHelper().getToken() else { return }
        Alamofire
            .request(ApiRoute.getApiURL(.personInviteReject, id: id), method: .post, headers: ["auth":userToken])
            .responseResultMy(TeamPlayerInviteStatus.self, resultMy: resultMy)
    }
    
    func post_cancelPersonInvite(id: String, resultMy: @escaping (ResultMy<TeamPlayerInviteStatus, RequestError>) -> ()) {
        guard let userToken = UserDefaultsHelper().getToken() else { return }
        Alamofire
            .request(ApiRoute.getApiURL(.personInviteCancel, id: id), method: .post, headers: ["auth":userToken])
            .responseResultMy(TeamPlayerInviteStatus.self, resultMy: resultMy)
    }
    
}
