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
    
    
    
    // TODO: delete it
    // deprecated
    
    
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
    
    
    
//    func post_matchSetReferee(token: String, editMatchReferees: EditMatchReferees, response_success: @escaping (Match) -> (), response_message: @escaping (SingleLineMessage) -> (), response_failure: @escaping (Error) -> ()) {
//
//        let header: HTTPHeaders = [
//            "Content-Type" : "application/json",
//            "auth" : "\(token)"
//        ]
//
//        let request = Alamofire
//            .request(ApiRoute.getApiURL(.post_edit_match_referee), method: .post, parameters: editMatchReferees.toParams(), encoding: JSONEncoding.default, headers: header)
//            .responseSoloMatch(completionHandler: { response in
//                switch response.result {
//                case .success:
//                    if let soloMatch = response.result.value {
//                        response_success(soloMatch)
//                    }
//                case .failure(let error):
//                    responseMessage(success: { message in
//                        response_message(message)
//                    }, failure: { error in
//                        response_failure(error)
//                    })
//                }
//            })
//
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
//    }
    
    // MARK: - GET requests
    
//    func get_clubs(get_success: @escaping ([Club]) -> (), get_failure: @escaping (Error) -> ()) {
//        let parameters: Parameters = [
//            "limit": 999
//        ]
//        Alamofire
//            .request(ApiRoute.getApiURL(.clubs), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
////            .request(ApiRoute.getApiURL(.clubs))
//            .responseClubs { response in
//                switch response.result {
//                case .success:
//                    if let clubs = response.result.value {
//                        get_success(clubs)
//                    }
//                case .failure(let error):
//                    get_failure(error)
//                }
//
//        }
//    }
    
    
    
//    func getActiveMatchesForView(get_success: @escaping (ActiveMatches, Players, [Club]) -> (), get_message: @escaping (SingleLineMessage) -> (), get_failure: @escaping (Error) -> ()) {
//
//        var fActiveMatches = ActiveMatches()
//        var fReferees = [Person]()
//        var fClubs: [Club] = []
//
//        let group = DispatchGroup()
//
//        group.enter()
//        get_activeMatches(get_success: { (activeMatches) in
//
//            fActiveMatches = activeMatches
//
//            if fActiveMatches.matches.count > 0
//            {
//                for element in fActiveMatches.matches
//                {
//
////                    if element.teamOne.club?.count ?? 0 > 1
////                    {
////                        group.enter()
////                        self.get_clubById(id: element.teamOne.club ?? "", get_success: { (club) in
////
////                            fClubs.append(club)
////
////                            group.leave()
////
////                        }, get_failure: { (error) in
////                            get_failure(error)
////                        })
////                    }
////
////                    if element.teamTwo.club?.count ?? 0 > 1
////                    {
////                        group.enter()
////                        self.get_clubById(id: element.teamTwo.club ?? "", get_success: { (club) in
////
////                            fClubs.append(club)
////
////                            group.leave()
////
////                        }, get_failure: { (error) in
////                            get_failure(error)
////                        })
////                    }
//
//                }
//            }
//
//            group.leave()
//
//        }, get_message: { message in
//            get_message(message)
//        }) { (error) in
//            get_failure(error)
//        }
//
////        group.enter()
////        get_referees(get_success: { (referees) in
////            fReferees = referees
////
////            group.leave()
////
////        }) { (error) in
////            get_failure(error)
////        }
//
//        group.notify(queue: .main) {
//            get_success(fActiveMatches, fReferees, fClubs)
//        }
//    }
    
//    func get_forMyMatches(participationMatches: [Match], get_success: @escaping ([MyMatchesRefTableViewCell.CellModel]) -> (), get_failure: @escaping (Error) -> ()) {
//        var fParticipationMatches: [Match] = []
////        Print.m(participationMatches)
//        var fClubs: [Club] = []
//
//        var models: [MyMatchesRefTableViewCell.CellModel] = []
//
//        var tmpTournaments = [Tourney]()
//
//        let dispatchGroup = DispatchGroup()
//
//        fParticipationMatches = participationMatches
////        Print.m(fParticipationMatches)
//
//        if fParticipationMatches.count > 0 {
//            dispatchGroup.enter()
//            get_tournamets(get_success: { (tournaments) in
//                tmpTournaments = tournaments
//
//                for parMatch in fParticipationMatches {
//
//                    if parMatch.league.count > 1
//                    {
////                        Print.m("Par match league > 1")
//                        dispatchGroup.enter()
//                        let tmpTeams = tmpTournaments.leagues.filter({ (league) -> Bool in
//                            return league.id == parMatch.league
//                        }).first?.teams
////                        Print.m(tmpTeams)
//                        var tmpClub1: Club?
//
//                        Print.m(" team one = \(parMatch.teamOne). team two = \(parMatch.teamTwo)")
//                        if parMatch.teamOne.count > 1
//                        {
//                            dispatchGroup.enter()
//                            let tmpTeam1 = tmpTeams?.filter({ (team) -> Bool in
//                                return parMatch.teamOne == team.id
//                            }).first
//                            let tmpClubId = tmpTeam1?.club
////                            Print.m(tmpClubId)
//                            dispatchGroup.leave()
////                            Print.m(tmpClubId)
//                            if tmpClubId?.count ?? 0 > 1
//                            {
////                                Print.m(tmpClubId!)
//                                dispatchGroup.enter()
//                                self.get_clubById(id: tmpClubId!, get_success: { (soloClub) in
//                                    fClubs.append(soloClub.club)
//                                    tmpClub1 = soloClub.club
//                                    dispatchGroup.leave()
//
//                                    var tmpClub2: Club?
//
//                                    if parMatch.teamTwo.count > 1
//                                    {
//                                        dispatchGroup.enter()
//                                        let tmpTeam2 = tmpTeams?.filter({ (team) -> Bool in
//                                            return parMatch.teamTwo == team.id
//                                        }).first
//                                        let tmpClubId = tmpTeam2?.club
//                                        dispatchGroup.leave()
//
//                                        if tmpClubId?.count ?? 0 > 1 {
//                                            dispatchGroup.enter()
//                                            self.get_clubById(id: tmpClubId!, get_success: { (soloClub) in
//                                                fClubs.append(soloClub.club)
//                                                tmpClub2 = soloClub.club
//
//
//                                                models.append(MyMatchesRefTableViewCell.CellModel(
//                                                    participationMatch: parMatch,
//                                                    club1: tmpClub1!,
//                                                    club2: tmpClub2!,
//                                                    team1Name: tmpTeam1!.name,
//                                                    team2Name: tmpTeam2!.name)
//                                                )
//                                                get_success(models)
//
//                                                dispatchGroup.leave()
//                                            }, get_failure: { (error) in
//                                                get_failure(error)
//                                            })
//                                        }
//                                    }
//
//                                }, get_failure: { (error) in
//                                    get_failure(error)
//                                })
//                            }
//                        }
//                        else
//                        {
//                            var tmpTeam1 = String()
//                            var tmpTeam2 = String()
//                            for i in 0..<tmpTournaments.leagues.count {
//                                for j in 0..<tmpTournaments.leagues[i].teams!.count {
//                                    if tmpTournaments.leagues[i].teams![j].id == parMatch.teamOne {
//                                        tmpTeam1 = tmpTournaments.leagues[i].teams![j].name
//                                    }
//                                    if tmpTournaments.leagues[i].teams![j].id == parMatch.teamTwo {
//                                        tmpTeam2 = tmpTournaments.leagues[i].teams![j].name
//                                    }
//                                }
//                            }
//
//                            models.append(MyMatchesRefTableViewCell.CellModel(
//                                participationMatch: parMatch,
//                                club1: nil,
//                                club2: nil,
//                                team1Name: tmpTeam1,
//                                team2Name: tmpTeam2
//                            ))
//                        }
//
//                        dispatchGroup.leave()
//                    }
//                }
//
//                dispatchGroup.leave()
//
//            }) { (error) in
//                get_failure(error)
//            }
//
//            dispatchGroup.notify(queue: .main) {
//                get_success(models)
//            }
//        }
//
//    }
//
    // MARK: - MY MATCHES
    
    
//
    // MARK: - END
    
//    func get_soloPerson(playerId: String, success: @escaping (SinglePerson) -> (), failure: @escaping (Error) -> ()) {
//        Alamofire
//            .request(ApiRoute.getApiURL(.soloUser, id: playerId))
////            .request
////            .validate()
//            .responseSoloPerson { (response) in
//                switch response.result {
//                case .success(let value):
//                    success(value)
//                case .failure(let error):
//                    failure(error)
//                }
//        }
//    }
    
    // MARK: TOURNEY MODEL ITEM
    
    
    
    
    // MARK: END
    
    func get_leagueMatches(leagueId: String, result: @escaping (ResultMy<[Match], Error>) -> () ) {
        Alamofire
            .request(ApiRoute.getApiURL(.leagueMatches, id: leagueId))
            .responseJSON { response in
                
                let decoder = ISO8601Decoder.getDecoder()
                
                do {
                    if let matches = try? decoder.decode([Match].self, from: response.data!) { // MARK: TODO - league matches reques not ok see request
                        result(.success(matches))
                    }
                    if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!) {
                        result(.message(message))
                    }
                }
                
                if response.result.isFailure {
                    result(.failure(response.result.error!))
                }
        }
    }
    
    // MARK: - ACTIVE MATCHES
    
//    func get_scheduleRefereeData(resultMy: @escaping (ResultMy<(ActiveMatches, Players, [Club]), Error>) -> ()) {
//        let group = DispatchGroup()
//        let personApi = PersonApi()
//
//        var mMessage: SingleLineMessage?
//        var mError: Error?
//        var mResult = (ActiveMatches(), [Person](), [Club]())
//
//        group.enter()
//        self.get_activeMatches { result in
//            switch result {
//            case .success(let activeMatches):
//                mResult.0 = activeMatches
//
//                for match in activeMatches.matches {
//
//                    if let clubOne = match.teamOne.club {
//                        if clubOne.count > 2 {
//                            group.enter()
//                            self.get_club(id: clubOne) { result in
//                                switch result {
//                                case .success(let club):
//                                    mResult.2.append(club)
//                                case .message(let message):
//                                    mMessage = message
//                                case .failure(let error):
//                                    mError = error
//                                }
//                                group.leave()
//                            }
//                        }
//
//                    }
//
//                    if let clubTwo = match.teamTwo.club {
//                        if clubTwo.count > 2 {
//                            group.enter()
//                            self.get_club(id: clubTwo) { result in
//                                switch result {
//                                case .success(let club):
//                                    mResult.2.append(club)
//                                case .message(let message):
//                                    mMessage = message
//                                case .failure(let error):
//                                    mError = error
//                                }
//                                group.leave()
//                            }
//                        }
//
//                    }
//                }
//
//            case .message(let message):
//                mMessage = message
//            case .failure(let error):
//                mError = error
//            }
//            group.leave()
//        }
//        group.enter()
//        personApi.get_person(limit: Constants.Values.LIMIT_ALL) { result in
//            switch result {
//            case .success(let persons):
//                mResult.1 = Players(persons: persons, count: persons.count)
//            case .message(let message):
//                mMessage = message
//            case .failure(.notExpectedData):
//                Print.m("not expected data")
//            case .failure(.error(let error)):
//                mError = error
//            }
//            group.leave()
//        }
////        self.get_referees { result in
////            switch result {
////            case .success(let referees):
////                mResult.1 = referees
////            case .message(let message):
////                mMessage = message
////            case .failure(let error):
////                mError = error
////            }
////            group.leave()
////        }
//
//        group.notify(queue: .main) {
//            if let error = mError {
//                resultMy(.failure(error))
//            }
//            if let message = mMessage {
//                resultMy(.message(message))
//            }
//
//            resultMy(.success(mResult))
//
//        }
//
//    }
//
//    func get_activeMatches(resultMy: @escaping (ResultMy<ActiveMatches, Error>) -> ()) {
//        let parameters: Parameters = [
////            "type": "referee"//,
//                        "limit": 32575,
//                        "offset": 0
//        ]
//        Alamofire
//            .request(ApiRoute.getApiURL(.activeMatches), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
//            .responseData { response in
//                let decoder = ISO8601Decoder.getDecoder()
//                do {
//                    if let activeMatches = try? decoder.decode(ActiveMatches.self, from: response.data!) {
//                        resultMy(.success(activeMatches))
//                    }
//                    if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!) {
//                        resultMy(.message(message))
//                    }
//                }
//                if response.result.isFailure {
//                    resultMy(.failure(response.error!))
//                }
//        }
//    }
    
//    func get_referees(resultMy: @escaping (ResultMy<Players, Error>) -> ()) {
//        let parameters: Parameters = [
//            "type": "referee"//,
//            //            "limit": 32575,
//            //            "offset": 0
//        ]
//
//        Alamofire
//            .request(ApiRoute.getApiURL(.getusers), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
//            .responseData(completionHandler: { response in
//                let decoder = ISO8601Decoder.getDecoder()
//                do {
//                    if let referees = try? decoder.decode(Players.self, from: response.data!) {
//                        resultMy(.success(referees))
//                    }
//                    if let message = try? decoder.decode(SingleLineMessage.self, from: response.data!) {
//                        resultMy(.message(message))
//                    }
//                }
//                if response.result.isFailure {
//                    resultMy(.failure(response.error!))
//                }
//            })
//    }
    
}
