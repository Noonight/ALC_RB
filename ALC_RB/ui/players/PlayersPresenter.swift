//
//  PlayersPresenter.swift
//  ALC_RB
//
//  Created by ayur on 19.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol PlayersTableView: MvpView {
    func onGetPlayersSuccess(_ players: [Person])
    func onGetPlayersMessage(_ message: SingleLineMessage)
    func onGetPlayersFailure(_ error: Error)
//    func onGetPlayersDecode()
    
    func onRequestQueryPersonsSuccess(players: [Person])
    func onRequestQueryPersonsFailure(error: Error)
    
    func onFetchSuccess(players: [Person])
    func onFetchFailure(error: Error)
    
    func onFetchScrollSuccess(players: [Person])
    func onFetchScrollFailure(error: Error)
}

class PlayersPresenter: MvpPresenter<PlayersTableViewController> {
    
    let apiService = ApiRequests()
    let apiPerson = PersonApi()
    
    func fetch() {
        apiPerson.get_person { result in
            switch result {
            case .success(let persons):
                self.getView().onFetchSuccess(players: persons)
            case .message(let message):
                self.getView().onGetPlayersMessage(message)
            case .failure(.notExpectedData):
                Print.m("see decode")
            case .failure(.error(let error)):
                self.getView().onFetchFailure(error: error)
            }
        }
    }
    
    func fetchInfScroll(limit: Int = 20, offset: Int = 0) {
        apiPerson.get_person(limit: limit, offset: offset) { result in
            switch result {
            case .success(let persons):
                self.getView().onFetchScrollSuccess(players: persons)
            case .message(let message):
                self.getView().onGetPlayersMessage(message)
            case .failure(.notExpectedData):
                Print.m("see decode")
            case .failure(.error(let error)):
                self.getView().onFetchScrollFailure(error: error)
            }
        }
    }
    
    func getPlayers(limit: Int? = Constants.Values.LIMIT, offset: Int? = 0) {
        
        apiPerson.get_person { result in
            switch result {
            case .success(let persons):
                self.getView().onGetPlayersSuccess(persons)
            case .message(let message):
                self.getView().onGetPlayersMessage(message)
            case .failure(.notExpectedData):
                Print.m("see decode")
            case .failure(.error(let error)):
                self.getView().onGetPlayersFailure(error)
            }
        }
        
//        let parameters: Parameters = [
//            "type": "player"
//        ]
//
//        Alamofire
//            .request(ApiRoute.getApiURL(.getusers), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
//            .responsePlayers { response in
//                if let player = response.result.value {
//                    //try! print(player.jsonString())
//                    self.getView().onGetPlayersSuccess(player)
//                }
//                //print(response.request)
//        }
    }
    
//    func getPlayers(limit: Int, offset: Int) {
//        let parameters: Parameters = [
//            "type": "player",
//            "limit": limit,
//            "offset": offset
//        ]
//
//        Alamofire
//            .request(ApiRoute.getApiURL(.getusers), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
//            .responsePlayers { response in
//                if let player = response.result.value {
//                    self.getView().onGetPlayersSuccess(player)
//                }
//        }
//    }
    
    func searchPlayers(query: String) {
        apiPerson.get_personQuery(name: query, surname: query, lastname: query) { result in
            switch result {
            case .success(let persons):
                self.getView().onRequestQueryPersonsSuccess(players: persons)
            case .message(let message):
                self.getView().onGetPlayersMessage(message)
            case .failure(.error(let error)):
                self.getView().onFetchFailure(error: error)
            case .failure(.notExpectedData):
                Print.m("see decode")
            }
        }
//        apiService.get_playersWithQuery(query: query, get_success: { (players) in
//            self.getView().onRequestQueryPersonsSuccess(players: players)
//        }) { (error) in
//            self.getView().onRequestQueryPersonsFailure(error: error)
//        }
    }
    
    func getImage(imageName: String, setImage: @escaping (UIImage) -> ()) {
        Alamofire
            .request(ApiRoute.getImageURL(image: imageName))
            .responseImage { response in
                //debugPrint(response)
                
                if let img = response.result.value {
                    setImage(img)
                    //self.getView().hideLoading()
                }
        }
    }
    
}
