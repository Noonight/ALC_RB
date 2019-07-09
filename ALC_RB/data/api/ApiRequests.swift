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
        
//        Print.m("token - >> \(token)")
//        Print.m("club - >> \(clubInfo)")
        
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
                if let image = image {
                    multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: "logo", fileName: "jpg", mimeType: "image/jpg")
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
//                        dump(response.result.value)
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
//                    dump(response)
//                case .failure(let error):
//                    Print.m(error)
//                    response_failure(error)
//                }
//        }
        
//        dump(editTeam.toParams())
        
        _ = Alamofire
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
                    response_failure(error)
                }
            }
            .responseSingleLineMessage { (response) in
                switch response.result {
                case .success:
                    if let singleLineMessage = response.result.value {
                        response_single_line_message(singleLineMessage)
                    }
                case .failure(let error):
                    response_failure(error)
                }
            }
//        debugPrint(request)
        
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
    
    func post_addPlayerToTeam(token: String, addPlayerToTeam: AddPlayerToTeam, response_success: @escaping (SingleLineMessage) -> (), response_failure: @escaping (Error) -> (), response_single_line_message: @escaping (SingleLineMessage) -> ()) {
        
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "auth" : "\(token)"
        ]
        
        Alamofire
            .request(ApiRoute.getApiURL(.post_add_player_team), method: .post, parameters: addPlayerToTeam.toParams(), encoding: JSONEncoding.default, headers: header)
            .responseSingleLineMessage(completionHandler: { (response) in
                switch response.result {
                case .success:
//                    Print.m(response.result.error)
                    let statusCode = response.response?.statusCode ?? 0
                    switch statusCode {
                    case 200...299:
                        if let singleLineMessage = response.result.value {
                            response_success(singleLineMessage)
                        }
                    default:
                        if let singleLineMessage = response.result.value {
                            response_single_line_message(singleLineMessage)
                        }
                    }
                case.failure(let error):
                    if let singleLineMessage = response.result.value {
                        response_single_line_message(singleLineMessage)
                    } else {
                        response_failure(error)
                    }
                }
            })
    }
    
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
//                        dump(response)
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
//                dump(response)
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
    
    func post_changeProtocol(token: String, newProtocol: EditProtocol, success: @escaping (SoloMatch)->(), failure: @escaping (Error)->()) {
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "auth" : "\(token)"
        ]
        
        Alamofire
            .request(ApiRoute.getApiURL(.post_edit_protcol), method: .post, parameters: newProtocol.toParams(), encoding: JSONEncoding.default, headers: header)
            .responseSoloMatch(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
//                    Print.m(error)
                    failure(error)
                }
            })
//        func responseMessage(success: @escaping (SingleLineMessage) -> (), failure: @escaping (Error) -> ()) {
//            request.responseSingleLineMessage { response in
//                switch response.result {
//                case .success:
//                    if let message = response.result.value {
//                        success(message)
//                    }
//                case .failure(let error):
//                    failure(error)
//                }
//            }
//        }
    }
    
    // MARK: - GET requests
    
    func get_activeMatches(limit: Int = 30, offset: Int = 0, played: String = "false", get_success: @escaping (ActiveMatches) -> (), get_failure: @escaping (Error) -> ()) {
        let parameters: Parameters = [
            "limit": limit,
            "offset": offset,
            "played": played
        ]
        
        Alamofire
            .request(ApiRoute.getApiURL(.activeMatches), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            .responseActiveMatches { (response) in
//                dump(response)
//                dump(response.result)
                switch response.result {
                case .success:
                    if let activeMatches = response.result.value {
//                        dump(activeMatches)
                        get_success(activeMatches)
                    }
                case .failure(let error):
                    get_failure(error)
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
//                dump(response)
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
    
    func getActiveMatchesForView(get_success: @escaping (ActiveMatches, Players, [SoloClub]) -> (), get_failure: @escaping (Error) -> ()) {
        
        var fActiveMatches = ActiveMatches()
        var fReferees = Players()
        var fClubs: [SoloClub] = []
        
        let group = DispatchGroup()
        
        group.enter()
        get_activeMatches(get_success: { (activeMatches) in
            
//            var tmpActiveMatch1 = ActiveMatch()
//
//            var tmpTeam1 = Team()
//            tmpTeam1.club = "5be94cd706af1163449429eb"
//            tmpActiveMatch1.teamOne = tmpTeam1
//            var tmpTeam2 = Team()
//            tmpTeam2.club = "5c12554c8962d414ff27f8d1"
//            tmpActiveMatch1.teamTwo = tmpTeam2
//
//            var tmpRef1 = Referee().with(id: "Some id", type: Referee.RefereeType.referee1.rawValue, person: "5bf26cc5bd6d4060caa005ba")
//            var tmpTimekeeper = Referee().with(id: "Some id too", type: Referee.RefereeType.timekeeper.rawValue, person: "5bf26cd0bd6d4060caa005bb")
//
//            tmpActiveMatch1.referees.append(tmpRef1)
//            tmpActiveMatch1.referees.append(tmpTimekeeper)
//
////            var tmpActiveMatch2 = ActiveMatch()
//
//
//            let tmpActiveMatches = ActiveMatches(matches: [tmpActiveMatch1], count: 1)
////            fActiveMatches = activeMatches
//
//            fActiveMatches = tmpActiveMatches
            
            fActiveMatches = activeMatches
            
            if fActiveMatches.matches.count > 0
            {
                for element in fActiveMatches.matches
                {
                    
                    if element.teamOne.club.count > 1
                    {
                        group.enter()
                        self.get_clubById(id: element.teamOne.club, get_success: { (club) in
                            
                            fClubs.append(club)
                            
                            group.leave()
                            
                        }, get_failure: { (error) in
                            get_failure(error)
                        })
                    }
                    
                    if element.teamTwo.club.count > 1
                    {
                        group.enter()
                        self.get_clubById(id: element.teamTwo.club, get_success: { (club) in
                            
                            fClubs.append(club)
                            
                            group.leave()
                            
                        }, get_failure: { (error) in
                            get_failure(error)
                        })
                    }
                    
                }
            }
            
            group.leave()
            
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
//            dump(fActiveMatches)
//            dump(fReferees)
//            dump(fClubs)
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
                                                
//                                                dump(value)
                                                
                                                models.append(MyMatchesRefTableViewCell.CellModel(
                                                    participationMatch: parMatch,
                                                    club1: tmpClub1!,
                                                    club2: tmpClub2!,
                                                    team1Name: tmpTeam1!.name,
                                                    team2Name: tmpTeam2!.name)
                                                )
//                                                Print.m(models)
//                                                dump(models)
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
    
}
