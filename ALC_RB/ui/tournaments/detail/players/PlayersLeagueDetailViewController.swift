//
//  PlayersLeagueDetailViewController.swift
//  ALC_RB
//
//  Created by ayur on 30.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class PlayersLeagueDetailViewController: UIViewController {
    
    @IBOutlet weak var filter_type_btn: UIButton!
    @IBOutlet weak var table_view: UITableView!
    
    let cellId = "cell_players_tournament"
    
    var leagueDetailModel = LeagueDetailModel() {
        didSet {
            updateUI()
        }
    }
    
    let presenter = PlayersLeagueDetailPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }

    func updateUI() {
        // some
    }
}

extension PlayersLeagueDetailViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

extension PlayersLeagueDetailViewController: LeagueMainProtocol {
    func updateData(leagueDetailModel: LeagueDetailModel) {
        self.leagueDetailModel = leagueDetailModel
        updateUI()
    }
}
