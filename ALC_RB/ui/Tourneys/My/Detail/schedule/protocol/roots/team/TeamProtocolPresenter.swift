//
//  TeamProtocolPresenter.swift
//  ALC_RB
//
//  Created by ayur on 11.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

class TeamProtocolPresenter: MvpPresenter<TeamProtocolTableViewController> {
    
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
                    get_error(response.result.error!)
                }
        }
    }
    
    func getPlayerImage(photo player: String?, get_image: @escaping (UIImage) -> ()) {
        if (!(player?.isEmpty)!) {
            Alamofire
                .request(ApiRoute.getImageURL(image: player!))
                .validate()
                .responseImage { (response) in
                    switch response.result {
                    case .success:
                        if let image = response.result.value {
                            get_image(image)
                        }
                    case .failure:
                        get_image(UIImage(named: "ic_logo")!)
                    }
            }
        }
    }
    
}
