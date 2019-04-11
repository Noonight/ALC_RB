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
    
    let presenter = CommandEditLKPresenter()
    
    let commandPlayersTableViewHelper = CommandPlayersTableViewHelper()
    let commandInvPlayersTableViewHelper = CommandInvitePlayersTableViewHelper()
    
    var participation: Participation?
    
    var team = Team()
    var players = Players()
    
    var mutablePlayers: [Player] = []

    let userDefaultHelper = UserDefaultsHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
        mutablePlayers = team.players
        
        presenter.getPersons()
        
        saveBtn.image = saveBtn.image?.af_imageScaled(to: CGSize(width: 24, height: 24))
        
        commandPlayers.dataSource = commandPlayersTableViewHelper
        commandPlayers.delegate = commandPlayersTableViewHelper
        
        commandPlayersTableViewHelper.setDeleteBtnProtocol(deleteBtnDelegate: self)
        
        commandInvitePlayers.dataSource = commandInvPlayersTableViewHelper
        commandInvitePlayers.delegate = commandInvPlayersTableViewHelper
        
        commandInvPlayersTableViewHelper.setDeleteBtnProtocol(deleteBtnDelegate: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
        presenter.editCommand(
            token: (userDefaultHelper.getAuthorizedUser()?.token)!,
            editTeam: EditTeam(
                _id: (participation?.league)!,
                teamId: (participation?.team)!,
                players: mutablePlayers)
        )
    }
}

extension CommandEditLKViewController: CommandEditLKView {
    func onGetPersonsComplete(players: Players) {
        
//        self.mutablePlayers = play
        
        let teamPlayers = team.players
        var array : [CommandPlayersTableViewCell.CellModel] = []
        
        var arrayInv: [CommandInvitePlayersTableViewCell.CellModel] = []
        
        for player in teamPlayers {
            for person in players.people {
                if player.playerID == person.id {
                    let randNum = Int.random(in: 0...5)
    
                    // TEST
                    if player.inviteStatus == .pending || randNum > 2 {
                        arrayInv.append(CommandInvitePlayersTableViewCell.CellModel(
                            player: player,
                            person: person,
                            playerImagePath: person.photo ?? "")
                        )
                    }
                    
                    if player.inviteStatus == .accepted || player.inviteStatus == .approved {
                        array.append(CommandPlayersTableViewCell.CellModel(
                            player: player,
                            playerImagePath: person.photo ?? "",
                            person: person)
                        )
                    } else if player.inviteStatus == .pending || randNum > 2 {
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
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
    
    func onEditCommandSuccess(editTeamResponse: EditTeamResponse) {
        presenter.getPersons()
        showToast(message: "Editing successful")
    }
    
    func onEditCommandFailure(error: Error) {
        Print.m(error)
    }
}

extension CommandEditLKViewController: OnCommandPlayerDeleteBtnPressedProtocol {
    func onDeleteBtnPressed(index: IndexPath, model: CommandPlayersTableViewCell.CellModel) {
        Print.m("player table \(index.row)")
        for i in 0...mutablePlayers.count {
            if model.player?.id == mutablePlayers[i].id {
                mutablePlayers.remove(at: i)
                break
            }
        }
    }
}

extension CommandEditLKViewController: OnCommandInvitePlayerDeleteBtnPressedProtocol {
    func onDeleteInvBtnPressed(index: IndexPath, model: CommandInvitePlayersTableViewCell.CellModel) {
        Print.m("player invite table \(index.row)")
        for i in 0...mutablePlayers.count - 1 {
            if model.player?.id == mutablePlayers[i].id {
                mutablePlayers.remove(at: i)
                break
            }
        }
    }
}
