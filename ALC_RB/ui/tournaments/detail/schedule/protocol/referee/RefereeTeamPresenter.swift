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
    
    func fetchGetPerson(person id: String, success: @escaping (GetPerson)->(), failure: @escaping (Error)->()) {
        dataManager.get_getPerson(id: id, success: success, failure: failure)
    }
    
    func getReferee(referee id: String, get_referee: @escaping (SoloPerson) -> (), get_error: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.soloUser, id: id))
            .validate()
            .responseSoloPerson { (response) in
                switch response.result {
                case .success:
                    if let referee = response.result.value {
                        get_referee(referee)
                    }
                case .failure:
                    get_error(response.result.error!)
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
