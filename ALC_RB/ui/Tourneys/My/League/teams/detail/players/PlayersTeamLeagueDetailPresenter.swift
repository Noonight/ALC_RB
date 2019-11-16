//
//  PlayersTeamLeagueDetailPresenter.swift
//  ALC_RB
//
//  Created by ayur on 29.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

//protocol PlayersTeamLeagueDetailView : MvpView{
//    func onGetClubSuccess()
//}

class PlayersTeamLeagueDetailPresenter: MvpPresenter<PlayersTeamLeagueDetailViewController> {
    
    private lazy var personApi = PersonApi()
    private lazy var clubApi = ClubApi()
    
    // DEPRECATED: club is not used now
//    func getClub(club id: String, get_it: @escaping (Club) -> ()) {
//        Alamofire
//            .request(ApiRoute.getApiURL(.clubs, id: id))
//            .validate()
//            .responseSoloClub { (response) in
//                switch response.result {
//                case .success:
//                    if let soloClub = response.result.value {
//                        get_it(soloClub)
//                    }
//                case .failure:
//                    debugPrint("failure getting club \(#file) -> \(#function)")
//                }
//        }
//    }
    
//    func getClubImage(club id: String, get_image: @escaping (UIImage) -> ()) {
//        getClub(club: id) { (soloClub) in
//            Alamofire
//                .request(ApiRoute.getImageURL(image: soloClub.club.logo ?? ""))
//                .responseImage(completionHandler: { (response) in
//                    if let img = response.result.value {
//                        //debugPrint("getting Image club complete. \(#file) -> \(#function)")
//                        get_image(img)
//                    }
//                })
//        }
//    }
//
//    func getClubOwnerImage(club id: String, get_image: @escaping (UIImage) -> (), get_error: @escaping () -> ()) {
//        getClub(club: id) { (soloClub) in
//            Alamofire
//                .request(ApiRoute.getImageURL(image: soloClub.club.owner?.photo ?? ""))
//                .validate()
//                .responseImage(completionHandler: { (response) in
//                    switch response.result {
//                    case .success:
//                        if let img = response.result.value {
//                            //debugPrint("getting Image club owner complete. \(#file) -> \(#function)")
//                            get_image(img)
//                        }
//                    case .failure:
//                        get_error()
//                        //debugPrint("getting Image club owner error. \(#file) -> \(#function)")
//                    }
//
//                })
//        }
//    }
    
    func getPerson(id: String, result: @escaping (ResultMy<[Person], RequestError>) -> ()) {
        personApi.get_person(id: id, resultMy: result)
    }
    
//    func getTeamCreatorName(creator id: String, get_name: @escaping (String) -> ()) {
//        Alamofire
//            .request(ApiRoute.getApiURL(.soloUser, id: id))
//            .validate()
//            .responseSoloPerson { (response) in
////                debugPrint(response.result.description)
////                debugPrint(response.result.value)
////                debugPrint(response.data)
////                debugPrint(response)
//                if let name = response.result.value {
//                    //debugPrint("\(id) --- \(response.result.value)")
//                    get_name(name.person.surname)
//                }
//        }
//    }
//
//    func getPlayer(player id: String, get_player: @escaping (SinglePerson) -> ()) {
//        Alamofire
//            .request(ApiRoute.getApiURL(.soloUser, id: id))
//            .validate()
//            .responseSoloPerson { (response) in
//                if let person = response.result.value {
//                    get_player(person)
//                }
//        }
//    }
    
}
