//
//  HomeAllVM.swift
//  ALC_RB
//
//  Created by mac on 20.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class HomeAllVM {
    
    var news: News = News()
    var schedule: MmUpcomingMatches = MmUpcomingMatches()
    var announces: Announce = Announce()
    
    var networkRep: HomeAllNetworkRep!
    
    init(networkRep: HomeAllNetworkRep) {
        self.networkRep = networkRep
    }
    
}

// MARK: UPDATE

extension HomeAllVM {
    
    func updateNews(news: News, complete: @escaping (Result<>) -> ()) {
        
        self.news = news
        complete()
    }
    
    func updateSchedule(matches: MmUpcomingMatches) {
        self.schedule = matches
    }
    
    func updateAnnounces(announces: Announce) {
        self.announces = announces
    }
    
}

// MARK: PREPARE

extension HomeAllVM {
    
    func prepareNewsDataSource() -> [NewsElement] {
        return self.news.news
    }
    
    func prepareAnnouncesDataSource() -> [AnnounceElement] {
        return self.announces.announces
    }
    
    func prepareScheduleDataSource() -> [MmMatch] {
        return self.schedule.matches ?? []
    }
    
}
