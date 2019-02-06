//
//  PlayersLeagueDetailViewController.swift
//  ALC_RB
//
//  Created by ayur on 30.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class PlayersLeagueDetailViewController: UIViewController {
    
    @IBOutlet weak var header_view: UIView!
    @IBOutlet weak var filter_type_btn: UIButton!
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var empty_view: UIView!
    @IBOutlet weak var picker_view: UIPickerView!
    
    let cellId = "cell_players_tournament"
    
    var leagueDetailModel = LeagueDetailModel() {
        didSet {
            updateUI()
        }
    }
    
    //var playersCount: Int = 0
    var playersArray: [LIPlayer] = [LIPlayer]()
    
    let presenter = PlayersLeagueDetailPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
        for i in leagueDetailModel.leagueInfo.league.teams {
            playersArray += i.players
            //print("\(i.players)")
        }
        
        filterTable(type: .matches)
        filterTable(type: .matches)
        
        table_view.dataSource = self
        table_view.delegate = self
    }

    func updateUI() {
        // some
    }
}

// MARK: - filters
extension PlayersLeagueDetailViewController {
    func filterByCompletedMatches() {
        playersArray.sort { (player1, player2) -> Bool in
            return player1.matches > player2.matches
        }
    }
    
    func filterByGoals() {
        playersArray.sort { (player1, player2) -> Bool in
            return player1.goals > player2.goals
        }
    }
    
    func filterByYellowCards() {
        playersArray.sort { (player1, player2) -> Bool in
            player1.yellowCards > player2.yellowCards
        }
    }
    
    func filterByRedCards() {
        playersArray.sort { (player1, player2) -> Bool in
            player1.redCards > player2.redCards
        }
    }
    
    func filterTable(type: FilterType) {
        switch type {
        case .matches:
            filterByCompletedMatches()
        case .goals:
            filterByGoals()
        case .yellow:
            filterByYellowCards()
        case .red:
            filterByRedCards()
        default:
            table_view.reloadData()
        }
        table_view.reloadData()
    }
    
    enum FilterType : String {
        case matches = "01"
        case goals = "02"
        case yellow = "03"
        case red = "04"
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

extension PlayersLeagueDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: table_view.frame.width, height: 37))
        view.addSubview(header_view)
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PlayersLeagueTableViewCell
        
        configureCell(cell: cell, leagueDetailModel: leagueDetailModel, player: playersArray[indexPath.row])
        
        return cell
    }
    
    func configureCell(cell: PlayersLeagueTableViewCell, leagueDetailModel: LeagueDetailModel, player: LIPlayer) {
        presenter.getUser(user: player.playerId) { (person) in
            cell.name_label.text = person.person.getFullName()
            
            self.presenter.getClubImageByClubId(user: self.getClubByUserId(user: player.playerId)) { (img) in
                cell.photo_img.image = img.af_imageRoundedIntoCircle()
            }
            
            cell.games_label.text = String(player.matches)
            cell.goals_label.text = String(player.goals)
            cell.yellow_cards_label.text = String(player.activeYellowCards)
            cell.red_cards_label.text = String(player.redCards)
        }
    }
    
    func getClubByUserId(user id: String) -> String {
        let teams = leagueDetailModel.leagueInfo.league.teams
        for i in teams {
            for j in i.players {
                if j.playerId == id {
                    return i.club
                }
            }
        }
        return " "
    }
}

extension PlayersLeagueDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PlayersLeagueDetailViewController: EmptyProtocol {
    func showEmptyView() {
        table_view.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: table_view.frame.width, height: table_view.frame.height))
        table_view.backgroundView?.addSubview(empty_view)
        table_view.separatorColor = .none
        empty_view.setCenterFromParent()
    }
    
    func hideEmptyView() {
        table_view.backgroundView = nil
        table_view.separatorStyle = .singleLine
    }
}

