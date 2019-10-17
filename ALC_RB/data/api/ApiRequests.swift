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
import RxSwift

class ApiRequests {
    
    // MARK: - POST requests
    
    func post_authorization(userData: SignIn, get_auth_user: @escaping (AuthUser) -> (), get_error: @escaping (Error) -> (), get_message: @escaping (SingleLineMessage) -> ()) {
        let params: [String: Any] = [
            SignIn.Fields.login.rawValue: userData.login,
            SignIn.Fields.password.rawValue: userData.password
        ]
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_auth),
                    method: .post)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseAuthUser { (response) in
                        switch response.result {
                        case .success:
                            if let authUser = response.result.value {
                                get_auth_user(authUser)
                            }
                        case .failure(let error):
                            upload.responseSingleLineMessage(completionHandler: { response in
                                switch response.result {
                                case .success(let value):
                                    get_message(value)
                                case .failure(let error):
                                    get_error(error)
                                }
                            })
                            
                        }
                    }
                    
                case .failure(let error):
                    get_error(error)
                }
        }
    }
    
    func post_registration(userData: Registration, profileImage: UIImage?, response_success: @escaping (AuthUser) -> (), response_failure: @escaping (Error) -> (), response_message: @escaping (SingleLineMessage) -> ()) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                if let image = profileImage {
                    multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: "photo", fileName: "jpg", mimeType: "image/jpg")
                }
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
                    
                    upload.responseAuthUser(completionHandler: { (response) in
                        switch response.result {
                        case .success:
                            if let newUser = response.result.value {
                                response_success(newUser)
                            }
                        case .failure(let error):
//                            response_failure(error)
                            upload.responseSingleLineMessage(completionHandler: { response in
                                switch response.result {
                                case .success(let value):
                                    response_message(value)
                                case .failure(let error):
                                    response_failure(error)
                                }
                            })
                        }
                    })
                    
                case .failure(let error):
                    response_failure(error)
                }
        }
    }
    
    func post_edit_profile(token: String, profileInfo: EditProfile, profileImage: UIImage?, response_success: @escaping (SoloPerson) -> (), response_failure: @escaping (Error) -> () ) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                if let image = profileImage {
                    multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: "photo", fileName: "jpg", mimeType: "image/jpg")
                }
                
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
    
    func post_editClubInfo(token: String, clubInfo: EditClubInfo, clubImage: UIImage?, response_success: @escaping (SoloClub) -> (), response_failure: @escaping (Error) -> ()) {
        
//        Print.m("token - >> \(token)")
//        Print.m("club - >> \(clubInfo)")
        
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                if let image = clubImage {
                    multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: "logo", fileName: "jpg", mimeType: "image/jpg")
                }
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
                        
//                        Print.m(response)
                        
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
    
    
    
//    func rx_post_createClub(token: String, createClub: CreateClub, image: UIImage?) -> Observable<SoloClub> {
//        
//        return Observable.create { observer -> Disposable in
//            self.post_createClub(token: token, createClub: createClub, image: image, response_success: { soloClub in
//                observer.onNext(soloClub)
//            }, response_message: { message in
////                observer.onError(<#T##error: Error##Error#>)
////                observer.onError(message)
//            }, response_failure: { error in
//                observer.onError(error)
//            })
//        }
//        return Observable.create({ observer -> Disposable in
//            post_createClub(token: token, createClub: createClub, image: image, response_success: { soloClub in
//                observer.onNext(soloClub)
//            }, response_message: { message in
//                //                observer.onError(<#T##error: Error##Error#>)
//                //                observer.onError(message)
//            }, response_failure: { error in
//                observer.onError(error)
//            })
//        })
//        return Disposables.create() as! Observable<SoloClub>
//        
//    }
    
    func post_createClub(token: String, createClub: CreateClub, image: UIImage?, response_success: @escaping (SoloClub) -> (), response_message: @escaping (SingleLineMessage) -> (), response_failure: @escaping (Error) -> ()) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                if let mImage = image {
                    multipartFormData.append(mImage.jpegData(compressionQuality: 1.0)!, withName: "logo", fileName: "jpg", mimeType: "image/jpg")
                }
                for (key, value) in createClub.toParams() {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_create_club),
                    method: .post,
                    headers: ["auth" : token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseSoloClub(completionHandler: { (response) in
                        switch response.result {
                        case .success:
                            if let club = response.result.value {
                                response_success(club)
                            }
                        case .failure(let error):
                            upload.responseSingleLineMessage(completionHandler: { (response) in
                                switch response.result {
                                case .success:
                                    if let message = response.result.value {
                                        response_message(message)
                                    }
                                case .failure(let error):
                                    Print.m(error)
                                    response_failure(error)
                                }
                            })
                        }
                    })
                    
                case .failure(let error):
                    response_failure(error)
                }
        }
    }
    
    func post_teamAcceptRequest(token: String, acceptInfo: AcceptRequest, response_success: @escaping (SoloPerson) -> (), response_message: @escaping (SingleLineMessage)->(), response_failure: @escaping (Error) -> ()) {
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
                    
//                    upload.responseJSON(completionHandler: { response in
//                    })
                    
                    upload.responseSoloPerson(completionHandler: { response in
                        switch response.result {
                        case .success:
                            if let user = response.result.value {
                                response_success(user)
                            }
                        case .failure(let error):
                            upload.responseSingleLineMessage(completionHandler: { response in
                                switch response.result {
                                case .success(let value):
                                    response_message(value)
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
    
    func post_editTeam(token: String, editTeam: EditTeam, response_success: @escaping (EditTeamResponse) -> (), response_failure: @escaping (Error) -> (), response_single_line_message: @escaping (SingleLineMessage) -> ()) {
        
//        Print.m(String(data: try! JSONSerialization.data(withJSONObject: editTeam.toParams(), options: .prettyPrinted), encoding: .utf8))
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "auth" : "\(token)"
        ]
        
//        request(ApiRoute.getApiURL(.post_edit_team), method: .post, parameters: editTeam.toParams(), encoding: JSONEncoding.default, headers: header)
////            .validate()
//            .responseJSON { (response) in
//                switch response.result {
//                case .success:
//                    Print.m(response.result.value)
//                    Print.m(String(data: response.data!, encoding: String.Encoding.utf8))
//                case .failure(let error):
//                    Print.m(error)
//                    response_failure(error)
//                }
//        }
        
        
        Alamofire
            .request(ApiRoute.getApiURL(.post_edit_team), method: .post, parameters: editTeam.toParams(), encoding: JSONEncoding.default, headers: header)
//            .responseJSON { (response) in
//                debugPrint(response)
//                Print.m(String(data: response.data!, encoding: String.Encoding.utf8))
//
//        }
            .responseEditTeamResponse { (response) in
                switch response.result {
                case .success:
                    if let editTeamResponse = response.result.value {
                        response_success(editTeamResponse)
                    }
                case .failure(let error):
                    Alamofire
                        .request(ApiRoute.getApiURL(.post_edit_team), method: .post, parameters: editTeam.toParams(), encoding: JSONEncoding.default, headers: header)
                        .responseSingleLineMessage(completionHandler: { response in
                            switch response.result {
                            case .success(let value):
                                response_single_line_message(value)
                            case .failure(let error):
                                response_failure(error)
                            }
                        })
//                    requestMessage(success: { message in
//                        response_single_line_message(message)
//                    }, failure: { error in
//                        response_failure(error)
//                    })
////                    response_failure(error)
                }
            }
        
//        Alamofire
//            .upload(multipartFormData: { (multipartFormData) in
//                for (key, value) in editTeam.toParams() {
//                    let strValue = value as! String
//                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
//                }
//            },
//                    usingThreshold: UInt64(),
//                    to: ApiRoute.getApiURL(.post_edit_team),
//                    method: .post,
//                    headers: ["auth" : token])
//            { (result) in
//                switch result {
//                case .success(let upload, _, _):
//
//                    upload.responseEditTeamResponse(completionHandler: { response in
//                        switch response.result {
//                        case .success:
//                            if let editTeamResponse = response.result.value {
//                                response_success(editTeamResponse)
//                            }
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
//
//                case .failure(let error):
//                    response_failure(error)
//                }
//        }
    }
    
    func post_createTeam(token: String, teamInfo: CreateTeamInfo, response_success: @escaping (SoloTeam) -> (), response_failure: @escaping (Error) -> (), response_failure_message: @escaping (SingleLineMessage) -> ()) {
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
                        case .failure(let _):
                            upload.responseSingleLineMessage(completionHandler: { (response) in
                                switch response.result {
                                case .success:
                                    if let singleLineMessage = response.result.value {
                                        response_failure_message(singleLineMessage)
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
    
//    func post_addPlayerToTeam(token: String, addPlayerToTeam: AddPlayerToTeam, response_success: @escaping (SingleLineMessage) -> (), response_failure: @escaping (Error) -> ()) {
//
//        let header: HTTPHeaders = [
//            "Content-Type" : "application/json",
//            "auth" : "\(token)"
//        ]
//
//        Alamofire
//            .request(ApiRoute.getApiURL(.post_add_player_team), method: .post, parameters: addPlayerToTeam.toParams(), encoding: JSONEncoding.default, headers: header)
//            .responseJSON(completionHandler: { response in
//                if response.error != nil {
//                    response_failure(response.error!)
//                    return
//                }
//                Print.m(response.result.value)
//                do {
//                    let decoder = JSONDecoder()
//                    let value = try decoder.decode(SingleLineMessage.self, from: response.data!)
//                    response_success(value)
//                } catch {
//                    Print.m("Все плохо, ты не знал?")
//                }
//
//
//            })
//            .responseSingleLineMessage(completionHandler: { (response) in
//                Print.m(response.result.value)
//                switch response.result {
//                case .success(let value):
//                    response_success(value)
//                case.failure(let error):
//                    response_failure(error)
//                }
//            })
//    }
    
    func post_matchSetReferee(token: String, editMatchReferees: EditMatchReferees, response_success: @escaping (SoloMatch) -> (), response_message: @escaping (SingleLineMessage) -> (), response_failure: @escaping (Error) -> ()) {
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "auth" : "\(token)"
        ]
        
//        Alamofire
//            .upload(multipartFormData: { (multipartFormData) in
//                multipartFormData.append(editMatchReferees.id.data(using: String.Encoding.utf8)!, withName: EditMatchReferees.Fields.id.value())
//
////                let encode = try? JSONEncoder().encode(editMatchReferees.referees.getArrayOfRefereesInDictionary())
//                let encodedReferees = try? JSONEncoder().encode(editMatchReferees.referees)
//                if let referees = encodedReferees {
//                    multipartFormData.append(referees, withName: EditMatchReferees.Fields.referees.value())
//                } else {
//                    Print.m("fail convert refere to referee")
//                    return
//                }
//            },
//                    usingThreshold: UInt64(),
//                    to: ApiRoute.getApiURL(.post_edit_match_referee),
//                    method: .post,
//                    headers: ["auth" : token])
//            { (result) in
//                switch result {
//                case .success(let upload, _, _):
//
//                    upload.responseJSON(completionHandler: { (response) in
//                        if response.error != nil {
//                            Print.m(response.error)
//                            return
//                        }
//                        Print.m(response.result.value)
//                    })
//
//                    upload.responseSoloMatch(completionHandler: { response in
//                        switch response.result {
//                        case .success:
//                            if let soloMatch = response.result.value {
//                                response_success(soloMatch)
//                            }
//                        case .failure(let error):
//                            upload.responseSingleLineMessage(completionHandler: { response in
//                                switch response.result {
//                                case .success:
//                                    if let message = response.result.value {
//                                        response_message(message)
//                                    }
//                                case .failure(let error):
//                                    response_failure(error)
//                                }
//                            })
//                        }
//                    })
//
//                case .failure(let error):
//                    response_failure(error)
//                }
//        }
        
        let request = Alamofire
            .request(ApiRoute.getApiURL(.post_edit_match_referee), method: .post, parameters: editMatchReferees.toParams(), encoding: JSONEncoding.default, headers: header)
        
            request
            .validate()
            .responseSoloMatch(completionHandler: { response in
                switch response.result {
                case .success:
                    if let soloMatch = response.result.value {
                        response_success(soloMatch)
                    }
                case .failure(let error):
                    responseMessage(success: { message in
                        response_message(message)
                    }, failure: { error in
                        response_failure(error)
                    })
                }
            })
//            .responseSingleLineMessage(completionHandler: { response in
//                switch response.result {
//                case .success:
//                    if let message = response.result.value {
//                        response_message(message)
//                    }
//                case .failure(let error):
//                    response_failure(error)
//                }
//            })
        
        func responseMessage(success: @escaping (SingleLineMessage) -> (), failure: @escaping (Error) -> ()) {
            request.responseSingleLineMessage { response in
                switch response.result {
                case .success:
                    if let message = response.result.value {
                        success(message)
                    }
                case .failure(let error):
                    failure(error)
                }
            }
        }
    }
    
    func post_changeProtocol(token: String, newProtocol: EditProtocol, success: @escaping (SoloMatch)->(), message: @escaping (SingleLineMessage) -> (), failure: @escaping (Error)->()) {
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "auth" : "\(token)"
        ]
        
        let instance = Alamofire
            .request(ApiRoute.getApiURL(.post_edit_protcol), method: .post, parameters: newProtocol.toParams(), encoding: JSONEncoding.default, headers: header)
        instance
            .responseSoloMatch(completionHandler: { response in
                if response.response?.statusCode == 500
                {
                    instance
                        .responseSingleLineMessage(completionHandler: { response in
                            switch response.result {
                            case .success(let value):
                                message(value)
                            case .failure(let error):
                                failure(error)
                            }
                        })
                }
                else
                {
                    switch response.result {
                    case .success(let value):
                        success(value)
                    case .failure(let error):
                        failure(error)
                    }
                }
            
        })
    }
    
    func post_acceptProtocol(token: String, id: String, success: @escaping (SoloMatch) -> (), message: @escaping (SingleLineMessage) -> (), failure: @escaping (Error) -> ()) {
//        let header: HTTPHeaders = [
//            "Content-Type" : "application/json",
//            "auth" : "\(token)"
//        ]
//        let parameter: Parameters = [
//            "_id" : id
//        ]
        
//        Alamofire
//            .request(ApiRoute.getApiURL(.post_accept_protocol), method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
//            .responseSingleLineMessage(completionHandler: { response in
//                switch response.result {
//                case .success(let value):
//                    success(value)
//                case .failure(let error):
//                    failure(error)
//                }
//            })
        
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                
                multipartFormData.append(id.data(using: String.Encoding.utf8)!, withName: "_id")
                
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_accept_protocol),
                    method: .post,
                    headers: ["auth" : token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON(completionHandler: { response in
//                        dump(response.result)
                    })
                    
                    upload.responseSoloMatch(completionHandler: { response in
                        switch response.result {
                        case .success(let value):
                            success(value)
                        case .failure(let error):
                            upload.responseSingleLineMessage(completionHandler: { response in
                                switch response.result {
                                case .success(let value):
                                    message(value)
                                case .failure(let error):
                                    failure(error)
                                }
                            })
                        }
                    })
                    
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    // MARK: - GET requests
    
    func get_tourney(name: String?, region: RegionMy? = nil, limit: Int? = Constants.Values.LIMIT, offset: Int? = 0, get_result: @escaping (ResultMy<[Tourney], RequestError>) -> ()) {
        var header: Parameters = [:]
        if let newName = name {
            if let newRegion = region {
                header = [
                    "_limit": String(limit!),
                    "_offset": String(offset!),
                    "name": newName,
                    "region": newRegion._id
//                    "name": "{" + newName + "}",
//                    "region": "{" + newRegion._id + "}"
                ]
            }
            else
            {
                header = [
//                    "limit": "{" + String(limit!) + "}",
//                    "offset": "{" + String(offset!) + "}",
                    "_limit": String(limit!),
                    "_offset": String(offset!),
                    "name": newName
//                    "name": "{" + newName + "}"
                ]
            }
            
        } else
        {
            if let newRegion = region {
                header = [
//                    "limit": "{" + String(limit!) + "}",
//                    "offset": "{" + String(offset!) + "}",
                    "_limit": String(limit!),
                    "_offset": String(offset!),
                    "region": newRegion._id
//                    "region": "{" + newRegion._id + "}"
                ]
            }
            else
            {
                header = [
                    "_limit": String(limit!),
                    "_offset": String(offset!),
//                    "limit": "{" + String(limit!) + "}",
//                    "offset": "{" + String(offset!) + "}"
                ]
            }
        }
        
//        Print.m(name)
        
        let alamofireInstance = Alamofire.request(ApiRoute.getApiURL(.tourney), method: .get, parameters: header , encoding: URLEncoding(destination: .queryString))
        alamofireInstance
            .responseJSON { response in
                let decoder = ISO8601Decoder.getDecoder()
                switch response.result
                {
                case .success:
                    do
                    {
                        if let tourneys = try? decoder.decode([Tourney].self, from: response.data!)
                        {
                            get_result(.success(tourneys))
                        }
                        if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!)
                        {
                            get_result(.message(message))
                        }
                    }
                case .failure(let error):
                    Print.m("failure \(error)")
                    let statusCode = response.response?.statusCode
                    if (400..<500).contains(statusCode!)
                    {
                        get_result(.failure(.local(error )))
                    }
                    else
                    if (500..<600).contains(statusCode!)
                    {
                        get_result(.failure(.server(error)))
                    }
                    else
                    {
                        get_result(.failure(.alamofire(error)))
                    }
                }
        }
    }
    
    func get_regions(get_result: @escaping (ResultMy<[RegionMy], RequestError>) -> ()) {
        let alamofireInstance = Alamofire.request(ApiRoute.getApiURL(.region), method: .get, encoding: JSONEncoding.default)
        alamofireInstance
            .responseJSON { response in
                let decoder = JSONDecoder()
                
                switch response.result
                {
                case .success:
                    do
                    {
                        if let myRegions = try? decoder.decode([RegionMy].self, from: response.data!)
                        {
                            get_result(.success(myRegions))
                        }
                        if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!)
                        {
                            get_result(.message(message))
                        }
                    }
                case .failure(let error):
                    let statusCode = response.response?.statusCode
                    if (400..<500).contains(statusCode!)
                    {
                        get_result(.failure(.local(error )))
                    }
                    else
                    if (500..<600).contains(statusCode!)
                    {
                        get_result(.failure(.server(error)))
                    }
                    else
                    {
                        get_result(.failure(.alamofire(error)))
                    }
                }
        }
    }
    
    func get_refreshAuthUser(token: String, success: @escaping (AuthUser) -> (), failure: @escaping (Error) -> ()) {
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "auth" : "\(token)"
        ]
        Alamofire
            .request(ApiRoute.getApiURL(.refreshUser), method: .get, encoding: JSONEncoding.default, headers: header)
//            .responseJSON(completionHandler: { response in
//                if let error = response.result.error {
//                    Print.m(error)
//                    return
//                }
//                do {
//                    let decoder = JSONDecoder()
//                    let decode = try decoder.decode(AuthUser.self, from: response.data!)
//                    Print.m(decode)
//                } catch {
//                    Print.m("error")
//                }
//            })
            .responseAuthUser { response in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    func get_upcomingMatches(get_result: @escaping (ResultMy<MmUpcomingMatches, RequestError>) -> ())
    {
        let alamoInstace = Alamofire
            .request(ApiRoute.getApiURL(.upcomingMatches))
//        alamoInstace
//            .responseMmUpcomingMatches { response in
//                switch response.result
//                {
//                case .success(let value):
//                    get_success(value)
//                case .failure(let error):
//                    alamoInstace.responseSingleLineMessage(completionHandler: { response in
//                        switch response.result
//                        {
//                        case .success(let value):
//                            case .failure(<#T##Error#>)
//                        }
//                    })
//                    get_failure(error)
//                }
//        }
        
        alamoInstace
            .validate()
            .responseJSON { response  in
                
                let decoder = JSONDecoder()
                
                switch response.result
                {
                case .success:
                    do
                    {
                        if let matches = try? decoder.decode(MmUpcomingMatches.self, from: response.data!)
                        {
                            get_result(.success(matches))
                        }
                        if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!)
                        {
                            get_result(.message(message))
                        }
                    }
                case .failure(let error):
                    let statusCode = response.response?.statusCode
                    if (400..<500).contains(statusCode!)
                    {
                        get_result(.failure(.local(error )))
                    }
                    else
                    if (500..<600).contains(statusCode!)
                    {
                        get_result(.failure(.server(error)))
                    }
                    else
                    {
                        get_result(.failure(.alamofire(error)))
                    }
                }
                
        }
    }
    
    func get_announces(get_result: @escaping (ResultMy<[Announce], Error>) -> ()) {
        let alamo = Alamofire.request(ApiRoute.getApiURL(.announce))
        alamo
            .validate()
            .responseJSON { response in
                let decoder = ISO8601Decoder.getDecoder()
                
                do
                {
                    if let announces = try? decoder.decode([Announce].self, from: response.data!)
                    {
                        get_result(.success(announces))
                        return
                    }
                    if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!)
                    {
                        get_result(.message(message))
                        return
                    }
                }
                
                if response.result.isFailure {
                    get_result(.failure(response.error!))
                }
        }
    }
    
    func get_activeMatches(limit: Int = 30, offset: Int = 0, played: String = "false", get_success: @escaping (ActiveMatches) -> (), get_message: @escaping (SingleLineMessage) -> (), get_failure: @escaping (Error) -> ()) {
        let parameters: Parameters = [
            "limit": limit,
            "offset": offset,
            "played": played
        ]
        
        let instance =
            Alamofire
            .request(ApiRoute.getApiURL(.activeMatches), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            
        instance.responseActiveMatches { (response) in
                switch response.result {
                case .success(let value):
                    get_success(value)
                case .failure(let error):
                    instance.responseSingleLineMessage(completionHandler: { response in
                        switch response.result {
                        case .success(let value):
                            get_message(value)
                        case .failure(let error):
                            get_failure(error)
                        }
                    })
                }
        }
    }
    
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
    
    func get_tournamets(limit: Int = 300, offset: Int = 0, get_success: @escaping (Tournaments) -> (), get_failure: @escaping (Error) -> ()) {
        let parameters: Parameters = [
            "limit": limit, // default values
            "offset": offset
        ]
        Alamofire
            .request(ApiRoute.getApiURL(.tournaments), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
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
    
    func get_getPerson(id: String, success: @escaping (GetPerson)->(), failure: @escaping (Error)->()) {
        Alamofire
            .request(ApiRoute.getApiURL(.soloUser, id: id))
            .responseGetPerson { (response) in
                switch response.result {
                case .success(let getPerson):
                    success(getPerson)
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    func get_referees(get_success: @escaping (Players) -> (), get_failure: @escaping (Error) -> ()) {
        let parameters: Parameters = [
            "type": "referee"//,
//            "limit": 32575,
//            "offset": 0
        ]
        
        Alamofire
            .request(ApiRoute.getApiURL(.getusers), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            .responsePlayers { response in
//                Print.m(response.result)
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
            "search": query,
            "limit": 999
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
        let parameters: Parameters = [
            "limit": 999
        ]
        Alamofire
            .request(ApiRoute.getApiURL(.clubs), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
//            .request(ApiRoute.getApiURL(.clubs))
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
    
    func get_clubById(id: String, get_success: @escaping (SoloClub) -> (), get_failure: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.clubs, id: id))
            .responseSoloClub { (response) in
                switch response.result {
                case .success:
                    if let club = response.result.value {
                        get_success(club)
                    }
                case .failure(let error):
                    get_failure(error)
                }
        }
    }
    
    func getActiveMatchesForView(get_success: @escaping (ActiveMatches, Players, [SoloClub]) -> (), get_message: @escaping (SingleLineMessage) -> (), get_failure: @escaping (Error) -> ()) {
        
        var fActiveMatches = ActiveMatches()
        var fReferees = Players()
        var fClubs: [SoloClub] = []
        
        let group = DispatchGroup()
        
        group.enter()
        get_activeMatches(get_success: { (activeMatches) in
            
            fActiveMatches = activeMatches
            
            if fActiveMatches.matches.count > 0
            {
                for element in fActiveMatches.matches
                {
                    
                    if element.teamOne.club?.count ?? 0 > 1
                    {
                        group.enter()
                        self.get_clubById(id: element.teamOne.club ?? "", get_success: { (club) in
                            
                            fClubs.append(club)
                            
                            group.leave()
                            
                        }, get_failure: { (error) in
                            get_failure(error)
                        })
                    }
                    
                    if element.teamTwo.club?.count ?? 0 > 1
                    {
                        group.enter()
                        self.get_clubById(id: element.teamTwo.club ?? "", get_success: { (club) in
                            
                            fClubs.append(club)
                            
                            group.leave()
                            
                        }, get_failure: { (error) in
                            get_failure(error)
                        })
                    }
                    
                }
            }
            
            group.leave()
            
        }, get_message: { message in
            get_message(message)
        }) { (error) in
            get_failure(error)
        }
        
        group.enter()
        get_referees(get_success: { (referees) in
            fReferees = referees
            
            group.leave()
            
        }) { (error) in
            get_failure(error)
        }
        
        group.notify(queue: .main) {
            get_success(fActiveMatches, fReferees, fClubs)
        }
    }
    
    func get_forMyMatches(participationMatches: [ParticipationMatch], get_success: @escaping ([MyMatchesRefTableViewCell.CellModel]) -> (), get_failure: @escaping (Error) -> ()) {
        var fParticipationMatches: [ParticipationMatch] = []
//        Print.m(participationMatches)
        var fClubs: [Club] = []
        
        var models: [MyMatchesRefTableViewCell.CellModel] = []
        
        var tmpTournaments = Tournaments()
        
        let dispatchGroup = DispatchGroup()
        
        fParticipationMatches = participationMatches
//        Print.m(fParticipationMatches)
        
        if fParticipationMatches.count > 0 {
            dispatchGroup.enter()
            get_tournamets(get_success: { (tournaments) in
                tmpTournaments = tournaments
            
                for parMatch in fParticipationMatches {
                    
                    if parMatch.league.count > 1
                    {
//                        Print.m("Par match league > 1")
                        dispatchGroup.enter()
                        let tmpTeams = tmpTournaments.leagues.filter({ (league) -> Bool in
                            return league.id == parMatch.league
                        }).first?.teams
//                        Print.m(tmpTeams)
                        var tmpClub1: Club?
                        
                        if parMatch.teamOne.count > 1
                        {
                            dispatchGroup.enter()
                            let tmpTeam1 = tmpTeams?.filter({ (team) -> Bool in
                                return parMatch.teamOne == team.id
                            }).first
                            let tmpClubId = tmpTeam1?.club
//                            Print.m(tmpClubId)
                            dispatchGroup.leave()
//                            Print.m(tmpClubId)
                            if tmpClubId?.count ?? 0 > 1
                            {
//                                Print.m(tmpClubId!)
                                dispatchGroup.enter()
                                self.get_clubById(id: tmpClubId!, get_success: { (soloClub) in
                                    fClubs.append(soloClub.club)
                                    tmpClub1 = soloClub.club
                                    dispatchGroup.leave()
                                    
                                    var tmpClub2: Club?
                                    
                                    if parMatch.teamTwo.count > 1
                                    {
                                        dispatchGroup.enter()
                                        let tmpTeam2 = tmpTeams?.filter({ (team) -> Bool in
                                            return parMatch.teamTwo == team.id
                                        }).first
                                        let tmpClubId = tmpTeam2?.club
                                        dispatchGroup.leave()
                                        
                                        if tmpClubId?.count ?? 0 > 1 {
                                            dispatchGroup.enter()
                                            self.get_clubById(id: tmpClubId!, get_success: { (soloClub) in
                                                fClubs.append(soloClub.club)
                                                tmpClub2 = soloClub.club
                                                
//                                                let value = MyMatchesRefTableViewCell.CellModel(
//                                                    participationMatch: parMatch,
//                                                    club1: tmpClub1!,
//                                                    club2: tmpClub2!,
//                                                    team1Name: tmpTeam1!.name,
//                                                    team2Name: tmpTeam2!.name)
                                                
                                                
                                                models.append(MyMatchesRefTableViewCell.CellModel(
                                                    participationMatch: parMatch,
                                                    club1: tmpClub1!,
                                                    club2: tmpClub2!,
                                                    team1Name: tmpTeam1!.name,
                                                    team2Name: tmpTeam2!.name)
                                                )
                                                get_success(models)
                                                
                                                dispatchGroup.leave()
                                            }, get_failure: { (error) in
                                                get_failure(error)
                                            })
                                        }
                                    }
                                    
                                }, get_failure: { (error) in
                                    get_failure(error)
                                })
                            }
                        }
                        

                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.leave()
                
            }) { (error) in
                get_failure(error)
            }
            
            dispatchGroup.notify(queue: .main) {
//                Print.m(models)
//                Print.m(models)
                get_success(models)
            }
        }
        
    }
    
//    func get_news(success: @escaping (NewsOld) -> (), failure: @escaping (Error) -> ()) {
//        Alamofire
//            .request(ApiRoute.getApiURL(.news))
//            .responseNews { response in
//                switch response.result {
//                case .success(let value):
//                    success(value)
//                case .failure(let error):
//                    failure(error)
//                }
//        }
//    }
    
    func get_news(tourney: String? = nil, limit: Int? = Constants.Values.LIMIT, offset: Int? = 0 , get_result: @escaping (ResultMy<[News], Error>) -> ()) {
        
        var parameters: [String : Any] = [:]
        
//        if tourney == nil {
//            parameters = [
//                "limit": limit,
//                "offset": offset
//            ]
//        } else {
//            parameters = [
//                "tourney": tourney, // MARK: CHECK HERE
//                "limit": limit,
//                "offset": offset
//            ]
//        }
        
        
        let alamofireInstance = Alamofire.request(ApiRoute.getApiURL(.news), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
        alamofireInstance
            .responseJSON { response in
                
                let decoder = ISO8601Decoder.getDecoder()
                
                do
                {
                    if let news = try? decoder.decode([News].self, from: response.data!)
                    {
                        get_result(.success(news))
                        return
                    }
                    if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!)
                    {
                        get_result(.message(message))
                        return
                    }
                }
                
                response.result.ifFailure {
                    get_result(.failure(response.result.error!))
                }
        }
        
        alamofireInstance.response
    }
    
//    func get_news(get_result: @escaping (ResultMy<NewsOld, RequestError>) -> ()) {
//        let alamo = Alamofire.request(ApiRoute.getApiURL(.news))
//        alamo
//            .validate()
//            .responseJSON { response in
//                //                dump(response)
//                let decoder = JSONDecoder()
//                switch response.result
//                {
//                case .success:
//                    do
//                    {
//                        if let news = try? decoder.decode(News.self, from: response.data!)
//                        {
//                            get_result(.success(news))
//                            return
//                        }
//                        if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!)
//                        {
//                            get_result(.message(message))
//                            return
//                        }
//                    }
//                case .failure(let error):
//                    let statusCode = response.response?.statusCode
//                    if (400..<500).contains(statusCode!)
//                    {
//                        get_result(.failure(.local(error)))
//                        return
//                    }
//                    else
//                        if (500..<600).contains(statusCode!)
//                        {
//                            get_result(.failure(.server(error)))
//                            return
//                        }
//                        else
//                        {
//                            get_result(.failure(.alamofire(error)))
//                            return
//                    }
//                }
//        }
//    }
    
    func get_announces(success: @escaping ([Announce]) -> (), failure: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.announce))
            .responseAnnounce { response in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    func getClubs(success: @escaping (Clubs) -> (), failure: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.clubs))
            .responseClubs { response in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    func get_soloPerson(playerId: String, success: @escaping (SoloPerson) -> (), failure: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.soloUser, id: playerId))
            .validate()
            .responseSoloPerson { (response) in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    // MARK: TOURNEY MODEL ITEM
    func get_league(
        tourneys: [Tourney]?,
        limit: Int? = Constants.Values.LIMIT,
        offset: Int? = 0,
        get_result: @escaping (ResultMy<[TourneyModelItem], Error>) -> ())
    {
        var mMessage: SingleLineMessage?
        var mError: Error?
        var tourneyModelItems: [TourneyModelItem] = []
        let group = DispatchGroup()
        
        guard let mTourneys = tourneys else { return }
        group.enter()
        
        for t in mTourneys {
            tourneyModelItems.append(TourneyModelItem(tourney: t, leagues: nil))
        }
        for i in 0..<tourneyModelItems.count {
            
            group.enter()

            self.get_leagues_by_single(tourney: tourneyModelItems[i].tourney) { result in
                switch result {
                case .success(let leagues):
                    Print.m(leagues)
                    tourneyModelItems[i].leagues = leagues
                    group.leave()
                case .message(let message):
                    Print.m(message.message)
                    mMessage = message
                    group.leave()
                case .failure(let error):
                    Print.m(error.localizedDescription)
                    mError = error
                    group.leave()
                }
            }
        }
        group.leave()
        
        group.notify(queue: .main) {
//            Print.m("message is \(mMessage?.message), error is \(mError), items are \(tourneyModelItems)")
            if let message = mMessage {
                get_result(.message(message))
            }
            if let error = mError {
                get_result(.failure(error))
            }
            
            get_result(.success(tourneyModelItems))
        }
        
    }
    
    func get_leagues_by_single(
        tourney: Tourney?,
        get_result: @escaping (ResultMy<[LeagueModelItem], Error>) -> ())
    {
        guard let mTourney = tourney else {
            get_result(.success([]))
            return
        }
        let params = ["tourney" : mTourney.id!]
//        Print.m(params)
        
        Alamofire
            .request(ApiRoute.getApiURL(.league), method: .get, parameters: params , encoding: URLEncoding(destination: .queryString))
            .responseJSON(completionHandler: { response in
                let decoder = ISO8601Decoder.getDecoder()
                Print.m("\(response.result)) || tourney  <= \(mTourney.id!)")
                do {
                    if let leagues = try? decoder.decode([_League].self, from: response.data!) {
                        let leaguees = leagues.map({ league -> LeagueModelItem in
                            return LeagueModelItem(league: league)
                        })
                        Print.m("leagues => \(leaguees)")
                        get_result(.success(leagues.map({ league -> LeagueModelItem in
                            return LeagueModelItem(league: league)
                        })))
//                        Print.m("it is not decoding")
                    } else {
//                        dump(response)
//                        Print.m(try! decoder.decode([_League].self, from: response.data!))
                        get_result(.success([]))
                    }
                    if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!) {
                        get_result(.message(message))
                    }
                } catch {
                    Print.m(error)
                }
                if response.result.isFailure {
                    get_result(.failure(response.result.error!))
                }
            })
    }
    
    // MARK: END
    
}
