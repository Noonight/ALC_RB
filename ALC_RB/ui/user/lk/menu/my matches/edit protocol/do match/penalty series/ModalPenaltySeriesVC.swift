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
    
    @IBOutlet weak var first_team_table: IntrinsicTableView!
    @IBOutlet weak var second_team_table: IntrinsicTableView!
    
    @IBOutlet weak var team_one_view: UIView!
    @IBOutlet weak var team_two_view: UIView!
    
    @IBOutlet weak var team_one_count_of_penalties: UILabel!
    @IBOutlet weak var team_two_count_of_penalties: UILabel!
    
    @IBOutlet weak var current_status_view: UIView!
    @IBOutlet weak var goal_btn: UIButton!
    @IBOutlet weak var goal_failure_btn: UIButton!
    
    @IBOutlet weak var undo_last_btn: UIButton!
    
    @IBOutlet weak var l_score_border_view: DesignableView!
    @IBOutlet weak var r_score_border_view: DesignableView!
    
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
    var dismissalDelegate: DismissModalPenaltySeriesVC!
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewBorders()
        self.setupStaticViews()
        self.setupTableViewCells()
        self.setupTableViewsDelegate()
        self.setupTeamViewButtons()
        self.setupPenaltyButtons()
        self.setupTableViewDataSources()
        self.setupUndoLastBtn()
        
        self.setupDynamicViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissalDelegate.dismiss(viewModel: self.viewModel)
        
        Print.m("will disappear")
    }
}

// MARK: EXTENSIONS

// MARK: SETUP

extension ModalPenaltySeriesVC {
    
    func setupViewBorders() {
        l_score_border_view.borderWidth = 2
        l_score_border_view.borderColor = .red
        r_score_border_view.borderWidth = 2
        r_score_border_view.borderColor = .red
    }
    
    func setupUndoLastBtn() {
        self.undo_last_btn.addTarget(self, action: #selector(onUndoLastPressed(_:)), for: .touchUpInside)
    }
    
    func setupStaticViews() {
        self.team_one_label.text = self.viewModel.prepareTeamTitle(team: .one)
        self.team_two_label.text = self.viewModel.prepareTeamTitle(team: .two)
    }
    
    func setupDynamicViews() {
        self.score_team_one_label.text = String(self.viewModel.prepareTeamPenaltyScore(team: .one))
        self.score_team_two_label.text = String(self.viewModel.prepareTeamPenaltyScore(team: .two))
        
        self.team_one_count_of_penalties.text = String(self.viewModel.prepareTeamCountOfPenaltiesFor(team: .one))
        self.team_two_count_of_penalties.text = String(self.viewModel.prepareTeamCountOfPenaltiesFor(team: .two))
    }
    
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
    
    @objc func onUndoLastPressed(_ btn: UIButton) {
        self.viewModel.undoLastEvent()
        
        self.updatePenalties()
        self.updatePenaltyScore()
    }
    
    @objc func onTeamOneViewPressed(_ view: UIView) {
        self.currentTurn = .one
    }

    @objc func onTeamTwoViewPressed(_ view: UIView) {
        self.currentTurn = .two
    }
    
    @objc func onGoalPressed(_ btn: UIButton) {
        self.viewModel.updatePenaltyStatusFor(penaltyState: .success)
//        self.viewModel.updatePenaltyScore(penaltyState: .success)
        self.updatePenalties()
        self.updatePenaltyScore()
    }
    
    @objc func onGoalFailurePressed(_ btn: UIButton) {
        self.viewModel.updatePenaltyStatusFor(penaltyState: .failure)
        self.updatePenalties()
        self.updatePenaltyScore()
    }
    
}

// MARK: HELPERS

extension ModalPenaltySeriesVC {
    
    func updatePenalties() {
        self.setupTableViewDataSources()
    }
    
    func updatePenaltyScore() {
        self.setupDynamicViews()
    }
    
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
