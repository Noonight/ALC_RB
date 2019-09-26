//
//  HomeScheduleTableViewCell.swift
//  ALC_RB
//
//  Created by mac on 20.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class HomeScheduleTableViewCell: UITableViewCell {

    static let ID = "home_schedule_table_cell"
    
    @IBOutlet weak var team_one_label: UILabel!
    @IBOutlet weak var team_two_label: UILabel!
    
    @IBOutlet weak var team_one_image: UIImageView!
    @IBOutlet weak var team_two_image: UIImageView!
    
    @IBOutlet weak var score_date_label: UILabel!
    
    func configure(_ item: MmMatch, clubOne: Club?, clubTwo: Club?) {
        self.team_one_label.text = item.teamOne?.name
        self.team_two_label.text = item.teamTwo?.name
        
        if clubOne?.logo != nil
        {
            self.team_one_image.kfLoadRoundedImage(path: (clubOne?.logo)!)
        }
        if clubTwo?.logo != nil
        {
            self.team_two_image.kfLoadRoundedImage(path: (clubTwo?.logo)!)
        }
        
        if item.played == true
        {
            setScoreColor(color: .red)
        }
        else
        {
            setScoreColor(color: .black )
        }
    }
    
    private func setScoreColor(color: ScoreColor) {
        switch color  {
        case .red :
            self.score_date_label.textColor = .red
        case .black:
            self.score_date_label.textColor = .black
        }
    }
    
    
    private enum ScoreColor {
        case red
        case black
    }
}
