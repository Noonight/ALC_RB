//
//  CommandsLKTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 24.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CommandsLKTableViewController: BaseStateTableViewController {
    enum CellIdentifiers {
        static let COMMAND = "commands_lk_cell"
    }
    enum SegueIdentifiers {
        static let EDIT = "segue_edit_team"
        static let ADD = "segue_add_team"
    }
    enum Texts {
        static let FAIL_TO_RELOAD_DATA = "Не удалось обновить данные"
    }
    
    // MARK: Table model
    struct TableModel {
        var tournaments = Tournaments()
//        var personOwnCommands: [Participation] = [] // user is owner of team
//        var personInsideCommands: [Participation] = [] // user is player of team
        
        var ownerTeams: [Team] = []
        var playerTeams: [Team] = []
        
        let headerOwnerSection = "Мои команды"
        let headerPlayerSection = "Команды"
        
        init () { }
        
        func getLeagueOfTeam(inTeam: Team) -> League? {
            return tournaments.leagues.filter({ league -> Bool in
                return (league.teams!.filter({ team -> Bool in
                    return team.id == inTeam.id
                }).first != nil)
            }).first
        }
        
        func countOfSections () -> Int {
            if ownerTeams.count > 0 && playerTeams.count > 0 {
                return 2
            } else if ownerTeams.count > 0 || playerTeams.count > 0 {
                return 1
            } else {
                return 0
            }
        }
        
        func rowInSections (section: Int) -> Int {
            switch section {
            case 0:
                return ownerTeams.count
//                return personOwnCommands.count
            case 1:
                return playerTeams.count
//                return personInsideCommands.count
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
    
    // MARK: Outlets
    @IBOutlet weak var createNewCommandBtn: UIBarButtonItem!
    
    // MARK: Var & Let
    let userDefaults = UserDefaultsHelper()
    let presenter = CommandsLKPresenter()
    
    var tableModel = TableModel()
    
    // MARK: - model controllers
    var teamOwnerController: TeamCommandsController!
    var teamPlayerController: TeamCommandsController!
    var participationController: ParticipationCommandsController!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preparePresenter()
        self.prepareRefreshing()
        self.prepareEmptyState()
        self.prepareTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = createNewCommandBtn
//        self.updateTableModel()
//        self.prepareCreateCommandBtn()
        
        self.refreshData()
        
        self.prepareModelController {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    // MARK: Prepare
    func prepareTableView() {
        self.tableView.tableFooterView = UIView()
    }
    func prepareEmptyState() {
        setEmptyMessage(message: "Вы пока не участвуете ни в одной команде")
    }
    func prepareRefreshing() {
        self.fetch = self.presenter.fetch
    }
    func preparePresenter() {
        initPresenter()
    }
    func prepareModelController(closure: @escaping ()->()) {
        defer {
            closure()
        }
        let tournaments = tableModel.tournaments
        
        participationController = ParticipationCommandsController(participation: (userDefaults.getAuthorizedUser()?.person.participation)!)
        
        let ownerParticipations = getOwnerParticipations(participation: participationController.participation, tournaments: tournaments)
        
        func getOwnerTeam(participation: Participation, tournaments: Tournaments) -> Team? {
            var returnedTeam: Team?
            for league in tournaments.leagues {
                if participation.league == league.id {
                    for team in league.teams! {
                        if team.id == participation.team {
                            if team.creator == userDefaults.getAuthorizedUser()?.person.id {
                                returnedTeam = team
                            }
                        }
                    }
                }
            }
            return returnedTeam
        }
        
        func getOwnerTeams() -> [Team] {
            var teams: [Team] = []
            for participation in ownerParticipations {
                let team = getOwnerTeam(participation: participation, tournaments: tournaments)
                if team != nil {
                    teams.append(team!)
                }
            }
            return teams
        }
        
        let playerParticipations = getPlayerParticipations(participation: (userDefaults.getAuthorizedUser()?.person.participation)!, tournaments: tournaments)
        
        func getPlayerTeam(participation: Participation, tournaments: Tournaments) -> Team? {
            var returnedTeam: Team?
            for league in tournaments.leagues {
                if participation.league == league.id {
                    for team in league.teams! {
                        if team.id == participation.team {
                            if team.creator != userDefaults.getAuthorizedUser()?.person.id {
                                returnedTeam = team
                            }
                        }
                    }
                }
            }
            return returnedTeam
        }
        
        func getPlayerTeams() -> [Team] {
            var teams: [Team] = []
            for participation in playerParticipations {
                let team = getPlayerTeam(participation: participation, tournaments: tournaments)
                if team != nil {
                    teams.append(team!)
                }
            }
            return teams
        }
        
        teamOwnerController = TeamCommandsController(teams: getOwnerTeams())
        teamPlayerController = TeamCommandsController(teams: getPlayerTeams())
        
        tableModel.ownerTeams = teamOwnerController.teams
        tableModel.playerTeams = teamPlayerController.teams
    }
    func prepareCreateCommandBtn() {
        if userDefaults.getAuthorizedUser()?.person.club?.count == 0 {
            createNewCommandBtn.isEnabled = false
        } else {
            createNewCommandBtn.isEnabled = true
        }
    }
    
    // MARK: Update
    func updateTableModel() {
        self.tableModel.ownerTeams = self.teamOwnerController.teams
        self.tableModel.playerTeams = self.teamPlayerController.teams
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func onAddCommandBtnPressed(_ sender: UIBarButtonItem) {  }
}

// MARK: Helpers

extension CommandsLKTableViewController {
    
    func showRemoveTeamAlert(teamName: String, delete: @escaping () -> (), cancel: @escaping () -> ()) {
        let actionDelete = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            delete()
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            cancel()
        }
        showAlert(title: "Предупреждение!", message: "Удалить команду '\(teamName)'?", actions: [actionDelete, actionCancel])
    }
    
    func getOwnerParticipations(participation: [Participation], tournaments: Tournaments) -> [Participation] {
        var arr : [Participation] = []
        
        for par in participation {
            for league in tournaments.leagues {
                if league.id == par.league {
                    for team in league.teams! {
                        if team.id == par.team {
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
    
    func getPlayerParticipations(participation: [Participation], tournaments: Tournaments) -> [Participation] {
        
        var arr : [Participation] = []
        
        for par in participation {
            for league in tournaments.leagues {
                if league.id == par.league {
                    for team in league.teams! {
                        if team.id == par.team {
                            if team.creator != userDefaults.getAuthorizedUser()?.person.id {
                                arr.append(par)
                            }
                        }
                    }
                }
            }
        }
        
        return arr
    }
}
// MARK: Presenter
extension CommandsLKTableViewController : CommandsLKView {
    func onFetchSuccess() {
        self.prepareModelController() {
            self.endRefreshing()
        }
//        self.endRefreshing()
    }
    
    func onFetchFailure() {
//        showRepeatAlert(message: Texts.FAIL_TO_RELOAD_DATA) {
//            self.refreshData()
//        }
    }
    
    func getRefreshUserSuccessful(authUser: AuthUser) {
        userDefaults.setAuthorizedUser(user: authUser)
//        self.presenter.getTournaments() { }
//        self.authUser = userDefaults.getAuthorizedUser()
        Print.m(authUser)
    }
    
    func getRefreshUserFailure(error: Error) {
//        showAlert(message: error.localizedDescription)
        Print.m(error)
    }
    
    func getTournamentsSuccess(tournaments: Tournaments) {
//        Print.m("get tournament success")
//        tableModel.tournaments = Tournaments()
        tableModel.tournaments = tournaments
//        prepareModelController(tournaments: tournaments)
    }
    
    func getTournamentsFailure(error: Error) {
        Print.m(error)
//        showRepeatAlert(message: error.localizedDescription) {
//            self.presenter.getTournaments() { }
//        }
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

// MARK: Refresh control
extension CommandsLKTableViewController {
    override func hasContent() -> Bool {
        if tableModel.ownerTeams.count != 0 || tableModel.playerTeams.count != 0 {
            return true
        } else {
            return false
        }
//        return true
    }
}

// MARK: - Navigation
extension CommandsLKTableViewController {
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == SegueIdentifiers.EDIT {
            return true
        } else if identifier == SegueIdentifiers.ADD && userDefaults.getAuthorizedUser()?.person.club != nil {
            return true
        } else {
            showAlert(message: "Необходимо создать клуб.")
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.EDIT,
            let destination = segue.destination as? CommandEditLKViewController,
            let indexPath = tableView.indexPathForSelectedRow
        {
            destination.team = tableModel.ownerTeams[indexPath.row]
            destination.participation = participationController.getByTeamId(tableModel.ownerTeams[indexPath.row].id)
            destination.teamController = self.teamOwnerController
            destination.participationController = self.participationController
            destination.leagueController = LeagueController(league: self.tableModel.getLeagueOfTeam(inTeam: tableModel.ownerTeams[indexPath.row])!)
        }
        
        if segue.identifier == SegueIdentifiers.ADD,
            let destination = segue.destination as? CommandCreateLKViewController
        {
            destination.teamController = self.teamOwnerController
            destination.participationController = self.participationController
        }
        
    }
}

// MARK: Table view
extension CommandsLKTableViewController {
    // MARK: Data source
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.COMMAND, for: indexPath) as! CommandsLKTableViewCell
        
        switch indexPath.section {
        case 0:
            let model = tableModel.ownerTeams[indexPath.row]
            configureCell(cell: cell, model: model)
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator
        case 1:
            let model = tableModel.playerTeams[indexPath.row]
            configureCell(cell: cell, model: model)
            cell.accessoryType = .none
        default:
            break
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func configureCell (cell: CommandsLKTableViewCell, model: Team) {
        let tournament = tableModel.tournaments.leagues.filter({ (league) -> Bool in
            return league.teams!.contains(where: { team -> Bool in
                return team.id == model.id
            })
        }).first
        if let tournament = tournament {
            guard let tourney = tournament.tourney else { return }
            guard let name = tournament.name else { return }
            if tourney.contains(".") {
                cell.tournamentTitle_label.text = "\(tourney) \(name)"
            } else {
                cell.tournamentTitle_label.text = "\(tourney). \(name)"
            }
            
            cell.tournamentDate_label.text = "\(tournament.beginDate!.convertDate(from: .leagueDate, to: .local)) - \(tournament.endDate!.convertDate(from: .leagueDate, to: .local))"
            
            cell.tournamentTransfer_label.text = "\(tournament.transferBegin!.convertDate(from: .leagueDate, to: .local)) - \(tournament.transferEnd!.convertDate(from: .leagueDate, to: .local))"
            
            if tournament.betweenBeginEndDate() {
                cell.tournamentTitle_label.textColor = .red
                cell.tournamentTransfer_label.textColor = .red
            } else {
                cell.tournamentTitle_label.textColor = .black
                cell.tournamentTransfer_label.textColor = .black
            }
        }
        cell.commandTitle_label.text = model.name
        
        var playerList: [Player] = []
        
        for player in model.players {
            if player.getInviteStatus() == InviteStatus.accepted || player.getInviteStatus() == InviteStatus.approved {
                playerList.append(player)
            }
        }
        cell.countOfPlayers_label.text = "\(playerList.count)"
        
        switch model.getTeamStatus() {
        case .approved:
            cell.status_label.text = "Утверждена"
            if #available(iOS 11.0, *) {
                cell.status_label.textColor = UIColor(named: "colorPrimary")
            } else {
                // Fallback on earlier versions
            }
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
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if indexPath.section == 0 {
                showRemoveTeamAlert(teamName: tableModel.ownerTeams[indexPath.row].name, delete: {
                    self.tableModel.ownerTeams.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                    // TODO: do api request to delete team
                }) {
                    Print.m("cancel team delete")
                }
//                Print.m("delete cell at \(indexPath.row) -> \(tableModel.ownerTeams[indexPath.row])")
            }
            if indexPath.section == 1 {
                showRemoveTeamAlert(teamName: tableModel.playerTeams[indexPath.row].name, delete: {
                    self.tableModel.playerTeams.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                }) {
                    Print.m("cancel team delete")
                }
                
//                Print.m("delete cell at \(indexPath.row) -> \(tableModel.fplayerTeams[indexPath.row])")
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 { // logic: only owner of team can edit it
            return indexPath
        } else {
            return nil
        }
    }
}
