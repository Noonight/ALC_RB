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
        var team1Name, team2Name: String?
        
        init(participationMatch: ParticipationMatch, club1: Club, club2: Club, team1Name: String, team2Name: String) {
            self.participationMatch = participationMatch
            self.club1 = club1
            self.club2 = club2
            self.team1Name = team1Name
            self.team2Name = team2Name
        }
        
        init(participationMatch: ParticipationMatch) {
            self.participationMatch = participationMatch
        }
    }
    
    var cellModel: CellModel?
    
    func configure(with cellModel: CellModel) {
//        reset()
        self.cellModel = cellModel
        
        var userRef3 = cellModel.participationMatch?.referees.filter({ referee -> Bool in
//            Print.m(referee.person == UserDefaultsHelper().getAuthorizedUser()?.person.id)
            return referee.getRefereeType() == Referee.RefereeType.referee3 && UserDefaultsHelper().getAuthorizedUser()?.person.id == referee.person
        }).first
//        var containReferee = cellModel.participationMatch?.referees.filter({ referee -> Bool in
//            Print.m(referee.getRefereeType() == Referee.RefereeType.referee3)
//            return referee.getRefereeType() == Referee.RefereeType.referee3
//        })/*.contains(where: { (referee) -> Bool in
//            if let personId = UserDefaultsHelper().getAuthorizedUser()?.person.id {
//                Print.m("\(referee.id) = \(personId)")
//
//                return referee.id == personId
//            }
//            return false
//        })*/
        
        if userRef3 != nil {
            accessoryType = .disclosureIndicator
        } else {
            accessoryType = .none
        }
        
//        if containReferee!.count > 0 {
//            Print.m(containReferee!.count > 0)
//            accessoryType = .disclosureIndicator
//        }
        
        
        
        dateLabel.text = cellModel.participationMatch?.date.UTCToLocal(from: .utcTime, to: .local)
        timeLabel.text = cellModel.participationMatch?.date.UTCToLocal(from: .utcTime, to: .localTime)
        tourLabel.text = cellModel.participationMatch?.tour
        placeLabel.text = cellModel.participationMatch?.place
        
        team1NameLabel.text = cellModel.team1Name
        team1Image.af_setImage(withURL: ApiRoute.getImageURL(image: cellModel.club1?.logo ?? ""), placeholderImage: #imageLiteral(resourceName: "ic_logo"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: true) { response in
            self.team1Image.image = response.result.value?.af_imageRoundedIntoCircle()
        }
//        team1Image.loadImageWith(url: ApiRoute.getImageURL(image: cellModel.club1?.logo ?? ""))
        
//        team1Image.cacheImage(urlString: ApiRoute.getImageURL(image: cellModel.club1?.logo ?? "").absoluteString)
        
        team2NameLabel.text = cellModel.team2Name
        team2Image.af_setImage(withURL: ApiRoute.getImageURL(image: cellModel.club2?.logo ?? ""), placeholderImage: #imageLiteral(resourceName: "ic_logo"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: true) { response in
            self.team2Image.image = response.result.value?.af_imageRoundedIntoCircle()
        }
        
//        team2Image.loadImageWith(url: ApiRoute.getImageURL(image: cellModel.club2?.logo ?? ""))
        
//        team2Image.cacheImage(urlString: ApiRoute.getImageURL(image: cellModel.club2?.logo ?? "").absoluteString)
        
        if cellModel.participationMatch?.score.count ?? 0 > 1 {
            scoreLabel.text = cellModel.participationMatch?.score
        } else {
            scoreLabel.text = " - "
        }
    }
    
    func reset() {
        dateLabel.text = ""
        timeLabel.text = ""
        tourLabel.text = ""
        placeLabel.text = ""
        
//        team1Image.image = nil
        team1Image.image = #imageLiteral(resourceName: "ic_logo")
        team1NameLabel.text = ""
        scoreLabel.text = " - "
//        team2Image.image = nil
        team2Image.image = #imageLiteral(resourceName: "ic_logo")
        team2NameLabel.text = ""
    }
    
}
