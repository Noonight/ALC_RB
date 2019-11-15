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
        var participationMatch: Match?
        var club1: Club?
        var club2: Club?
        var team1Name, team2Name: String?
        
        init(participationMatch: Match, club1: Club?, club2: Club?, team1Name: String?, team2Name: String?) {
            self.participationMatch = participationMatch
            self.club1 = club1
            self.club2 = club2
            self.team1Name = team1Name
            self.team2Name = team2Name
        }
        
        init(participationMatch: Match) {
            self.participationMatch = participationMatch
        }
    }
    
    var cellModel: CellModel?
    
    func configure(with cellModel: CellModel) {
        self.cellModel = cellModel
        
        let personId = UserDefaultsHelper().getAuthorizedUser()!.person.id
        let userRef3 = cellModel.participationMatch?.referees.filter({ referee -> Bool in
            return referee.type == Referee.rType.thirdReferee && referee.person!.orEqual(personId, { $0.id == personId })
//            return referee.getRefereeType() == Referee.RefereeType.referee3 && UserDefaultsHelper().getAuthorizedUser()?.person.id == referee.person
        }).first
        
        if userRef3 != nil && cellModel.participationMatch?.teamOne.count ?? 0 > 2 && cellModel.participationMatch?.teamTwo.count ?? 0 > 2 {
            accessoryType = .disclosureIndicator
        } else {
            accessoryType = .none
        }
        
        dateLabel.text = cellModel.participationMatch?.date.toFormat(DateFormats.local.rawValue)//convertDate(from: .utcTime, to: .local)
        timeLabel.text = cellModel.participationMatch?.date.toFormat(DateFormats.localTime.rawValue)//convertDate(from: .utcTime, to: .localTime)
        tourLabel.text = cellModel.participationMatch?.tour
        placeLabel.text = cellModel.participationMatch?.place
        
        team1NameLabel.text = cellModel.team1Name
        
        
        if let urlOne = cellModel.club1?.logo {
            let url = ApiRoute.getImageURL(image: urlOne)
            let processor = DownsamplingImageProcessor(size: self.team1Image.frame.size)
                .append(another: CroppingImageProcessorCustom(size: self.team1Image.frame.size))
                .append(another: RoundCornerImageProcessor(cornerRadius: self.team1Image.getHalfWidthHeight()))
            
            self.team1Image.kf.indicatorType = .activity
            self.team1Image.kf.setImage(
                with: url,
                placeholder: UIImage(named: "ic_logo"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        } else {
            self.team1Image.image = #imageLiteral(resourceName: "ic_logo")
        }
        
        team2NameLabel.text = cellModel.team2Name
        
        if let urlTwo = cellModel.club2?.logo {
            let url = ApiRoute.getImageURL(image: urlTwo)
            let processor = DownsamplingImageProcessor(size: self.team2Image.frame.size)
                .append(another: CroppingImageProcessorCustom(size: self.team2Image.frame.size))
                .append(another: RoundCornerImageProcessor(cornerRadius: self.team2Image.getHalfWidthHeight()))
            
            self.team2Image.kf.indicatorType = .activity
            self.team2Image.kf.setImage(
                with: url,
                placeholder: UIImage(named: "ic_logo"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        } else {
            self.team2Image.image = #imageLiteral(resourceName: "ic_logo")
        }
        
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
        
        team1Image.image = #imageLiteral(resourceName: "ic_logo")
        team1NameLabel.text = ""
        
        scoreLabel.text = " - "

        team2Image.image = #imageLiteral(resourceName: "ic_logo")
        team2NameLabel.text = ""
    }
    
}
