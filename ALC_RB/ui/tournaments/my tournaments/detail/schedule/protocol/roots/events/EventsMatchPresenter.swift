//
//  EventsMatchPresenter.swift
//  ALC_RB
//
//  Created by mac on 13.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class EventsMatchPresenter: MvpPresenter<EventsMatchTableViewController> {
    
    func getPlayer(player id: String, get_player: @escaping (SoloPerson) -> (), get_error: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.soloUser, id: id))
            .validate()
            .responseSoloPerson { (response) in
                switch response.result {
                case .success:
                    if let player = response.result.value {
                        get_player(player)
                    }
                case .failure:
                    get_error(response.error!)
                }
        }
    }
    
    func getPlayerImage(player_photo: String, get_image: @escaping (UIImage) -> ()) {
        Alamofire
            .request(ApiRoute.getImageURL(image: player_photo))
            .responseImage { (response) in
                if let image = response.result.value {
                    get_image(image)
                }
        }
    }
    
}

