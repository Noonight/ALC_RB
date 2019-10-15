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
    
    private let dataManager: ApiRequests
    private let localTourney = LocalTourneys()
    private let disposeBag = DisposeBag()
    
    init(newDataManager: ApiRequests) {
        self.dataManager = newDataManager
        
        announces
            .map ({ mAnnounces -> [Announce] in
                let mTourneys = self.localTourney.getLocalTourneys()
                return mAnnounces.filter { mmAnnounce -> Bool in
                    return mTourneys.contains { tourney -> Bool in
                        return mmAnnounce.tourney == tourney.id
                    }
                }
            })
            .flatMap ({ mAnnounces -> Observable<[AnnounceModelItem]> in
                let mTourneys = self.localTourney.getLocalTourneys()
                let mAnnounceModelItems = mAnnounces.map { mAnnounce -> AnnounceModelItem in
                    let announceModelItem = AnnounceModelItem(newAnnounce: mAnnounce, tourney: nil)
                    announceModelItem.tourney = mTourneys.filter({ mTourney -> Bool in
                        return mTourney.id == mAnnounce.tourney
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
        dataManager.get_announces { result in
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
