//
//  ClubCreateViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 24/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

protocol ClubCreateProtocol: MvpView {
    func responseCreateClubSuccessful(soloClub: SoloClub)
    func responseCreateClubMessageSuccessful(message: SingleLineMessage)
    func responseCreateClubFailure(error: Error)
    
    func fieldsIsEmpty()
}

class ClubCreatePresenter: MvpPresenter<ClubCreateViewController> {
    struct CreateClubCache {
        var createClub: CreateClub?
        var image: UIImage?
        
        init(createClub: CreateClub, image: UIImage?) {
            self.createClub = createClub
            self.image = image
        }
    }
    
    private var dataManager: ApiRequests?
    var createClubCache: CreateClubCache?
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func create(token: String, createClub: CreateClub, image: UIImage?) {
        if createClub.fieldsIsEmpty() || image == nil {
            self.getView().fieldsIsEmpty()
        } else {
            self.createClubCache = CreateClubCache(createClub: createClub, image: image)
            dataManager?.post_createClub(token: token, createClub: createClub, image: image, response_success: { soloClub in
                self.getView().responseCreateClubSuccessful(soloClub: soloClub)
            }, response_message: { message in
                self.getView().responseCreateClubMessageSuccessful(message: message)
            }, response_failure: { error in
                self.getView().responseCreateClubFailure(error: error)
            })
        }
    }
}
