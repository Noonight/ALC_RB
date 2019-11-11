//
//  RegionsViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 24.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class RegionsViewModel {
    
    let regions = PublishSubject<[RegionMy]>()
    let loading = PublishSubject<Bool>()
    let error = PublishSubject<Error?>()
    let message = PublishSubject<SingleLineMessage>()
    
    let choosedRegion = BehaviorRelay<RegionMy?>(value: nil)
    let regionApi: RegionApi
    
    init(regionApi: RegionApi) {
        self.regionApi = regionApi
    }
    
    func fetch() {
        self.loading.onNext(true)
        regionApi.get_regions { result in
            self.loading.onNext(false)
            switch result {
            case .success(let regions):
                self.regions.onNext(regions)
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
    
}
