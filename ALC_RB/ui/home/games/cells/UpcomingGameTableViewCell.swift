//
//  UpcomingGameTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 07.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class UpcomingGameTableViewCell: UITableViewCell, MvpView {

    @IBOutlet weak var mDate: UILabel!
    @IBOutlet weak var mTime: UILabel!
    @IBOutlet weak var mTour: UILabel!
    @IBOutlet weak var mPlace: UILabel!
    @IBOutlet weak var mImageTeam1: UIImageView!
    @IBOutlet weak var mTitleTeam1: UILabel!
    @IBOutlet weak var mScore: UILabel!
    @IBOutlet weak var mTitleTeam2: UILabel!
    @IBOutlet weak var mImageTeam2: UIImageView!
    
    let presenter = UpcomingGameCellPresenter()
    
    static let idCell = "cell_upcoming_game"
    
    var data = Match()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initPresenter()
    }
    
    func updateUI() {
        
//        if (data == nil) {
//
//            print("data is nil")
//        }
        //mDate.text = data.date.UTCToLocal(from: .utcTime, to: .localTime)
        print("Upcoming cell \(#function)")
        print(data.date)
        mDate.text = data.date.UTCToLocal(from: .utcTime, to: .local)
        mTime.text = data.date.UTCToLocal(from: .utcTime, to: .localTime)
        mTour.text = data.tour
        mPlace.text = data.place
        //mImageTeam1.image = ApiService.getImage(imageName: data.teamOne.club, fun: <#T##(UIImage) -> ()#>)
        presenter.getClub1Logo(club: data.teamOne.club)
        mTitleTeam1.text = data.teamOne.name
        mScore.text = data.score
        presenter.getClub2Logo(club: data.teamTwo.club)
        mTitleTeam2.text = data.teamTwo.name
        
    }

    func onGetClub1LogoSuccess(image: UIImage) {
        mImageTeam1.image = image
    }
    
    func onGetClub2LogoSuccess(image: UIImage) {
        mImageTeam2.image = image
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        updateUI()
    }
    
    func setData(data: Match) {
        self.data = data
        updateUI()
    }

}
