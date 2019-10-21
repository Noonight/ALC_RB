//
//  ScheduleTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 13.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    static let PLAYED_COLOR = UIColor(red: 54, green: 178, blue: 39)
    static let NOT_PLAYED_COLOR = UIColor(red: 0, green: 97, blue: 225)
    
    @IBOutlet weak var mDate: UILabel!
    @IBOutlet weak var mTime: UILabel!
    @IBOutlet weak var mTour: UILabel!
    @IBOutlet weak var mPlace: UILabel!
    @IBOutlet weak var mImageTeam1: UIImageView!
    @IBOutlet weak var mTitleTeam1: UILabel!
    @IBOutlet weak var mScore: UILabel!
    @IBOutlet weak var mTitleTeam2: UILabel!
    @IBOutlet weak var mImageTeam2: UIImageView!
    
    static let ID = "cell_schedule"
    
    var matchScheduleModelItem: MatchScheduleModelItem! {
        didSet {
//            dump(self.matchScheduleModelItem)
            self.mDate.text = self.matchScheduleModelItem.date
            self.mTime.text = self.matchScheduleModelItem.time
            self.mTour.text = self.matchScheduleModelItem.tour
            self.mPlace.text = self.matchScheduleModelItem.place
//            self.mTitleTeam1.text = self.matchScheduleModelItem.teamOne?.name
//            self.mTitleTeam2.text = self.matchScheduleModelItem.teamTwo?.name
            self.mTitleTeam1.text = self.matchScheduleModelItem.teamOneName
            self.mTitleTeam2.text = self.matchScheduleModelItem.teamTwoName
            self.mScore.text = self.matchScheduleModelItem.score
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setColorState(played: Bool) {
        if played == true
        {
            self.mTitleTeam1.textColor = ScheduleTableViewCell.PLAYED_COLOR
            self.mTitleTeam2.textColor = ScheduleTableViewCell.PLAYED_COLOR
            self.mScore.textColor = ScheduleTableViewCell.PLAYED_COLOR
        }
        else
        {
            self.mTitleTeam1.textColor = ScheduleTableViewCell.NOT_PLAYED_COLOR
            self.mTitleTeam2.textColor = ScheduleTableViewCell.NOT_PLAYED_COLOR
            self.mScore.textColor = ScheduleTableViewCell.NOT_PLAYED_COLOR
        }
    }

}
