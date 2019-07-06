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

class EditRefereeTeamPresenter: MvpPresenter<EditRefereeTeamTableViewController> {
    
    let dataManager = ApiRequests()
    
    func fetchGetPerson(person id: String, success: @escaping (GetPerson)->(), failure: @escaping (Error)->()) {
        dataManager.get_getPerson(id: id, success: success, failure: failure)
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
