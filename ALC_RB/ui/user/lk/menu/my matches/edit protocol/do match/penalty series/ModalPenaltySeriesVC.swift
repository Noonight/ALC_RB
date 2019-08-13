//
//  PenaltySeriesViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import SPStorkController

class ModalPenaltySeriesVC: UIViewController {
    
    // MARK: OUTLETS
    
    @IBOutlet weak var team_one_label: UILabel!
    @IBOutlet weak var team_two_label: UILabel!
    @IBOutlet weak var score_team_one_label: UILabel!
    @IBOutlet weak var score_team_two_label: UILabel!
    
    @IBOutlet weak var first_team_table: UITableView!
    @IBOutlet weak var second_team_table: UITableView!
    
    @IBOutlet weak var team_one_view: UIView!
    @IBOutlet weak var team_two_view: UIView!
    
    @IBOutlet weak var current_status_view: UIView!
    @IBOutlet weak var goal_btn: UIButton!
    @IBOutlet weak var goal_failure_btn: UIButton!
    
    // MARK: VAR & LET
    
    var teamOneTable: PenaltyTableView = PenaltyTableView()
    var teamTwoTable: PenaltyTableView = PenaltyTableView()
    var currentTurn: PenaltyTurn = .none {
        didSet {
            self.viewModel.currentTurn = self.currentTurn
            switch currentTurn {
            case .one:
                self.current_status_view.backgroundColor = team_one_view.backgroundColor
            case .two:
                self.current_status_view.backgroundColor = team_two_view.backgroundColor
            case .none:
                self.current_status_view.backgroundColor = UIColor.white
            }
        }
    }
    var viewModel: ModalPenaltySeriesVM = ModalPenaltySeriesVM()
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableViewCells()
        self.setupTableViewsDelegate()
        self.setupTeamViewButtons()
        self.setupPenaltyButtons()
        self.setupTableViewDataSources()
    }

}

// MARK: EXTENSIONS

// MARK: SETUP

extension ModalPenaltySeriesVC {
    
    func setupTableViewCells() {
        self.first_team_table.register(teamOneTable.cellNib, forCellReuseIdentifier: PenaltyTableView.CellIdentifiers.CELL)
        self.second_team_table.register(teamTwoTable.cellNib, forCellReuseIdentifier: PenaltyTableView.CellIdentifiers.CELL) // SEE HERE MB BUG
    }
    
    func setupTableViewsDelegate() {
        self.first_team_table.dataSource = teamOneTable
        self.first_team_table.delegate = teamOneTable
        
        self.second_team_table.dataSource = teamTwoTable
        self.second_team_table.delegate = teamTwoTable
    }
    
    func setupTableViewDataSources() {
        self.teamOneTable.dataSource = self.viewModel.prepareTableDataFor(team: .one)
        self.teamTwoTable.dataSource = self.viewModel.prepareTableDataFor(team: .two)
        
        self.first_team_table.reloadData()
        self.second_team_table.reloadData()
    }
    
    func setupTeamViewButtons() {
        self.team_one_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTeamOneViewPressed(_:))))
        self.team_two_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTeamTwoViewPressed(_:))))
    }
    
    func setupPenaltyButtons() {
        self.goal_btn.addTarget(self, action: #selector(onGoalPressed(_:)), for: .touchUpInside)
        self.goal_failure_btn.addTarget(self, action: #selector(onGoalFailurePressed(_:)), for: .touchUpInside)
    }
    
}

// MARK: ACTIONS

extension ModalPenaltySeriesVC {
    
    @objc func onTeamOneViewPressed(_ view: UIView) {
        self.currentTurn = .one
    }

    @objc func onTeamTwoViewPressed(_ view: UIView) {
        self.currentTurn = .two
    }
    
    @objc func onGoalPressed(_ btn: UIButton) {
        
    }
    
    @objc func onGoalFailurePressed(_ btn: UIButton) {
        
    }
    
}

// MARK: HELPERS

extension ModalPenaltySeriesVC {
    
}

// MARK: SP STROKE CONTROLLER DELEGATE

extension ModalPenaltySeriesVC: SPStorkControllerConfirmDelegate {
    var needConfirm: Bool {
        return false
    }
    
    func confirm(_ completion: @escaping (Bool) -> ()) {
        let alertController = UIAlertController(title: "Need dismiss?", message: "It test confirm option for SPStorkController", preferredStyle: .actionSheet)
        alertController.addDestructiveAction(title: "Confirm", complection: {
            completion(true)
        })
        alertController.addCancelAction(title: "Cancel") {
            completion(false)
        }
        self.present(alertController, animated: true)

    }
    
    
}
