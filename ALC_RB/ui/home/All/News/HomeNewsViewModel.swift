//
//  HomeNewsViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

class HomeNewsViewModel {
    
    let items: PublishSubject<[NewsModelItem]> = PublishSubject()
    private let news: PublishSubject<[News]> = PublishSubject()
    let error: PublishSubject<Error?> = PublishSubject()
    let message: PublishSubject<SingleLineMessage?> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    
    private let dataManger: ApiRequests
    private let localTourney = LocalTourneys()
    private let disposeBag = DisposeBag()
    
    init(newDataManager: ApiRequests) {
        self.dataManger = newDataManager
        
        news
            .map({ mNews -> [News] in
                let mTourneys = self.localTourney.getLocalTourneys()
                return mNews.filter { mmNews -> Bool in
                    return mTourneys.contains { tourney -> Bool in
                        return mmNews.tourney == tourney.id
                    }
                }
            })
        .flatMap { news -> Observable<[NewsModelItem]> in
            let mTourneys = self.localTourney.getLocalTourneys()
            let mNewsModelItems = news.map { mNews -> NewsModelItem in
                let mNewsItem = NewsModelItem(news: mNews, tourney: nil)
                mNewsItem.tourney = mTourneys.filter({ mTourney -> Bool in
                    return mTourney.id == mNews.tourney
                }).first
                return mNewsItem
            }
            return Observable.just(mNewsModelItems)
        }
        .subscribe { event in
            guard let elements = event.element else { return }
            self.items.onNext(elements)
        }.disposed(by: disposeBag)
    }
    
    func fetch() {
        
        self.loading.onNext(true)
        dataManger.get_news { result in
            self.loading.onNext(false)
            switch result {
            case .success(let news):
                self.news.onNext(news)
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
    
}
