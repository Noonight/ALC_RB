//
//  MyMatchesRefTableViewCell.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import AlamofireImage

class MyMatchesRefTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tourLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var team1Image: UIImageView!
    @IBOutlet weak var team1NameLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var team2NameLabel: UILabel!
    @IBOutlet weak var team2Image: UIImageView!
    
    struct CellModel {
        var participationMatch: ParticipationMatch?
        var club1: Club?
        var club2: Club?
    }
    
    func configure(with cellModel: CellModel) {
        
    }
    
    func reset() {
        dateLabel.text = ""
        timeLabel.text = ""
        tourLabel.text = ""
        placeLabel.text = ""
        
        team1Image.image = nil
        team1NameLabel.text = ""
        scoreLabel.text = " - "
        team2Image.image = nil
        team2NameLabel.text = ""
    }
    
}
