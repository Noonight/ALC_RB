//
//  MyMatchesRefTableViewCell.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
//import AlamofireImage
import Kingfisher

class MyMatchesRefTableViewCell: UITableViewCell {

    static let ID = "cell_my_matches"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tourLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var team1Image: UIImageView!
    @IBOutlet weak var team1NameLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var team2NameLabel: UILabel!
    @IBOutlet weak var team2Image: UIImageView!
    
    var myMatchModel: MyMatchModelItem! {
        didSet {
            self.dateLabel.text = myMatchModel.date
            self.timeLabel.text = myMatchModel.time
            self.tourLabel.text = myMatchModel.tour
            self.placeLabel.text = myMatchModel.place ?? "Не указано"
            
            self.team1NameLabel.text = myMatchModel.teamOneName ?? "Не назначена"
            self.team2NameLabel.text = myMatchModel.teamTwoName ?? "Не назначена"
            
            self.scoreLabel.text = myMatchModel.score
        }
    }
    
}
