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
    let error: PublishSubject<Error?> = PublishSubject()
    let message: PublishSubject<SingleLineMessage?> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    
//    private var newsCollection: HomeNewsCollection
    private let dataManger: ApiRequests
    
    init(newDataManager: ApiRequests) {
        self.dataManger = newDataManager
    }
    
    func fetch() {
        
        self.loading.onNext(true)
        dataManger.get_news { result in
            self.loading.onNext(false)
            switch result {
            case .success(let news):
                self.items.onNext(news.compactMap({ news -> NewsModelItem in
                    return NewsModelItem(news: news, tourney: nil)
                }))
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
    
}
