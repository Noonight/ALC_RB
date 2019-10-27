//
//  CommandEditLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CommandEditLKViewController: BaseStateViewController {
    enum SegueIdentifiers {
        static let ADD_PLAYER = "segue_add_player_to_team"
    }
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var commandPlayers: IntrinsicTableView!
    @IBOutlet weak var commandInvitePlayers: IntrinsicTableView!
    
    // MARK: Var & Let
    
    let presenter = CommandEditLKPresenter()
    
    let commandPlayersTableViewHelper = CommandPlayersTableViewHelper()
    let commandInvPlayersTableViewHelper = CommandInvitePlayersTableViewHelper()
    
    var participation: Participation?
    
    var team = Team()
    var players = Players()
    var leagueController: LeagueController!
    var mutablePlayers: [Player] = []

    let userDefaultHelper = UserDefaultsHelper()
    
    // MARK: - model controllers
    var teamController: TeamCommandsController!
    var participationController: ParticipationCommandsController!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPresenter()
        self.setupTableViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        team.players = (teamController.getTeamById(id: team.id)?.players)!
        mutablePlayers = team.players
        
        presenter.getPersons()
    }
    
    func setupTableViews() {
        commandPlayers.dataSource = commandPlayersTableViewHelper
        commandPlayers.delegate = commandPlayersTableViewHelper
        
        commandPlayersTableViewHelper.setDeleteBtnProtocol(deleteBtnDelegate: self)
        commandPlayersTableViewHelper.setEditNumberCompleteProtocol(editNumberProtocol: self)
        
        commandInvitePlayers.dataSource = commandInvPlayersTableViewHelper
        commandInvitePlayers.delegate = commandInvPlayersTableViewHelper
        
        commandInvPlayersTableViewHelper.setDeleteBtnProtocol(deleteBtnDelegate: self)
        
        commandInvitePlayers.tableFooterView = UIView()
        commandPlayers.tableFooterView = UIView()
    }
    
    func setupPresenter() {
        self.initPresenter()
    }
}

// MARK: Extensions

// MARK: Actions

extension CommandEditLKViewController {
    
    @IBAction func onAddPlayerBtnPressed(_ sender: UIButton) { }
    
    @IBAction func onNavBarSaveBtnPressed(_ sender: UIBarButtonItem) {
        presenter.editCommand(
            token: (userDefaultHelper.getAuthorizedUser()?.token)!,
            editTeam: EditTeam(
                _id: (participation?.league)!,
                teamId: (participation?.team)!,
                players: EditTeam.Players(players: mutablePlayers))
        )
    }
}

// MARK: Presenter

extension CommandEditLKViewController: CommandEditLKView {
    func onGetPersonsComplete(players: Players) {
        
        let teamPlayers = team.players
        var array : [CommandPlayersTableViewCell.CellModel] = []
        
        var arrayInv: [CommandInvitePlayersTableViewCell.CellModel] = []
        
        for player in teamPlayers {
            for person in players.people {
                if player.playerID == person.id {
                    
                    if player.getInviteStatus() == .accepted || player.getInviteStatus() == .approved {
                        array.append(CommandPlayersTableViewCell.CellModel(
                            player: player,
                            playerImagePath: person.photo ?? "",
                            person: person)
                        )
                    } else if player.getInviteStatus() == .pending /*|| randNum > 2 */{
                    arrayInv.append(CommandInvitePlayersTableViewCell.CellModel(
                        player: player,
                        person: person,
                        playerImagePath: person.photo ?? "")
                        )
                    }
                }
            }
        }
        
        commandPlayersTableViewHelper.setTableData(tableData: array)
        commandPlayers.reloadData()
        
        commandInvPlayersTableViewHelper.setTableData(tableData: arrayInv)
        commandInvitePlayers.reloadData()
    }
    
    func onGetPersonsFailure(error: Error) {
        Print.m(error)
        showAlert(message: error.localizedDescription)
    }
    
    func onEditCommandSuccess(editTeamResponse: EditTeamResponse) {
        self.team.players = editTeamResponse.players
        self.teamController.setPlayersByTeamId(id: self.team.id, players: editTeamResponse.players)
        self.leagueController.editTeamPlayersById(teamId: self.team.id, players: editTeamResponse.players)
        presenter.getPersons()
        showAlert(title: "Изменения успешно сохранены", message: "")
    }
    
    func onEditCommandFailure(error: Error) {
        Print.m(error)
        showAlert(message: error.localizedDescription)
    }
    
    func onEditCommandSingleLineMessageSuccess(singleLineMessage: SingleLineMessage) {
        showAlert(title: "", message: singleLineMessage.message)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

// MARK: Navigation

extension CommandEditLKViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.ADD_PLAYER,
            let destination = segue.destination as? CommandAddPlayerTableViewController
        {
            destination.tableModel = CommandAddPlayerTableViewController.TableModel()
            destination.team = self.team
            destination.leagueId = self.participation?.league
            destination.teamController = self.teamController
            destination.leagueController = self.leagueController
        }
    }
}

// MARK: Delegates ( Edit / Delete )

extension CommandEditLKViewController: OnCommandPlayerDeleteBtnPressedProtocol {
    
    func onDeleteBtnPressed(index: IndexPath, model: CommandPlayersTableViewCell.CellModel, success: @escaping () -> ()) {
        for i in 0...mutablePlayers.count {
            if model.player?.id == mutablePlayers[i].id {
                
                if mutablePlayers[i].playerID == userDefaultHelper.getAuthorizedUser()?.person.id { // i can't delete teams' trainer
                    showAlert(message: "Вы пытаетесь исключить тренера.")
                } else {
                    if let personName = model.person?.getFullName() {
                        showAlertOkCancel(title: "Внимание", message: "Исключить игрока \(personName)?", ok: {
                            self.mutablePlayers.remove(at: i)
                            success()
                        }) {
                            Print.m("Отмена удаления игрока")
                        }
                    } else {
                        showAlertOkCancel(title: "Внимание", message: "Исключить игрока?", ok: {
                            self.mutablePlayers.remove(at: i)
                            success()
                        }) {
                            Print.m("Отмена удаления игрока")
                        }
                    }
                }
                break
            }
        }
    }
}

extension CommandEditLKViewController: OnCommandInvitePlayerDeleteBtnPressedProtocol {
    
    func onDeleteInvBtnPressed(index: IndexPath, model: CommandInvitePlayersTableViewCell.CellModel, success: @escaping () -> ()) {
        for i in 0...mutablePlayers.count/* - 1*/ {
            if model.player?.id == mutablePlayers[i].id {
                if let personName = model.person?.getFullName() {
                    showAlertOkCancel(title: "Внимание", message: "Отозвать приглашение для игрока \(personName)?", ok: {
                        self.mutablePlayers.remove(at: i)
                        success()
                    }) {
                        Print.m("cancel delete")
                    }
                } else {
                    showAlertOkCancel(title: "Внимание", message: "Отозвать приглашение для игрока?", ok: {
                        self.mutablePlayers.remove(at: i)
                        success()
                    }) {
                        Print.m("cencel delete")
                    }
                }
                
                break
            }
        }
    }
}

extension CommandEditLKViewController: OnCommandPlayerEditNumberCompleteProtocol {
    func onEditNumberComplete(model: CommandPlayersTableViewCell.CellModel) {
        for i in 0...mutablePlayers.count {
            if model.player?.id == mutablePlayers[i].id {
                mutablePlayers[i].number = model.player!.number
                break
            }
        }
    }
}
