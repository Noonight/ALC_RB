//
//  NewsTableViewCell.swift
//  ALC_RB
//
//  Created by user on 29.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell { // 💩

    static let ID = "cell_news_dynamic"
    
    @IBOutlet weak var content: UILabel?
    @IBOutlet weak var date: UILabel?
    
    var newsModelItem: NewsModelItem! {
        didSet {
            self.content?.text = newsModelItem.caption
            self.date?.text = newsModelItem.updatedAt
        }
    }

}
