//
//  AnnoucnesPresenter.swift
//  ALC_RB
//
//  Created by ayur on 11.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol AnnouncesAllView : MvpView {
    func fetchAnnouncesSuccess(announces: Announce)
    func fetchAnnouncesFailure(error: Error)
}

class AnnouncesAllPresenter: MvpPresenter<AnnounceAllTableViewController> {
    let dataManager = ApiRequests()
    
    func fetch() {
        dataManager.get_announces(success: { announces in
            self.getView().fetchAnnouncesSuccess(announces: announces)
        }) { error in
            self.getView().fetchAnnouncesFailure(error: error)
        }
    }
}
