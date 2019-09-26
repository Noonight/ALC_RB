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
    
    func configure (_ item: NewsElement) {
        self.title_label.text = item.content
        self.news_image.loadKFImage(path: item.img)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
