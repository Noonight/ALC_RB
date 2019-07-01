//
//  RefereeEditMatchesLKTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 30.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import AlamofireImage

class RefereeEditMatchesLKTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var teamOneImage: UIImageView!
    @IBOutlet weak var teamOneLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var teamTwoLabel: UILabel!
    @IBOutlet weak var teamTwoImage: UIImageView!
    
    @IBOutlet weak var refereeOneSwitch: LabelSwitchView!
    @IBOutlet weak var refereeTwoSwitch: LabelSwitchView!
    @IBOutlet weak var refereeThreeSwitch: LabelSwitchView!
    @IBOutlet weak var timeKeeperSwitch: LabelSwitchView!
    
    var cellModel: CellModel!
    
    func configure(model: CellModel) {
        self.cellModel = model
        reset()
        
        dateLabel.text = cellModel.activeMatch.date.UTCToLocal(from: .utcTime, to: .local)
        timeLabel.text = cellModel.activeMatch.date.UTCToLocal(from: .utcTime, to: .localTime)
        leagueLabel.text = cellModel.activeMatch.tour
        placeLabel.text = cellModel.activeMatch.place
        
        Print.m(cellModel.activeMatch.teamOne.name)
        Print.m(cellModel.activeMatch.teamTwo.name)
        
        teamOneLabel.text = cellModel.activeMatch.teamOne.name
        teamTwoLabel.text = cellModel.activeMatch.teamTwo.name
        if cellModel.clubTeamOne.logo?.count ?? 0 > 1 {
            
            teamOneImage.af_setImage(withURL: ApiRoute.getImageURL(image: cellModel.clubTeamOne.logo ?? ""), placeholderImage: #imageLiteral(resourceName: "ic_logo"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: true) { (response) in
                self.teamOneImage.image = response.result.value?.af_imageRoundedIntoCircle()
            }
            
        }
        if cellModel.clubTeamTwo.logo?.count ?? 0 > 1 {
            
            teamTwoImage.af_setImage(withURL: ApiRoute.getImageURL(image: cellModel.clubTeamTwo.logo ?? ""), placeholderImage: #imageLiteral(resourceName: "ic_logo"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: true) { (response) in
                self.teamTwoImage.image = response.result.value?.af_imageRoundedIntoCircle()
            }
            
        }
        
        if cellModel.activeMatch.score == "" {
            scoreLabel.text = " - "
        } else {
            scoreLabel.text = cellModel.activeMatch.score
        }
        
        func configureLabelSwitcher(referee: Person?, switcher: LabelSwitchView) {
            if referee != nil {
                if referee?.id == UserDefaultsHelper().getAuthorizedUser()?.person.id {
                    switcher.configure(state: .switcher(true)) // user is appointed in match
                } else {
                    switcher.configure(state: .name((referee?.getFullName())!))
                }
            } else {
                switcher.configure(state: .switcher(false)) // we have no user and turn off switcher
            }
        }
        
//        if cellModel.referee1 != nil {
//            refereeOneSwitch.configure(state: .name((cellModel.referee1?.getFullName())!))
            configureLabelSwitcher(referee: cellModel.referee1, switcher: refereeOneSwitch)
//            refereeOneSwitch.isAppointed = true
//        }
//        if cellModel.referee2 != nil {
//            refereeTwoSwitch.configure(state: .name((cellModel.referee2?.getFullName())!))
            configureLabelSwitcher(referee: cellModel.referee2, switcher: refereeTwoSwitch)

//            refereeTwoSwitch.isAppointed = true
//        }
//        if cellModel.referee3 != nil {
//            refereeThreeSwitch.configure(state: .name((cellModel.referee3?.getFullName())!))
            configureLabelSwitcher(referee: cellModel.referee3, switcher: refereeThreeSwitch)

//            refereeThreeSwitch.isAppointed = true
//        }
//        if cellModel.timekeeper != nil {
//            timeKeeperSwitch.configure(state: .name((cellModel.timekeeper?.getFullName())!))
            configureLabelSwitcher(referee: cellModel.timekeeper, switcher: timeKeeperSwitch)

//            timeKeeperSwitch.isAppointed = true
//        }
        
        
    }
    
    func reset() {
        dateLabel.text = ""
        timeLabel.text = ""
        leagueLabel.text = ""
        placeLabel.text = ""
        
        teamOneLabel.text = "Команда 1"
        teamTwoLabel.text = "Команда 2"
        teamOneImage.image = #imageLiteral(resourceName: "ic_logo")
        teamTwoImage.image = #imageLiteral(resourceName: "ic_logo")
        
        scoreLabel.text = " - "
        
        refereeOneSwitch.isAppointed = false
        refereeTwoSwitch.isAppointed = false
        refereeThreeSwitch.isAppointed = false
        timeKeeperSwitch.isAppointed = false
    }
    
    struct CellModel {
        var activeMatch: ActiveMatch
        var clubTeamOne: Club
        var clubTeamTwo: Club
        var referee1: Person?
        var referee2: Person?
        var referee3: Person?
        var timekeeper: Person?
        
        init() {
            self.activeMatch = ActiveMatch()
            self.clubTeamOne = Club()
            self.clubTeamTwo = Club()
            self.referee1 = nil
            self.referee2 = nil
            self.referee3 = nil
            self.timekeeper = nil
        }
        
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
}
