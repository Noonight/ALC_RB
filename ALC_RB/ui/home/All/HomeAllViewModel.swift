//
//  HomeAllViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class HomeAllViewModel {
    
    private let dataManager: ApiRequests
    
    let newsViewModel: HomeNewsViewModel
//    private let scheduleViewModel: ScheduleViewModel
    
    init(newDataManager: ApiRequests) {
        dataManager = newDataManager
        newsViewModel = HomeNewsViewModel(newsApi: NewsApi())
//        scheduleViewModel = ScheduleViewModel(newDataManager: dataManager)
    }
    
    func fetch() {
        newsViewModel.fetch()
    }
    
}
