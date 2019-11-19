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
    
}
