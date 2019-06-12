//
//  ScheduleRefTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 11.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import AlamofireImage

class ScheduleRefTableViewCell: UITableViewCell {
    enum StaticVariables {
        static let scorePlaceHolder = " - "
        static let refereePlaceHolder = "Не назначен"
    }
    
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

    struct CellModel {
        var activeMatch: ActiveMatch
        var clubTeamOne: Club
        var clubTeamTwo: Club
        var referee1: Person?
        var referee2: Person?
        var referee3: Person?
        var timekeeper: Person?
        
        init(activeMatch: ActiveMatch, clubTeamOne: Club, clubTeamTwo: Club, referee1: Person?, referee2: Person?, referee3: Person?, timekeeper: Person?) {
            self.activeMatch = activeMatch
            self.clubTeamOne = clubTeamOne
            self.clubTeamTwo = clubTeamTwo
            self.referee1 = referee1
            self.referee2 = referee2
            self.referee3 = referee3
            self.timekeeper = timekeeper
        }
    }
    
    func configure(with cellModel: CellModel) {
        reset()
        date_label.text = cellModel.activeMatch.date.UTCToLocal(from: .utc, to: .localTime)
        time_label.text = cellModel.activeMatch.date.UTCToLocal(from: .utc, to: .local)
        league_label.text = cellModel.activeMatch.tour
        stadium_label.text = cellModel.activeMatch.place
        
        teamNameOne_label.text = cellModel.activeMatch.teamOne.name
        teamNameTwo_label.text = cellModel.activeMatch.teamTwo.name
        if cellModel.clubTeamOne.logo.count > 1 {
            teamLogoOne_image.af_setImage(withURL: ApiRoute.getImageURL(image: cellModel.clubTeamOne.logo))
            teamLogoOne_image.image = teamLogoOne_image.image?.af_imageRoundedIntoCircle()
        }
        if cellModel.clubTeamTwo.logo.count > 1 {
            teamLogoTwo_image.af_setImage(withURL: ApiRoute.getImageURL(image: cellModel.clubTeamTwo.logo))
            teamLogoTwo_image.image = teamLogoTwo_image.image?.af_imageRoundedIntoCircle()
        }
        if cellModel.activeMatch.score == "" {
            score_label.text = cellModel.activeMatch.score
        }
        if cellModel.referee1 != nil {
            refereeOne_label.text = cellModel.referee1?.getFullName()
        }
        if cellModel.referee2 != nil {
            refereeTwo_label.text = cellModel.referee2?.getFullName()
        }
        if cellModel.referee3 != nil {
            refereeThree_label.text = cellModel.referee3?.getFullName()
        }
        if cellModel.timekeeper != nil {
            timekeeper_label.text = cellModel.timekeeper?.getFullName()
        }
    }
    
    func reset() {
        date_label.text = ""
        time_label.text = ""
        league_label.text = ""
        stadium_label.text = ""
        
        teamNameOne_label.text = "Команда 1"
        teamNameTwo_label.text = "Команда 2"
        teamLogoOne_image.image = nil
        teamLogoOne_image.image = #imageLiteral(resourceName: "ic_logo")
        teamLogoTwo_image.image = nil
        teamLogoTwo_image.image = #imageLiteral(resourceName: "ic_logo")
        
        score_label.text = StaticVariables.scorePlaceHolder
        
        refereeOne_label.text = StaticVariables.refereePlaceHolder
        refereeTwo_label.text = StaticVariables.refereePlaceHolder
        refereeThree_label.text = StaticVariables.refereePlaceHolder
        timekeeper_label.text = StaticVariables.refereePlaceHolder
        
        
    }

}
