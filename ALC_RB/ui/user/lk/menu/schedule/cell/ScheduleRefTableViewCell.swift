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

    let darkGrayColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    let redColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
    
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
//        Print.m(cellModel)
        date_label.text = cellModel.activeMatch.date.UTCToLocal(from: .utc, to: .local)
        time_label.text = cellModel.activeMatch.date.UTCToLocal(from: .utc, to: .localTime)
        league_label.text = cellModel.activeMatch.tour
        stadium_label.text = cellModel.activeMatch.place
        
        Print.m(cellModel.activeMatch.teamOne.name)
        Print.m(cellModel.activeMatch.teamTwo.name)
        
        teamNameOne_label.text = cellModel.activeMatch.teamOne.name
        teamNameTwo_label.text = cellModel.activeMatch.teamTwo.name
        if cellModel.clubTeamOne.logo.count > 1 {
//            teamLogoOne_image.af_setImage(withURL: ApiRoute.getImageURL(image: cellModel.clubTeamOne.logo))
//            let image = teamLogoOne_image.image
//            teamLogoOne_image.image = image?.af_imageRoundedIntoCircle()
            
            teamLogoOne_image.af_setImage(withURL: ApiRoute.getImageURL(image: cellModel.clubTeamOne.logo), placeholderImage: #imageLiteral(resourceName: "ic_logo"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: true) { (response) in
                self.teamLogoOne_image.image = response.result.value?.af_imageRoundedIntoCircle()
            }
            
//            teamLogoOne_image.image = teamLogoOne_image.image?.af_imageRoundedIntoCircle()
        }
        if cellModel.clubTeamTwo.logo.count > 1 {
//            teamLogoTwo_image.af_setImage(withURL: ApiRoute.getImageURL(image: cellModel.clubTeamTwo.logo))
//            let image = teamLogoTwo_image.image
//            teamLogoTwo_image.image = image?.af_imageRoundedIntoCircle()
            
            teamLogoTwo_image.af_setImage(withURL: ApiRoute.getImageURL(image: cellModel.clubTeamTwo.logo), placeholderImage: #imageLiteral(resourceName: "ic_logo"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: true) { (response) in
                self.teamLogoTwo_image.image = response.result.value?.af_imageRoundedIntoCircle()
            }
            
//            teamLogoTwo_image.image = teamLogoTwo_image.image?.af_imageRoundedIntoCircle()
        }
        if cellModel.activeMatch.score == "" {
            score_label.text = " - "
        } else {
            score_label.text = cellModel.activeMatch.score
        }
//        if cellModel.activeMatch.score.count > 0 {
//            score_label.text = cellModel.activeMatch.score
//        }
        
        
        
        if cellModel.referee1 != nil {
            refereeOne_label.textColor = darkGrayColor
            refereeOne_label.text = cellModel.referee1?.getFullName()
        } else {
            refereeOne_label.textColor = redColor
        }
        if cellModel.referee2 != nil {
            refereeTwo_label.textColor = darkGrayColor
            refereeTwo_label.text = cellModel.referee2?.getFullName()
        } else {
            refereeTwo_label.textColor = redColor
        }
        if cellModel.referee3 != nil {
            refereeThree_label.textColor = darkGrayColor
            refereeThree_label.text = cellModel.referee3?.getFullName()
        } else {
            refereeThree_label.textColor = redColor
        }
        if cellModel.timekeeper != nil {
            timekeeper_label.textColor = darkGrayColor
            timekeeper_label.text = cellModel.timekeeper?.getFullName()
        } else {
            timekeeper_label.textColor = redColor
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
