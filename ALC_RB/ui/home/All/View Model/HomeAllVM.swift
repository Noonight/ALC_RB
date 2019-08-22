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
    
    func updateAll(completed: @escaping () -> ()) {
        self.updateNews()
        self.updateSchedule()
        self.updateAnnounces()
    }
    
    func updateNews() {
        self.fetchNews { news  in
            self.news = news
        }
    }
    
    func updateSchedule() {
        self.fetchSchedule { upcomingMatches  in
            self.schedule = upcomingMatches
        }
    }
    
    func updateAnnounces() {
        self.fetchAnnounces { announces  in
            self.announces = announces
        }
    }
    
}

// MARK: NETWORK

extension HomeAllVM {
    
    func fetchNews(completed: @escaping (News) -> ())
    {
        self.networkRep.fetchNews(success: { news in
            completed(news )
        }) { error in
            Print.m(error)
        }
    }
    
    func fetchSchedule(completed: @escaping (MmUpcomingMatches) -> ())
    {
        self.networkRep.fetchUpcomingMatches(
            success: { upcomingMatches  in
                completed(upcomingMatches)
        }, message: { message  in
            Print.m(message )
        }, local_error: { error  in
            Print.m(error )
        }, server_error: { error  in
            Print.m(error )
        }, universal_error: { error  in
            Print.m(error )
        })
    }
    
    func fetchAnnounces(completed: @escaping (Announce ) -> ())
    {
        self.networkRep.fetchAnnounces(success: { announces  in
            completed(announces)
        }) { error  in
            Print.m(error)
        }
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
