//
//  TourneysVM.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 15.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

final class MyTourneysVM {
    
    let items: PublishSubject<[TourneyModelItem]> = PublishSubject()
    private let tourneys: PublishSubject<[Tourney]> = PublishSubject()
    let error: PublishSubject<Error?> = PublishSubject()
    let message: PublishSubject<SingleLineMessage?> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    
    private let tourneyApi: TourneyApi
    private let leagueApi: LeagueApi
    private let localTourney = LocalTourneys()
    private let disposeBag = DisposeBag()
    private var firstLoad = true
    
    init(tourneyApi: TourneyApi, leagueApi: LeagueApi) {
        self.tourneyApi = tourneyApi
        self.leagueApi = leagueApi
        items
            .observeOn(MainScheduler.instance)
            .subscribe({
                guard let items = $0.element else { return }
                if items.count == 0 {
                    self.firstLoad = true
                } else {
                    self.firstLoad = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetch() {
        
        if firstLoad == true {
            self.loading.onNext(true)
        }
        
        tourneyApi
            .get_tourneyModelItems(tourneys: localTourney.getLocalTourneys(), resultMy: { result in
                self.loading.onNext(false)
                switch result {
                case .success(let modelItems):
                    self.items.onNext(modelItems)
                case .message(let message):
                    self.message.onNext(message)
                case .failure(let error):
                    self.error.onNext(error)
                }
            })
        
    }
    
    func fetchLeagueInfo(leagueId: String, success: @escaping ([League]) -> ()) {
        self.loading.onNext(true)
//        dataManager
//            .get_tournamentLeague(id: leagueId) { result in
//                self.loading.onNext(false)
//                switch result {
//                case .success(let leagueInfo):
//                    success(leagueInfo)
//                case .message(let message):
//                    self.message.onNext(message)
//                case .failure(let error):
//                    self.error.onNext(error)
//                }
//        }
        leagueApi.get_league(id: leagueId) { result in
            switch result {
            case .success(let leagues):
                success(leagues)
            case .message(let msg):
                Print.m(msg.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
}
