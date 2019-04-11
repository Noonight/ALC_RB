//
//  ApiRequests.swift
//  ALC_RB
//
//  Created by ayur on 25.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiRequests {
    
    // MARK: - POST requests
    
    func post_authorization(userData: SignIn, get_auth_user: @escaping (AuthUser) -> (), get_error: @escaping (Error) -> ()) {
        let params: [String: Any] = [
            SignIn.Fields.login.rawValue: userData.login,
            SignIn.Fields.password.rawValue: userData.password
        ]
        Alamofire
            .request(ApiRoute.getApiURL(.post_auth), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: [:])
            .validate()
            .responseAuthUser { (response) in
                switch response.result {
                case .success:
                    if let authUser = response.result.value {
                        get_auth_user(authUser)
                    }
                case .failure(let error):
                    print(error)
                    get_error(error)
                }
        }
    }
    
    func post_registration(userData: Registration, profileImage: UIImage, response_success: @escaping (AuthUser) -> (), response_failure: @escaping (Error) -> ()) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(profileImage.jpegData(compressionQuality: 1.0)!, withName: "photo", fileName: "jpg", mimeType: "image/jpg")
                for (key, value) in userData.toParams() {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_reg),
                    method: .post)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    //                    upload.uploadProgress(closure: { (progress) in
                    //                    })
                    
                    upload.responseAuthUser(completionHandler: { (response) in
                        switch response.result {
                        case .success:
                            if let newUser = response.result.value {
                                response_success(newUser)
                            }
                        case .failure(let error):
                            response_failure(error)
                        }
                    })
                    
                case .failure(let error):
                    response_failure(error)
                }
        }
    }
    
    func post_edit_profile(token: String, profileInfo: EditProfile, profileImage: UIImage, response_success: @escaping (SoloPerson) -> (), response_failure: @escaping (Error) -> () ) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(profileImage.jpegData(compressionQuality: 1.0)!, withName: "photo", fileName: "jpg", mimeType: "image/jpg")
                for (key, value) in profileInfo.toParams() {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_edit_profile),
                    method: .post,
                    headers: ["auth" : token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
//                    upload.uploadProgress(closure: { (progress) in
//                    })

                    upload.responseSoloPerson(completionHandler: { (response) in
                        switch response.result {
                        case .success:
                            if let editedPerson = response.result.value {
                                response_success(editedPerson)
                            }
                        case .failure(let error):
                            response_failure(error)
                        }
                    })
                    
                case .failure(let error):
                    response_failure(error)
                }
            }
    }
    
    func post_editClubInfo(token: String, clubInfo: EditClubInfo, clubImage: UIImage, response_success: @escaping (SoloClub) -> (), response_failure: @escaping (Error) -> ()) {
        
        Print.m("token - >> \(token)")
        Print.m("club - >> \(clubInfo)")
        
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(clubImage.jpegData(compressionQuality: 1.0)!, withName: "logo", fileName: "jpg", mimeType: "image/jpg")
                for (key, value) in clubInfo.toParams() {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_edit_club_info),
                    method: .post,
                    headers: ["auth" : token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseSoloClub(completionHandler: { (response) in
                        
                        Print.m(response)
                        
                        switch response.result {
                        case .success:
                            if let soloClub = response.result.value {
                                response_success(soloClub)
                            }
                        case .failure(let error):
                            response_failure(error)
                        }
                    })
                    
                case .failure(let error):
                    response_failure(error)
                }
        }
    }
    
    func post_teamAcceptRequest(token: String, acceptInfo: AcceptRequest, response_success: @escaping (AuthUser) -> (), response_failure: @escaping (Error) -> ()) {
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
                    
                    upload.responseAuthUser(completionHandler: { (response) in
                        switch response.result {
                        case .success:
                            if let user = response.result.value {
                                response_success(user)
                            }
                        case .failure(let error):
                            response_failure(error)
                        }
                    })

                case .failure(let error):
                    response_failure(error)
                }
        }
    }
    
    func post_editTeam(token: String, editTeam: EditTeam, response_success: @escaping (EditTeamResponse) -> (), response_failure: @escaping (Error) -> ()) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
//                for (key, value) in editTeam.toParams() {
//                    let strValue = value as! String
//                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
//                }
                multipartFormData.append(editTeam._id.data(using: String.Encoding.utf8)!, withName: EditTeam.Fields._id.value())
                multipartFormData.append(editTeam.teamId.data(using: String.Encoding.utf8)!, withName: EditTeam.Fields.teamId.value())
                
                let dataArray = try! JSONSerialization.data(withJSONObject: editTeam.players, options: .prettyPrinted)
//                let encodedData = NSKeyedArchiver.archivedData(withRootObject: editTeam.players)
//                let jsonString = String(data: dataArray, encoding: .utf8)!
//                multipartFormData.append(jsonString.data(using: String.Encoding.utf8)!, withName: EditTeam.Fields.players.value())
                
                multipartFormData.append(dataArray, withName: EditTeam.Fields.players.value())
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_edit_team),
                    method: .post,
                    headers: ["auth" : token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseEditTeamResponse(completionHandler: { (response) in
                        switch response.result {
                        case .success:
                            if let editTeamResponse = response.result.value {
                                response_success(editTeamResponse)
                            }
                        case .failure(let error):
                            response_failure(error)
                        }
                    })
                    
                case .failure(let error):
                    response_failure(error)
                }
        }
    }
    
    func post_createTeam(token: String, teamInfo: CreateTeamInfo, response_success: @escaping (SoloTeam) -> (), response_failure: @escaping (Error) -> (), response_failure_message: @escaping (ErrorMessage) -> ()) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                for (key, value) in teamInfo.toParams() {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_create_team),
                    method: .post,
                    headers: ["auth" : token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseSoloTeam(completionHandler: { (response) in
                        switch response.result {
                        case .success:
                            if let soloTeam = response.result.value {
                                response_success(soloTeam)
                            }
                        case .failure(let error):
                            upload.responseErrorMessage(completionHandler: { (response) in
                                switch response.result {
                                case .success:
                                    if let errorMessage = response.result.value {
                                        response_failure_message(errorMessage)
                                    }
                                case .failure(let error):
                                    response_failure(error)
                                }
                            })
//                            response_failure(error)
                        }
                    })
                    
                    
                    
                case .failure(let error):
                    response_failure(error)
                }
        }
    }
    
    // MARK: - GET requests
    
    func get_image(imagePath: String, get_success: @escaping (UIImage) -> (), get_failure: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getImageURL(image: imagePath))
            .validate()
            .responseImage { (response) in
                switch response.result {
                case .success:
                    if let image = response.result.value {
                        get_success(image)
                    }
                case .failure(let error):
                    get_failure(error)
                }
        }
    }
    
    func get_tournamets(get_success: @escaping (Tournaments) -> (), get_failure: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.tournaments))
            .responseTournaments { response in
                switch response.result {
                case .success:
                    if let tournaments = response.result.value {
                        get_success(tournaments)
                    }
                case .failure(let error):
                    get_failure(error)
                }
        }
    }
    
    func get_tournamentLeague(id: String, get_success: @escaping (LILeagueInfo) -> (), get_error: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getApiLeagueURL(id))
            .responseLILeagueInfo { response in
                switch response.result {
                case .success:
                    if let leagueInfo = response.result.value {
                        get_success(leagueInfo)
                    }
                case .failure(let error):
                    get_error(error)
                }
        }
    }
    
    func get_players(limit: Int, offset: Int, get_success: @escaping (Players) -> (), get_failure: @escaping (Error) -> ()) {
        let parameters: Parameters = [
            "type": "player",
            "limit": limit,
            "offset": offset
        ]
        
        Alamofire
            .request(ApiRoute.getApiURL(.getusers), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            .responsePlayers { response in
                switch response.result {
                case .success:
                    if let players = response.result.value {
                        get_success(players)
                    }
                case .failure(let error):
                    get_failure(error)
                }
        }
    }
    
    func get_playersWithQuery(query: String, get_success: @escaping (Players) -> (), get_failure: @escaping (Error) -> ()) {
        let parameters: Parameters = [
            "type": "player",
            "search": query
        ]
        
        Alamofire
            .request(ApiRoute.getApiURL(.getusers), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            .responsePlayers { response in
                switch response.result {
                case .success:
                    if let players = response.result.value {
                        get_success(players)
                    }
                case .failure(let error):
                    get_failure(error)
                }
        }
    }
    
    func get_clubs(get_success: @escaping (Clubs) -> (), get_failure: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.clubs))
            .responseClubs { response in
                switch response.result {
                case .success:
                    if let clubs = response.result.value {
                        get_success(clubs)
                    }
                case .failure(let error):
                    get_failure(error)
                }
                
        }
    }
    
}
