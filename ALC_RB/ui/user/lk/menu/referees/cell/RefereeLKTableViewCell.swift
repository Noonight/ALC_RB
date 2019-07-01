//
//  RefereeLKTableViewCell.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 03/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import AlamofireImage

class RefereeLKTableViewCell: UITableViewCell {
    
    @IBOutlet weak var refereeImage: UIImageView!
    @IBOutlet weak var refereeName: UILabel!
    
    var model: Person?
    
    func configure(with person: Person) {
        reset()
        model = person
        if person.photo != nil {
            refereeImage.af_setImage(withURL: ApiRoute.getImageURL(image: person.photo!), placeholderImage: #imageLiteral(resourceName: "ic_logo"))
            refereeImage.image = refereeImage.image?.af_imageRoundedIntoCircle()
        } else {
            refereeImage.image = #imageLiteral(resourceName: "ic_logo")
        }
        if person.getFullName().count > 2 {
            refereeName.text = person.getFullName()
        } else {
            refereeName.text = "Не указано"
        }
    }
    
    
    func reset() {
        refereeImage.image = #imageLiteral(resourceName: "ic_logo")
        refereeName.text = ""
    }
}
