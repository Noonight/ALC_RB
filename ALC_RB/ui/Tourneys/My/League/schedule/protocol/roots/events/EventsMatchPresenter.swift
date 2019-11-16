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
    
    private let apiPerson = PersonApi()
    
    func getPlayer(player id: String, get_player: @escaping (SinglePerson) -> (), get_error: @escaping (Error) -> ()) {
        apiPerson.get_person() { result in
            switch result {
            case .success(let person):
                get_player(SinglePerson(person: person.first!))
            case .failure(.error(let error)):
                get_error(error)
            default:
                Print.m("not used response")
            }
        }
//        Alamofire
//            .request(ApiRoute.getApiURL(.soloUser, id: id))
//            .validate()
//            .responseSoloPerson { (response) in
//                switch response.result {
//                case .success:
//                    if let player = response.result.value {
//                        get_player(player)
//                    }
//                case .failure:
//                    get_error(response.error!)
//                }
//        }
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

