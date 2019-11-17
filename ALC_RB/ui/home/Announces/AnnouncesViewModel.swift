//
//  AnnouncesViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 14.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AnnouncesViewModel {
    
    let items: PublishSubject<[AnnounceModelItem]> = PublishSubject()
    private let announces: PublishSubject<[Announce]> = PublishSubject()
    let error: PublishSubject<Error?> = PublishSubject()
    let message: PublishSubject<SingleLineMessage?> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    
    private let announceApi: AnnounceApi
    private let localTourney = LocalTourneys()
    private let disposeBag = DisposeBag()
    
    init(announceApi: AnnounceApi) {
        self.announceApi = announceApi
        
        announces
            .map ({ mAnnounces -> [Announce] in
                let mTourneys = self.localTourney.getLocalTourneys()
                return mAnnounces.filter { mmAnnounce -> Bool in
                    return mTourneys.contains { tourney -> Bool in
                        return mmAnnounce.tourney?.orEqual(tourney.id) { $0.id == tourney.id } ?? false
//                        return mmAnnounce.tourney == tourney.id
                    }
                }
            })
            .flatMap ({ mAnnounces -> Observable<[AnnounceModelItem]> in
                let mTourneys = self.localTourney.getLocalTourneys()
                let mAnnounceModelItems = mAnnounces.map { mAnnounce -> AnnounceModelItem in
                    let announceModelItem = AnnounceModelItem(newAnnounce: mAnnounce, tourney: nil)
                    announceModelItem.tourney = mTourneys.filter({ mTourney -> Bool in
                        return mAnnounce.tourney?.orEqual(mTourney.id) { $0.id == mTourney.id } ?? false
//                        return mTourney.id == mAnnounce.tourney
                    }).first
                    return announceModelItem
                }
                return Observable.just(mAnnounceModelItems)
            })
            .subscribe ({ event in
                guard let elements = event.element else { return }
                self.items.onNext(elements)
            }).disposed(by: disposeBag)
    }
    
    func fetch() {
        
        self.loading.onNext(true)
        announceApi.get_announce { result in
            self.loading.onNext(false)
            switch result {
            case .success(let announces):
                self.announces.onNext(announces)
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
    
}
