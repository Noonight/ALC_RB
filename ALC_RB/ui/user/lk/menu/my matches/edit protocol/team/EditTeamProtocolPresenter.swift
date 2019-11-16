//
//  TeamProtocolPresenter.swift
//  ALC_RB
//
//  Created by ayur on 11.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

class EditTeamProtocolPresenter: MvpPresenter<EditTeamProtocolTableViewController> {
    
    let personApi = PersonApi()
    
    func getPlayer(player id: String, get_player: @escaping (SinglePerson) -> (), get_error: @escaping (Error) -> ()) {
        personApi.get_person(id: id) { result in
            switch result {
            case .success(let persons):
                get_player(SinglePerson(person: persons.first!))
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
                get_error(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
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
//                    get_error(response.result.error!)
//                }
//        }
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
