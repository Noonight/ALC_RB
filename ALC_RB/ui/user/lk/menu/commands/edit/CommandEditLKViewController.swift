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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
        presenter.getPersons()
        
        saveBtn.image = saveBtn.image?.af_imageScaled(to: CGSize(width: 24, height: 24))
        
        commandPlayers.dataSource = commandPlayersTableViewHelper
        commandPlayers.delegate = commandPlayersTableViewHelper
        
        commandInvitePlayers.dataSource = commandInvPlayersTableViewHelper
        commandInvitePlayers.delegate = commandInvPlayersTableViewHelper
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        Print.m("team is \(team)")
        Print.m("participation is \(participation)")
    }

    // MARK: - Toolbar Actions
    
    @IBAction func onAddPlayerBtnPressed(_ sender: UIButton) {
        Print.m("add btn")
    }
    
    // MARK: - Helpers functions
    
    
}

extension CommandEditLKViewController: CommandEditLKView {
    func onGetPersonsComplete(players: Players) {
        let teamPlayers = team.players
        var array : [CommandPlayersTableViewCell.CellModel] = []
        
        var arrayInv: [CommandInvitePlayersTableViewCell.CellModel] = []
        
        for player in teamPlayers {
            for person in players.people {
                if player.playerID == person.id {
                    if player.inviteStatus == .accepted || player.inviteStatus == .approved {
                        array.append(CommandPlayersTableViewCell.CellModel(
                            player: player,
                            playerImagePath: person.photo ?? "",
                            person: person)
                        )
                    } else if player.inviteStatus == .pending {
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
}
