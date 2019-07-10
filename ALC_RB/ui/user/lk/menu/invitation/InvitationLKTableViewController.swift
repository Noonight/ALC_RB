//
//  InvitationLKTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 11.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import ESPullToRefresh

class InvitationLKTableViewController: UITableViewController {

    // MARK: - Struct
    
    struct TableModel {
        var tournaments: Tournaments?
        var clubs: Clubs?
        var players: Players?
        
        init (tournaments: Tournaments, clubs: Clubs, players: Players) {
            self.tournaments = tournaments
            self.clubs = clubs
            self.players = players
        }
        
        init () { }
        
        func isEmpty() -> Bool {
            return tournaments == nil || clubs == nil || players == nil
        }
    }
    
    // MARK: - Variables
    
    @IBOutlet var empty_view: UIView!
    
    var tableModel = TableModel() {
        didSet {
            if !tableModel.isEmpty() {
                self.hideLoading()
                self.tableView.reloadData()
            }
        }
    }
    
    var pendingTeamInviteList: [PendingTeamInvite] = []
    
    let userDefault = UserDefaultsHelper()
    
    let cellId = "invitation_cell"
    
    let presenter = InvitationLKPresenter()
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    var viewBack: UIView = UIView()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
        activityIndicator.hidesWhenStopped = true
        
        tableView.tableFooterView = UIView()
        
        tableView.es.addPullToRefresh {
            self.fetch()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if userDefault.getAuthorizedUser()?.person.pendingTeamInvites.count ?? 0 > 0 {
            hideEmptyView()
            if tableModel.isEmpty() {
                showLoading()
            } else {
                hideLoading()
            }
        } else {
            showEmptyView()
        }
    }
    
    func fetch() {
        presenter.refreshUser(token: userDefault.getAuthorizedUser()!.token)
    }
    
    func fetchSupportModels() {
        presenter.getTournaments()
        presenter.getClubs()
        presenter.getPlayers()
    }
        
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDefault.getAuthorizedUser()?.person.pendingTeamInvites.count ?? 0
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InvitationTableViewCell
        let model = userDefault.getAuthorizedUser()?.person.pendingTeamInvites[indexPath.row]
        
        configureCell(model: model!, cell: cell, tag: indexPath.row)
        
        return cell
    }
    
    func configureCell(model: PendingTeamInvite, cell: InvitationTableViewCell, tag: Int) {
        
        if !tableModel.isEmpty() {
            let league = tableModel.tournaments?.leagues.filter({ (league) -> Bool in
                return league.id == model.league
            }).first
            let team = league?.teams.filter({ (team) -> Bool in
                return team.id == model.team
            }).first
            let teamCreator = tableModel.players?.people.filter({ (person) -> Bool in
                return person.id == team?.creator
            }).first
            let club = tableModel.clubs?.clubs.filter({ (club) -> Bool in
                return club.id == team?.club
            }).first
            
            if let mLeague = league {
                cell.titleLabel.text = "\(mLeague.tourney). \(mLeague.name)"
                cell.dateLabel.text = "\(mLeague.beginDate.UTCToLocal(from: .leagueDate, to: .local)) - \(mLeague.endDate.UTCToLocal(from: .leagueDate, to: .local))"
            }
            cell.teamName.text = team?.name
            
            cell.teamTrainer.text = teamCreator?.getFullName()
            
            presenter.getTournamentImage(photoUrl: club?.logo ?? "", get_image_success: { (image) in
                cell.tournamentImage.image = image.af_imageRoundedIntoCircle()
            }) { (error) in
                Print.d(error: error)
            }
        }
        
        cell.cancelBtn.addTarget(self, action: #selector(cancelBtnPressed), for: .touchUpInside)
        cell.okBtn.addTarget(self, action: #selector(okBtnPressed), for: .touchUpInside)
        
        cell.cancelBtn.tag = tag
        cell.okBtn.tag = tag
    }
    
    @objc func cancelBtnPressed(sender: UIButton) {
        Print.d(message: "\(sender.tag)  cancel")
        showAlertOkCancel(title: "Отменить приглашение?", message: "", ok: {
            let user = self.userDefault.getAuthorizedUser()
            guard let league = user?.person.pendingTeamInvites[sender.tag].league else {
                self.showAlert(message: "Лига не найдена")
                return
            }
            guard let team = user?.person.pendingTeamInvites[sender.tag].team else {
                self.showAlert(message: "Команда не найдена")
                return
            }
            self.presenter.acceptRequest(
                token: (user?.token)!,
                acceptInfo: AcceptRequest(
                    idLeague: league,
                    idTeam: team,
                    status: .rejected)
            )
        }) {
            Print.m("cancel cancel")
        }
    }
    
    @objc func okBtnPressed(sender: UIButton) {
        showAlertOkCancel(title: "Принять приглашение?", message: "", ok: {
            let user = self.userDefault.getAuthorizedUser()
            guard let league = user?.person.pendingTeamInvites[sender.tag].league else {
                self.showAlert(message: "Лига не найдена")
                return
            }
            guard let team = user?.person.pendingTeamInvites[sender.tag].team else {
                self.showAlert(message: "Команда не найдена")
                return
            }
            self.presenter.acceptRequest(
                token: (user?.token)!,
                acceptInfo: AcceptRequest(
                    idLeague: league,
                    idTeam: team,
                    status: .accpeted)
            )
        }) {
            Print.m("tap cancel invite")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension InvitationLKTableViewController: EmptyProtocol {
    func showEmptyView() {
        viewBack.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height)
        viewBack.backgroundColor = .white
        viewBack.addSubview(empty_view)

        empty_view.setCenterFromParent()
        
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        view.addSubview(viewBack)
        view.bringSubviewToFront(viewBack)
    }
    
    func hideEmptyView() {
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine
        viewBack.removeFromSuperview()
    }
}

extension InvitationLKTableViewController: ActivityIndicatorProtocol {
    func showLoading() {
        activityIndicator.frame = tableView.frame
        activityIndicator.backgroundColor = .white
        
        tableView.isScrollEnabled = false
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        tableView.isScrollEnabled = true

        activityIndicator.removeFromSuperview()
    }
}

extension InvitationLKTableViewController: InvitationLKView {
    func onRefreshUserSuccess(authUser: AuthUser) {
        userDefault.setAuthorizedUser(user: authUser)
        fetchSupportModels()
        self.tableView.es.stopPullToRefresh()
    }
    
    func onRefreshUserFailure(error: Error) {
        Print.m(error)
        self.tableView.es.stopPullToRefresh()
//        showAlertR
    }
    
    func acceptRequestFailureMessage(message: SingleLineMessage) {
        showAlert(message: message.message)
        self.tableView.es.stopPullToRefresh()
    }
    
    func acceptRequestSuccess(soloPerson: SoloPerson) {
        defer {
            tableView.reloadData()
        }
        var authorizedUser = userDefault.getAuthorizedUser()
        authorizedUser?.person = soloPerson.person
        userDefault.setAuthorizedUser(user: authorizedUser!)
        showAlert(title: "Действие успешно", message: "", closure: {
            self.tableView.reloadData()
        })
        
    }
    
    func acceptRequestFailure(error: Error) {
        showAlert(message: error.localizedDescription)
        Print.d(error: error)
    }
    
    func getTournamentsSuccess(tournaments: Tournaments) {
        tableModel.tournaments = tournaments
    }
    
    func getTournamentsFailure(error: Error) {
        Print.d(error: error)
    }
    
    func getTournamentLeagueSuccess(liLeagueInfo: LILeagueInfo) {
    }
    
    func getTournamentLeagueFailure(error: Error) {
        Print.d(error: error)
    }
    
    func getPlayersSuccess(players: Players) {
        tableModel.players = players
    }
    
    func getPlayersFailure(error: Error) {
        Print.d(error: error)
    }
    
    func getClubsSuccess(clubs: Clubs) {
        tableModel.clubs = clubs
    }
    
    func getClubsFailure(error: Error) {
        Print.d(error: error)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
    
}
