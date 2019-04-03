//
//  CommandEditLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CommandEditLKViewController: UIViewController {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var commandPlayers: UITableView!
    @IBOutlet weak var commandInvitePlayers: UITableView!
    
    let presenter = CommandEditLKPresenter()
    
    let commandPlayersTableViewHelper = CommandPlayersTableViewHelper()
    
    var participation: Participation?
    
    var team = Team()
    var players = Players()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
        saveBtn.image = saveBtn.image?.af_imageScaled(to: CGSize(width: 24, height: 24))
        
        commandPlayers.dataSource = commandPlayersTableViewHelper
        commandPlayers.delegate = commandPlayersTableViewHelper
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    // MARK: - Toolbar Actions
    
    @IBAction func onAddPlayerBtnPressed(_ sender: UIButton) {
        
    }
    
    // MARK: - Helpers functions
    
    
}

extension CommandEditLKViewController: CommandEditLKView {
    func onGetPersonsComplete(players: Players) {
        commandPlayersTableViewHelper.setTableData(tableData: [CommandPlayersTableViewCell.CellModel(player: Player(), playerImage: UIImage(named: "ic_logo2")!, person: Person())])
    }
    
    func onGetPersonsFailure(error: Error) {
        
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
