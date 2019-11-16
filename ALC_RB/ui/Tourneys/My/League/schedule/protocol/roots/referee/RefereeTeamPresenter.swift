//
//  RefereeTeamPresenter.swift
//  ALC_RB
//
//  Created by ayur on 12.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class RefereeTeamPresenter: MvpPresenter<RefereeTeamTableViewController> {
    
    let dataManager = ApiRequests()
    let personApi = PersonApi()
    
    func fetchGetPerson(person id: String, success: @escaping (Person)->(), failure: @escaping (Error)->()) {
        personApi.get_person(id: id) { result in
            switch result {
            case .success(let persons):
                success(persons.first!)
            case .failure(.error(let error)):
                failure(error)
            default:
                Print.m("not used response")
            }
        }
//        dataManager.get_getPerson(id: id, success: success, failure: failure)
    }
    
    func getReferee(referee id: String, get_referee: @escaping (SinglePerson) -> (), get_error: @escaping (Error) -> ()) {
//        Alamofire
//            .request(ApiRoute.getApiURL(.soloUser, id: id))
//            .validate()
//            .responseSoloPerson { (response) in
//                switch response.result {
//                case .success:
//                    if let referee = response.result.value {
//                        get_referee(referee)
//                    }
//                case .failure:
//                    get_error(response.result.error!)
//                }
//        }
        personApi.get_person(id: id) { result in
            switch result {
            case .success(let persons):
                get_referee(SinglePerson(person:persons.first!))
            case .failure(.error(let error)):
                get_error(error)
            default:
                Print.m("not used response")
            }
        }
    }
    
    func getRefereeImage(photo referee: String?, get_image: @escaping (UIImage) -> ()) {
        Alamofire
            .request(ApiRoute.getImageURL(image: referee!))
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
