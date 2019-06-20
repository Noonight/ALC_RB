//
//  ClubTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 13.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import AlamofireImage

class ClubTableViewCell: UITableViewCell {

    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mTitle: UILabel!
    
    func configure(with club: Club) {
        reset()
        mImage.af_setImage(withURL: ApiRoute.getImageURL(image: club.logo), placeholderImage: #imageLiteral(resourceName: "ic_con"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: true) { (response) in
            self.mImage.image = response.result.value?.af_imageRoundedIntoCircle()
        }
        mTitle.text = club.name
    }
    
    func reset() {
        mImage.image = #imageLiteral(resourceName: "ic_con")
        mTitle.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
