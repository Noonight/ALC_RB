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
    var announces: Announce = Announce()
    
}

// MARK: UPDATE

extension HomeAllVM {
    
    
    
}

// MARK: PREPARE

extension HomeAllVM {
    
    func prepareNewsDataSource() -> [NewsElement] {
        return self.news.news
    }
    
    func prepareAnnouncesDataSource() -> [AnnounceElement] {
        return self.announces.announces
    }
    
}
