//
//  NewsCollectionViewCell.swift
//  ALC_RB
//
//  Created by ayur on 19.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

class HomeNewsCollectionViewCell: UICollectionViewCell {
    
    public static let ID = "collection_view_news_cell"
    
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var news_image: UIImageView!
    
    var newsModelItem: NewsModelItem! {
        didSet {
            self.title_label.text = newsModelItem.caption
            self.news_image.kfLoadImage(path: newsModelItem.imagePath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
