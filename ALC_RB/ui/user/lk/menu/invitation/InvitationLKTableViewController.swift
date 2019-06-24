//
//  InvitationLKTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 11.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift

class InvitationLKTableViewController: UITableViewController {

    // MARK: - Struct
    
    struct TableModel {
        var tournaments: Tournaments?
//        var liLeagueInfo: LILeagueInfo?
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
//            Print.d(object: tableModel.isEmpty())
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
    
//    var backgroundActivityView: UIView?
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    var viewBack: UIView = UIView()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
//        var user = userDefault.getAuthorizedUser()
//        user?.person.pendingTeamInvites = [
//            PendingTeamInvite("12swdf234te5g34t3", "5be94d1a06af116344942a92", "5be94d1a06af116344942b2a"),
//            PendingTeamInvite("12swdf234te5g34asdt3", "5be94d1a06af116344942a92", "5be94d1a06af116344942a93"),
//            PendingTeamInvite("12swdf234te5123g34t3", "5be94d1a06af116344942a92", "5be94d1a06af116344942aad")
//        ]
//        userDefault.setAuthorizedUser(user: user!)
//        var user = userDefault.getAuthorizedUser()
//        user?.person.pendingTeamInvites = []
//        userDefault.setAuthorizedUser(user: user!)
        
        activityIndicator.hidesWhenStopped = true
        
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        if userDefault.getAuthorizedUser()?.person.pendingTeamInvites.count ?? 0 > 0 {
//            hideEmptyView()
//            if tableModel.isEmpty() {
//                showLoading()
//            } else {
//                hideLoading()
//            }
//        } else {
//            showEmptyView()
//        }
        
//        showHudTable(message: "Загрузка")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            self.tableView.reloadData()
//            self.showLoading()
        }
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
    
    func checkPendingTeamInviteList() {
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDefault.getAuthorizedUser()?.person.pendingTeamInvites.count ?? 0
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 224
//    }

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
                cell.dateLabel.text = "\(mLeague.beginDate.UTCToLocal(from: .utc, to: .local)) - \(mLeague.endDate.UTCToLocal(from: .utc, to: .local))"
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
        let user = userDefault.getAuthorizedUser()
        presenter.acceptRequest(
            token: (userDefault.getAuthorizedUser()?.token)!,
            acceptInfo: AcceptRequest(
                idLeague: user?.person.pendingTeamInvites[sender.tag].league ?? "",
                idTeam: user?.person.pendingTeamInvites[sender.tag].team ?? "",
                status: .rejected)
        )
    }
    
    @objc func okBtnPressed(sender: UIButton) {
        Print.d(message: "\(sender.tag)  ok")
        let user = userDefault.getAuthorizedUser()
        presenter.acceptRequest(
            token: (userDefault.getAuthorizedUser()?.token)!,
            acceptInfo: AcceptRequest(
                idLeague: user?.person.pendingTeamInvites[sender.tag].league ?? "",
                idTeam: user?.person.pendingTeamInvites[sender.tag].team ?? "",
                status: .accpeted)
        )
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
        
//        let constraintX = NSLayoutConstraint(item: viewBack, attribute: .centerX, relatedBy: .equal, toItem: empty_view, attribute: .centerX, multiplier: 1.0, constant: 0)
//        let constraintY = NSLayoutConstraint(item: viewBack, attribute: .centerY, relatedBy: .equal, toItem: empty_view, attribute: .centerY, multiplier: 1.0, constant: 0)
//        viewBack.addConstraints([
//            constraintX,
//            constraintY])

        empty_view.setCenterFromParent()
        
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        view.addSubview(viewBack)
        view.bringSubviewToFront(viewBack)
    }
    
    func hideEmptyView() {
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine
        //        tableView.separatorStyle = .singleLine
        //        tableView.backgroundView = nil
        viewBack.removeFromSuperview()
    }
}

extension InvitationLKTableViewController: ActivityIndicatorProtocol {
    func showLoading() {
//        activityIndicator.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        activityIndicator.frame = tableView.frame
        activityIndicator.backgroundColor = .white
        
        tableView.isScrollEnabled = false
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        
//        tableView.separatorStyle = .none
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        tableView.isScrollEnabled = true

//        tableView.separatorStyle = .singleLine
//        tableView.backgroundView = nil
        activityIndicator.removeFromSuperview()
    }
}

extension InvitationLKTableViewController: InvitationLKView {
    
    func acceptRequestSuccess(authUser: AuthUser) {
        Print.d(object: authUser)
        userDefault.deleteAuthorizedUser()
        userDefault.setAuthorizedUser(user: authUser)
        tableView.reloadData()
    }
    
    func acceptRequestFailure(error: Error) {
        showToast(message: "Что-то пошло не так. Ошибка")
        Print.d(error: error)
    }
    
    func getTournamentsSuccess(tournaments: Tournaments) {
        tableModel.tournaments = tournaments
    }
    
    func getTournamentsFailure(error: Error) {
        Print.d(error: error)
    }
    
    func getTournamentLeagueSuccess(liLeagueInfo: LILeagueInfo) {
//        tableModel.liLeagueInfo = liLeagueInfo
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
        presenter.getTournaments()
//        presenter.getTournamentLeague(id: userDefault.getAuthorizedUser()?.person.pendingTeamInvites)
        presenter.getClubs()
        presenter.getPlayers()
//        presenter.getPlayersWithQuery(query: <#T##String#>)
    }
    
}
