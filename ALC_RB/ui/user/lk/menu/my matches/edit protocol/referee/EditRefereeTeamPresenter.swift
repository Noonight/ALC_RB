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
    let personApi = PersonApi()
    
    func fetchGetPerson(person id: String, success: @escaping (Person)->(), failure: @escaping (Error)->()) {
        personApi.get_person { result in
            switch result {
            case .success(let persons):
                success(persons.first!)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
                failure(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
//        dataManager.get_getPerson(id: id, success: success, failure: failure)
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
