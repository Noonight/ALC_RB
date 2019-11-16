//
//  ClubApi.swift
//  ALC_RB
//
//  Created by ayur on 16.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

final class ClubApi: ApiRequests {
    
    func get_club(id: String? = nil, name: String? = nil, limit: Int = Constants.Values.LIMIT, offset: Int = 0, resultMy: @escaping (ResultMy<[Club], RequestError>) -> ()) {
        let params = ParamBuilder<Club.CodingKeys>()
            .add(key: .id, value: id)
            .add(key: .name, value: name)
            .limit(limit)
            .offset(offset)
            .get()
        Alamofire
            .request(ApiRoute.getApiURL(.clubs), method: .get, parameters: params)
            .responseResultMy([Club].self, resultMy: resultMy)
    }
    
    func get_club(params: [String : Any], resultMy: @escaping (ResultMy<[Club], RequestError>) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.clubs), method: .get, parameters: params)
            .responseResultMy([Club].self, resultMy: resultMy)
    }
    
//    func post_createTeam(token: String, teamInfo: CreateTeamInfo, resultMy: @escaping (ResultMy<[Club], RequestError>) -> ()) {
//        Alamofire
//            .upload(multipartFormData: { (multipartFormData) in
//                for (key, value) in teamInfo.toParams() {
//                    let strValue = value as! String
//                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            },
//                    usingThreshold: UInt64(),
//                    to: ApiRoute.getApiURL(.post_create_team),
//                    method: .post,
//                    headers: ["auth" : token])
//            { (result) in
//                switch result {
//                case .success(let upload, _, _):
//
//                    upload.responseSoloTeam(completionHandler: { (response) in
//
//                        //                        dump(response)
//                        switch response.result {
//                        case .success:
//                            if let soloTeam = response.result.value {
//                                response_success(soloTeam)
//                            }
//                        case .failure(let _):
//                            upload.responseSingleLineMessage(completionHandler: { (response) in
//                                switch response.result {
//                                case .success:
//                                    if let singleLineMessage = response.result.value {
//                                        response_failure_message(singleLineMessage)
//                                    }
//                                case .failure(let error):
//                                    response_failure(error)
//                                }
//                            })
//                            //                            response_failure(error)
//                        }
//                    })
//
//
//
//                case .failure(let error):
//                    response_failure(error)
//                }
//        }
//    }
    
}
