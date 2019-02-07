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
    @IBOutlet weak var picker_height: NSLayoutConstraint!
    
    let cellId = "cell_players_tournament"
    
    var leagueDetailModel = LeagueDetailModel() {
        didSet {
            updateUI()
        }
    }
    
    var playersArray: [LIPlayer] = [LIPlayer]()
    
    let presenter = PlayersLeagueDetailPresenter()
    
    var filterArguments = [PlayersLeagueDetailViewController.FilterType.matches.rawValue,
                           PlayersLeagueDetailViewController.FilterType.goals.rawValue,
                           PlayersLeagueDetailViewController.FilterType.yellow.rawValue,
                           PlayersLeagueDetailViewController.FilterType.red.rawValue]
    
    var pickerIsShow = true
    
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
        
        picker_view.dataSource = self
        picker_view.delegate = self
    }

    func updateUI() {
        // some
    }
    
    @IBAction func filter_btn_pressed(_ sender: UIButton) {
        if !pickerViewIsHidden() {
            hideFilterPicker()
        } else {
            showFilterPicker()
        }
    }
}

extension PlayersLeagueDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filter_type_btn.setTitle("\(filterArguments[row])", for: .normal)
        filterTable(type: getCurrentFilter(selectedRow: row))
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterArguments.count
    }
    
    func getCurrentFilter(selectedRow row: Int) -> FilterType {
        switch row {
        case 0:
            return .matches
        case 1:
            return .goals
        case 2:
            return .yellow
        case 3:
            return .red
        default:
            return .matches
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterArguments[row]
    }
    
    func showFilterPicker() {
        picker_view.isHidden = false
        self.view.layoutIfNeeded()
        picker_view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.7) {
            self.picker_height.constant = 120
            self.view.layoutIfNeeded()
            self.picker_view.layoutIfNeeded()
        }
    }
    
    func hideFilterPicker() {
        
        self.view.layoutIfNeeded()
        picker_view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.7) {
            self.picker_height.constant = 0
            self.view.layoutIfNeeded()
            self.picker_view.layoutIfNeeded()
        }
        picker_view.isHidden = true
    }
    
    func pickerViewIsHidden() -> Bool {
        return picker_view.isHidden
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
        }
        table_view.reloadData()
    }
    
    enum FilterType : String {
        case matches = "По проведенным матчам"
        case goals = "По забитым мячам"
        case yellow = "По количеству ЖК"
        case red = "По количеству КК"
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

