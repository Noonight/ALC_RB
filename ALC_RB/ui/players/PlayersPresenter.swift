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
    func onGetPlayersSuccess(_ players: Players)
    
    func onRequestQueryPersonsSuccess(players: Players)
    func onRequestQueryPersonsFailure(error: Error)
}

class PlayersPresenter: MvpPresenter<PlayersTableViewController> {
    
    let apiService = ApiRequests()
    
    func getPlayers() {
        let parameters: Parameters = [
            "type": "player"
        ]
        
        Alamofire
            .request(ApiRoute.getApiURL(.getusers), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            .responsePlayers { response in
                if let player = response.result.value {
                    //try! print(player.jsonString())
                    self.getView().onGetPlayersSuccess(player)
                }
                //print(response.request)
        }
    }
    
    func getPlayers(limit: Int, offset: Int) {
        let parameters: Parameters = [
            "type": "player",
            "limit": limit,
            "offset": offset
        ]
        
        Alamofire
            .request(ApiRoute.getApiURL(.getusers), method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            .responsePlayers { response in
                if let player = response.result.value {
                    self.getView().onGetPlayersSuccess(player)
                }
        }
    }
    
    func searchPlayers(query: String) {
        apiService.get_playersWithQuery(query: query, get_success: { (players) in
            self.getView().onRequestQueryPersonsSuccess(players: players)
        }) { (error) in
            self.getView().onRequestQueryPersonsFailure(error: error)
        }
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
