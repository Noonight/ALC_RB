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
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var table_header_view: UIView!
    
    let presenter = PlayersTeamLeagueDetailPresenter()
    
    let cellId = "player_team_cell"
    
    //var leagueDetailModel: LeagueDetailModel = LeagueDetailModel()
    var _team: LITeam = LITeam()
    var team: LITeam {
        get {
            return self._team
        }
        set (newValue) {
            var newVal = newValue
            let filteredPlayers = newVal.players?.filter({ liPLayer -> Bool in
                return liPLayer.getInviteStatus() == .accepted || liPLayer.getInviteStatus() == .approved
            })
            if let teamPlayers = filteredPlayers {
                newVal.players = teamPlayers
            }
            _team = newVal
        }
    }
    var fetchedPersons: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        initView()
    }
    
    func initView() {
        presenter.getClubOwnerImage(club: team.club!, get_image: { (image) in
            self.photo_trainer_img.image = image//.af_imageRoundedIntoCircle()
        }) {
            // noting but if something went wrong make it
        }
        presenter.getTeamCreatorName(creator: team.creator!) { (name) in
            self.name_trainer_label.text = name
        }
        
        table_view.dataSource = self
        table_view.delegate = self
        
        //table_view.tableHeaderView = table_header_view
    }
    
    func updateUI() {
        
    }
}

extension PlayersTeamLeagueDetailViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

extension PlayersTeamLeagueDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: table_view.frame.width, height: 74))
        table_header_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 74)
        view.addSubview(table_header_view)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 74
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team.players!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PlayersTeamLeagueDetailTableViewCell
        
        let model = team.players![indexPath.row]
        
        configureCell(cell: cell, model: model)
        
        return cell
    }
    
    func configureCell(cell: PlayersTeamLeagueDetailTableViewCell, model: LIPlayer) {
        
        func setupCell(person: Person) {
            cell.name.text = person.getSurnameNP()
            cell.games.text = String(model.matches)
            cell.goals.text = String(model.goals)
            cell.yellow_cards.text = String(model.yellowCards)
            cell.disqualifications.text = String(model.disquals)
        }
        
        if let fetchedPerson = fetchedPersons.filter({ person -> Bool in
            return person.id == model.playerId
        }).first {
            setupCell(person: fetchedPerson)
        } else {
            let hud = cell.showLoadingViewHUD()
            presenter.getPlayer(player: model.playerId)
            { (person) in
                self.fetchedPersons.append(person.person)
                setupCell(person: person.person)
                hud.hide(animated: true)
//                hud.hideAfter(seconds: 10)
            }
        }
    }
    
}

extension PlayersTeamLeagueDetailViewController: UITableViewDelegate {
    
}

