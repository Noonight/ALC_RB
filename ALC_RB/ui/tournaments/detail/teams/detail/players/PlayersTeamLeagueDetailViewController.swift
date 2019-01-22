//
//  PlayersTeamLeagueDetailViewController.swift
//  ALC_RB
//
//  Created by ayur on 18.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class PlayersTeamLeagueDetailViewController: UIViewController {

    @IBOutlet weak var photo_trainer_img: UIImageView!
    @IBOutlet weak var name_trainer_label: UILabel!
    
    let cellId = "player_team_cell"
    
    var leagueDetailModel: LeagueDetailModel = LeagueDetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        //photo_trainer_img.af_setImage(withURL: leagueDetailModel)
    }
    
    func updateUI() {
        
    }
}

extension PlayersTeamLeagueDetailViewController: LeagueMainProtocol {
    func updateData(leagueDetailModel: LeagueDetailModel) {
        self.leagueDetailModel = leagueDetailModel
    }
}
