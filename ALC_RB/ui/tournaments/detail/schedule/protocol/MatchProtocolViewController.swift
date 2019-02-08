//
//  MatchProtocolViewController.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MatchProtocolViewController: UIViewController {

    @IBOutlet weak var teamOneLogo: UIImageView!
    @IBOutlet weak var teamOneTitle: UILabel!
    @IBOutlet weak var teamOneBtn: UIButton!
    
    @IBOutlet weak var teamTwoLogo: UIImageView!
    @IBOutlet weak var teamTwoTitle: UILabel!
    @IBOutlet weak var teamTwoBtn: UIButton!
    
    @IBOutlet weak var responsiblePersonsBtn: UIButton!
    
    @IBOutlet weak var eventsBtn: UIButton!
    
    var leagueDetailModel = LeagueDetailModel()
    var match = LIMatch()
    
    let presenter = MatchProtocolPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.topItem?.title = " "
        title = "Протокол"
        
        teamOneTitle.text = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.leagueInfo.league, match: match, team: .one)
        
        teamTwoTitle.text = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.leagueInfo.league, match: match, team: .two)
        
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(match.teamOne, league: leagueDetailModel.leagueInfo.league)) { (image) in
            self.teamOneLogo.image = image.af_imageRoundedIntoCircle()
        }
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(match.teamTwo, league: leagueDetailModel.leagueInfo.league)) { (image) in
            self.teamTwoLogo.image = image.af_imageRoundedIntoCircle()
        }
        
        let navigationMatchScoreBtn = UIBarButtonItem(title: "Счет", style: .plain, target: self, action: #selector(onMatchScoreBtnPressed(sender:)))
        navigationItem.rightBarButtonItem = navigationMatchScoreBtn
    }
    
    @objc func onMatchScoreBtnPressed(sender: UIBarButtonItem) {
        debugPrint("Hello from navigation bar button")
    }
    
    @IBAction func teamOneBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func teamTwoBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func refereeBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func eventsBtnPressed(_ sender: UIButton) {
        
    }
}

extension MatchProtocolViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
