//
//  ScheduleRefTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 11.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
//import AlamofireImage
import Kingfisher

class ScheduleRefCell: UITableViewCell {
    enum StaticVariables {
        static let scorePlaceHolder = " - "
        static let refereePlaceHolder = "Не назначен"
    }
    
    static let ID = "activeMatches_cell"
    
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var league_label: UILabel!
    @IBOutlet weak var stadium_label: UILabel!
    
    @IBOutlet weak var teamLogoOne_image: UIImageView!
    @IBOutlet weak var teamLogoTwo_image: UIImageView!
    @IBOutlet weak var teamNameOne_label: UILabel!
    @IBOutlet weak var teamNameTwo_label: UILabel!
    @IBOutlet weak var score_label: UILabel!
    
    @IBOutlet weak var refereeOne_label: UILabel!
    @IBOutlet weak var refereeTwo_label: UILabel!
    @IBOutlet weak var refereeThree_label: UILabel!
    @IBOutlet weak var timekeeper_label: UILabel!

    let darkGrayColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    let redColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
    
    var scheduleMatch: MatchScheduleModelItem! {
        didSet {
            self.date_label.text = self.scheduleMatch.date
            self.time_label.text = self.scheduleMatch.time
            self.league_label.text = "" // grouped by league
            self.stadium_label.text = self.scheduleMatch.place
            
            self.teamNameOne_label.text = self.scheduleMatch.teamOneName
            self.teamNameTwo_label.text = self.scheduleMatch.teamTwoName
            self.score_label.text = self.scheduleMatch.score
            
            self.refereeOne_label.text = self.scheduleMatch.firstRefereeName
            self.refereeTwo_label.text = self.scheduleMatch.secondRefereeName
            self.refereeThree_label.text = self.scheduleMatch.thirdRefereeName
            self.timekeeper_label.text = self.scheduleMatch.timekeeperRefereeName
            
            setupRefereeColors()
        }
    }
    
    func setupRefereeColors() {
        if scheduleMatch.firstRefereeName != nil {
            refereeOne_label.textColor = darkGrayColor
        } else {
            refereeOne_label.textColor = redColor
            refereeOne_label.text = StaticVariables.refereePlaceHolder
        }
        if scheduleMatch.secondRefereeName != nil {
            refereeTwo_label.textColor = darkGrayColor
        } else {
            refereeTwo_label.textColor = redColor
            refereeTwo_label.text = StaticVariables.refereePlaceHolder
        }
        if scheduleMatch.thirdRefereeName != nil {
            refereeThree_label.textColor = darkGrayColor
        } else {
            refereeThree_label.textColor = redColor
            refereeThree_label.text = StaticVariables.refereePlaceHolder
        }
        if scheduleMatch.timekeeperRefereeName != nil {
            timekeeper_label.textColor = darkGrayColor
        } else {
            timekeeper_label.textColor = redColor
            timekeeper_label.text = StaticVariables.refereePlaceHolder
        }
    }
}
