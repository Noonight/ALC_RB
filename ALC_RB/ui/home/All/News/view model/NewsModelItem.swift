//
//  NewsModelItem.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class NewsModelItem {
    
    private let news: News
    var tourney: Tourney?
    
    init(news: News, tourney: Tourney?) {
        self.news = news
        self.tourney = tourney
    }
    
    var tourneyName: String? {
        return tourney?.name
    }
    var caption: String? {
        return news.caption
    }
    var content: String? {
        return news.content
    }
    var imagePath: String? {
        return news.img
    }
    var createdAt: String? {
        return news.createdAt?.toFormat(DateFormats.local.rawValue)
    }
    var updatedAt: String? {
        return news.updatedAt?.toFormat(DateFormats.local.rawValue)
    }
    
}

extension NewsModelItem: CellModel { }
