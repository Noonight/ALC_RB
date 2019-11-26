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
        let userToken = UserDefaultsHelper().getToken()
        Alamofire
            .request(ApiRoute.getApiURL(.team), method: .post, parameters: team.postMap, headers: ["auth" : userToken])
            .responseResultMy(Team.self, resultMy: resultMy)
    }
    
    func post_teamParticipationRequest(teamParticipationRequest: TeamParticipationRequest, resultMy: @escaping (ResultMy<TeamParticipationRequest, RequestError>) -> ()) {
        let userToken = UserDefaultsHelper().getToken()
        Alamofire
            .request(ApiRoute.getApiURL(.team_participation_request), method: .post, parameters: teamParticipationRequest.postMap, headers: ["auth" : userToken])
            .responseResultMy(TeamParticipationRequest.self, resultMy: resultMy)
    }
    
    func patch_team(team: Team, resultMy: @escaping (ResultMy<Team, RequestError>) -> ()) {
        
        let userToken = UserDefaultsHelper().getToken()
        
        Alamofire
            .request(ApiRoute.getApiURL(.team, id: team.id), method: .patch, parameters: team.patchMap, headers: ["auth" : userToken])
            .responseResultMy(Team.self, resultMy: resultMy)
    }
    
    // deprecated:
    func post_teamAcceptRequest(token: String, acceptInfo: AcceptRequest, response_success: @escaping (SinglePerson) -> (), response_message: @escaping (SingleLineMessage)->(), response_failure: @escaping (Error) -> ()) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                for (key, value) in acceptInfo.toParams() {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_team_acceptrequest),
                    method: .post,
                    headers: ["auth" : token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseResultMy(SinglePerson.self) { resultMy in
                        switch resultMy {
                        case .success(let person):
                            Print.m("TODO: value is \(person)")
                        case .message(let msg):
                            Print.m(msg.message)
                        case .failure(.error(let error)):
                            Print.m(error)
                        case .failure(.notExpectedData):
                            Print.m("not expectedData")
                        }
                    }
                    
                case .failure(let error):
                    response_failure(error)
                }
        }
    }
    
    func post_addPlayerToTeam(token: String, addPlayerToTeam: AddPlayerToTeam, response_success: @escaping (SoloLeague) -> (), response_failure: @escaping (Error) -> (), response_single_line_message: @escaping (SingleLineMessage) -> ()) {
        
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "auth" : "\(token)"
        ]
        
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                for (key, value) in addPlayerToTeam.toParams() {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_add_player_team),
                    method: .post,
                    headers: ["auth" : token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    //                    upload.responseJSON(completionHandler: { response in
                    //                    })
                    
                    upload.responseSoloLeague(completionHandler: { response in
                        switch response.result {
                        case .success(let value):
                            response_success(value)
                        case .failure(let error):
                            upload.responseSingleLineMessage(completionHandler: { response in
                                switch response.result {
                                case .success(let value):
                                    response_single_line_message(value)
                                case .failure(let error):
                                    response_failure(error)
                                }
                            })
                        }
                    })
                    
                    //                    upload.responseLILeagueInfo(completionHandler: { response in
                    //                        switch response.result {
                    //                        case .success(let value):
                    //                            response_success(value)
                    //                        case .failure(let error):
                    //                            upload.responseSingleLineMessage(completionHandler: { response in
                    //                                switch response.result {
                    //                                case .success(let value):
                    //                                    response_single_line_message(value)
                    //                                case .failure(let error):
                    //                                    response_failure(error)
                    //                                }
                    //                            })
                    //                        }
                //                    })
                case .failure(let error):
                    Print.m(error)
                    response_failure(error)
                }
        }
    }
    
}
