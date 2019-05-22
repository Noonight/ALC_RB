//
//  CommandsLKTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 24.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CommandsLKTableViewController: BaseStateTableViewController {

    struct TableModel {
        var tournaments = Tournaments()
        var personOwnCommands: [Participation] = [] // user is owner of team
        var personInsideCommands: [Participation] = [] // user is player of team
        
        let headerOwnerSection = "Мои команды"
        let headerPlayerSection = "Команды"
        
        init () {
        }
        
        func isEmpty() -> Bool {
            if personOwnCommands.count == 0 && personInsideCommands.count == 0 {
                return true
            }
            return false
        }
        
        func commandsIsEmpty() -> Bool {
            if personOwnCommands.count != 0 || personInsideCommands.count != 0 {
                return false
            }
            return true
        }
        
        func countOfSections () -> Int {
            if personOwnCommands.count > 0 && personInsideCommands.count > 0 {
                return 2
            } else if personOwnCommands.count > 0 || personInsideCommands.count > 0 {
                return 1
            } else {
                return 0
            }
        }
        
        func rowInSections (section: Int) -> Int {
            switch section {
            case 0:
                return personOwnCommands.count
            case 1:
                return personInsideCommands.count
            default:
                return 0
            }
        }
        
        func headerTitleForSection(section: Int) -> String {
            switch section {
            case 0:
                return headerOwnerSection
            case 1:
                return headerPlayerSection
            default:
                return "Something went wrong look at table view data source ->> sections"
            }
        }
    }
    
    @IBOutlet weak var createNewCommandBtn: UIBarButtonItem!
    
    let cellId = "commands_lk_cell"
    let segueId = "segue_edit_team"
    let userDefaults = UserDefaultsHelper()
    
    let presenter = CommandsLKPresenter()
    
    var tableModel = TableModel() {
        didSet {
            Print.m("tableModel ->> person own commands \(tableModel.personOwnCommands)")
            Print.m("tableModel ->> person inside commands \(tableModel.personInsideCommands)")
            updateUI()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
        tableView.backgroundView = UIView()
        
        setEmptyMessage(message: "Вы пока не участвуете ни в одной команде")
        
        var user = userDefaults.getAuthorizedUser()

        user?.person.participation = [
            Participation(league: "5be94d1a06af116344942a92", id: "23r42gerwgwscw2r", team: "5be94d1a06af116344942a93"),
            Participation(league: "5be94d1a06af116344942a92", id: "wdfv34t34bt34", team: "5be94d1a06af116344942aff"),
            Participation(league: "5be94d1a06af116344942a92", id: "sdf3v4t34tb34", team: "5be94d1a06af116344942ad0"),
            Participation(league: "5be94d1a06af116344942a92", id: "sdfv34tn3y4esd", team: "5be94d1a06af116344942aad")
        ]

        userDefaults.setAuthorizedUser(user: user!)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter.getTournaments()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = createNewCommandBtn
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//            self.updateUI()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        let person = userDefaults.getAuthorizedUser()?.person
        
        
        updateUI()
//        if person?.participation.count ?? 0 > 0 {
//
//            //            Print.m("count of participation > 0 ->> \(person?.participation)")
//            //            setState(state: .loading)
//            updateUI()
//        } else {
//            setState(state: .empty)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    // MARK: - Helpers
    
    var preparingByTournaments = 0
    
    func updateUI() {
        Print.m("Update ui start")
        if userDefaults.getAuthorizedUser()?.person.participation.count ?? 0 > 0 {
            
            //            Print.m("count of participation > 0 ->> \(person?.participation)")
            //            setState(state: .loading)
            if !tableModel.isEmpty() || !tableModel.commandsIsEmpty() {
                Print.m("table model not empty ->> \(!tableModel.isEmpty())")
                Print.m("table model commands not empty ->> \(!tableModel.commandsIsEmpty())")
                //            Print.m("table model not empty")
                setState(state: .normal)
                tableView.reloadData()
                
                Print.m(tableModel.personOwnCommands)
                Print.m(tableModel.personInsideCommands)
                
            } else {
                // preparing person commands
                if tableModel.tournaments.leagues.count > 0 && preparingByTournaments == 0 {
                    Print.m("we are here")
                    let group = DispatchGroup()
                    group.enter()
                    
                    DispatchQueue.main.async {
                        self.preparePersonCommands()
                        group.leave()
                    }
                    
                    group.notify(queue: .main) {
                        self.preparingByTournaments = 1
                        
                        self.updateUI()
                    }
                }
                Print.m("Set state to loading")
                setState(state: .loading)
            }
        } else {
            setState(state: .empty)
        }
        
    }
    
    func preparePersonCommands () {
        
        tableModel.personOwnCommands = getPersonOwnCommands(participation: (userDefaults.getAuthorizedUser()?.person.participation)!, tournaments: tableModel.tournaments)
        
        tableModel.personInsideCommands = getPersonCommands(participation: (userDefaults.getAuthorizedUser()?.person.participation)!, tournaments: tableModel.tournaments)
        
    }
    
    func getPersonOwnCommands(participation: [Participation], tournaments: Tournaments) -> [Participation] {
        var arr : [Participation] = []
        
        for par in participation {
            for league in tournaments.leagues {
                if league.id == par.league {
                    for team in league.teams {
                        if team.id == par.team {
                            let randomNum = Int.random(in: 0 ... 5)
                            if randomNum > 2 {
                                arr.append(par)
                            }
                            if team.creator == userDefaults.getAuthorizedUser()?.person.id {
                                arr.append(par)
                            }
                        }
                    }
                }
            }
        }
        
        return arr
    }
    
    func getPersonCommands(participation: [Participation], tournaments: Tournaments) -> [Participation] {
        
        var arr : [Participation] = []
        
        for par in participation {
            for league in tournaments.leagues {
                if league.id == par.league {
                    for team in league.teams {
                        if team.id == par.team {
//                            if team.creator != userDefaults.getAuthorizedUser()?.person.id {
                                arr.append(par)
//                            }
                        }
                    }
                }
            }
        }
        
        return arr
    }
    
    // MARK: - Actions
    
    @IBAction func onAddCommandBtnPressed(_ sender: UIBarButtonItem) {
        showToast(message: "btn pressed")
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableModel.headerTitleForSection(section: section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.rowInSections(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommandsLKTableViewCell

        switch indexPath.section {
        case 0:
            let model = tableModel.personOwnCommands[indexPath.row]
            configureCell(cell: cell, model: model)
            cell.selectionStyle = .default
        case 1:
            let model = tableModel.personInsideCommands[indexPath.row]
            configureCell(cell: cell, model: model)
        default:
            break
        }
        
        cell.selectionStyle = .none

        return cell
    }
    
    func configureCell (cell: CommandsLKTableViewCell, model: Participation) {
        let tournament = tableModel.tournaments.leagues.filter({ (league) -> Bool in
            return league.id == model.league
        }).first
        let team = tournament?.teams.filter({ (team) -> Bool in
            return team.id == model.team
        }).first
        if let tournament = tournament {
            cell.tournamentTitle_label.text = "\(tournament.name). \(tournament.tourney)"
            
            cell.tournamentDate_label.text = "\(tournament.beginDate.UTCToLocal(from: .leagueDate, to: .local)) - \(tournament.endDate.UTCToLocal(from: .leagueDate, to: .local))"
            
            cell.tournamentTransfer_label.text = "\(tournament.transferBegin.UTCToLocal(from: .leagueDate, to: .local)) - \(tournament.transferEnd.UTCToLocal(from: .leagueDate, to: .local))"
            
        }
        if let team = team {
            cell.commandTitle_label.text = team.name
            
            var playerList: [Player] = []
            
            for player in team.players {
                if player.getInviteStatus() == InviteStatus.accepted || player.getInviteStatus() == InviteStatus.approved {
                    playerList.append(player)
                }
            }
            cell.countOfPlayers_label.text = "\(playerList.count)"
            
            switch team.getTeamStatus() {
            case .approved:
                cell.status_label.text = "Утверждена"
                if #available(iOS 11.0, *) {
                    cell.status_label.textColor = UIColor(named: "colorPrimary")
                } else {
                    // Fallback on earlier versions
                }
                
//                cell.status_label.tintColor =
            case .rejected:
                cell.status_label.text = "Отклонена"
                if #available(iOS 11.0, *) {
                    cell.status_label.textColor = UIColor(named: "colorBadge")
                } else {
                    // Fallback on earlier versions
                }
            case .pending:
                cell.status_label.text = "Ожидание"
            case .fail:
                Print.m("default break off")
            }
        }
    }
    
    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return indexPath
        } else {
            return nil
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId,
            let destination = segue.destination as? CommandEditLKViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
//            destination.team = tableModel.personOwnCommands[cellIndex]
            destination.team = (tableModel.tournaments.leagues.filter { (league) -> Bool in
                return league.id == tableModel.personOwnCommands[cellIndex].league
                }.first?
                .teams.filter({ (team) -> Bool in
                    return team.id == tableModel.personOwnCommands[cellIndex].team
                }).first!)!
            destination.participation = tableModel.personOwnCommands[cellIndex]
        }
        
    }
}

extension CommandsLKTableViewController : CommandsLKView {
    func getTournamentsSuccess(tournaments: Tournaments) {
        tableModel.tournaments = tournaments
    }
    
    func getTournamentsFailure(error: Error) {
        Print.m(error)
    }
    
    func getLeagueInfoSuccess(leagueInfo: LILeagueInfo) {
        
    }
    
    func getLeagueInfoFailure(error: Error) {
        
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
    
    
}
