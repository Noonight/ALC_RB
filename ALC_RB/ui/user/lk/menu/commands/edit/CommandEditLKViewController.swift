//
//  CommandEditLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CommandEditLKViewController: BaseStateViewController {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var commandPlayers: UITableView!
    @IBOutlet weak var commandInvitePlayers: UITableView!
    
    let segueAddPlayers = "segue_add_player_to_team"
    
    let presenter = CommandEditLKPresenter()
    
    let commandPlayersTableViewHelper = CommandPlayersTableViewHelper()
    let commandInvPlayersTableViewHelper = CommandInvitePlayersTableViewHelper()
    
    var participation: Participation?
    
    var team = Team()
    var players = Players()
//    var league = League()
    var leagueController: LeagueController!
    var mutablePlayers: [Player] = []

    let userDefaultHelper = UserDefaultsHelper()
    
    // MARK: - model controllers
    var teamController: TeamCommandsController!
    var participationController: ParticipationCommandsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    
//        saveBtn.image = saveBtn.image?.af_imageScaled(to: CGSize(width: 24, height: 24))
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        team.players = (teamController.getTeamById(id: team.id)?.players)!
        mutablePlayers = team.players
        
        presenter.getPersons()
        
        Print.m("We are in CommandEditLKViewController")
        
//        Print.m("team is \(team)")
//        Print.m("participation is \(participation)")
    }

    // MARK: - Toolbar Actions
    
    @IBAction func onAddPlayerBtnPressed(_ sender: UIButton) {
        Print.m("add btn")
    }
    
    // MARK: - Helpers functions
    
    @IBAction func onNavBarSaveBtnPressed(_ sender: UIBarButtonItem) {
        Print.m("save btn")
        Print.m(participation?.league)
        presenter.editCommand(
            token: (userDefaultHelper.getAuthorizedUser()?.token)!,
            editTeam: EditTeam(
                _id: (participation?.league)!,
                teamId: (participation?.team)!,
                players: EditTeam.Players(players: mutablePlayers))
        )
    }
}

extension CommandEditLKViewController: CommandEditLKView {
    func onGetPersonsComplete(players: Players) {
        
//        self.mutablePlayers = play
        
        let teamPlayers = team.players
//        dump(teamPlayers)
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
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
    
    func onEditCommandSuccess(editTeamResponse: EditTeamResponse) {
        self.team.players = editTeamResponse.players
//        self.players = editTeamResponse.players
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueAddPlayers,
            let destination = segue.destination as? CommandAddPlayerTableViewController
        {
            destination.tableModel = CommandAddPlayerTableViewController.TableModel(
//                team: self.team
//                players: self.mutablePlayers
            )
            destination.team = self.team
            destination.leagueId = self.participation?.league
            destination.teamController = self.teamController
//            destination.league = self.league
            destination.leagueController = self.leagueController
        }
    }
}

extension CommandEditLKViewController: OnCommandPlayerDeleteBtnPressedProtocol {
    
    
    func onDeleteBtnPressed(index: IndexPath, model: CommandPlayersTableViewCell.CellModel, success: @escaping () -> ()) {
        Print.m("player table \(index.row)")
        
        
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
        Print.m("player invite table \(index.row)")
//        dump(mutablePlayers)
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
