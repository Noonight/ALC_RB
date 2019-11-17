//
//  ChooseRegionVM.swift
//  ALC_RB
//
//  Created by mac on 05.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ChooseRegionVM {
    
    let loading = PublishSubject<Bool>()
    let error = PublishSubject<Error?>()
    let message = PublishSubject<SingleLineMessage>()
    let query = BehaviorRelay<String?>(value: nil)
    
    let findedRegions = PublishSubject<[RegionMy]>()
    
    let regionApi: RegionApi
    
    init(regionApi: RegionApi) {
        self.regionApi = regionApi
    }
    
    func fetch() {
        loading.onNext(true)
        regionApi.get_region(name: query.value) { result in
            self.loading.onNext(false)
            switch result {
            case .success(let regions):
                self.findedRegions.onNext(regions)
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
}
