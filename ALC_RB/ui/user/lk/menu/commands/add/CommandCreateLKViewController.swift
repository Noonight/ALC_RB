//
//  CommandCreateLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 25.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CommandCreateLKViewController: BaseStateViewController {

    struct ViewModel {
        var tournaments = Tournaments()
        var clubs = Clubs()
        
        func isEmpty() -> Bool {
            return tournaments.count == 0 && clubs.clubs.count == 0
        }
    }
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var tournamentBtn: UIButton!
    @IBOutlet weak var tournamentPickerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var clubBtn: UIButton!
    @IBOutlet weak var clubPickerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tournamentPickerView: UIPickerView!
    @IBOutlet weak var clubPickerView: UIPickerView!
    
    let presenter = CommandCreateLKPresenter()
    
    let tournamentPickerHelper = TournamentPickerHelper()
    let clubPickerHelper = ClubPickerHelper()
    
    var viewModel = ViewModel() {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        presenter.getTournaments()
        presenter.getClubs()
        
//        tournamentPickerHelper.setRows(rows: <#T##[League]#>)
        tournamentPickerHelper.setSelectRowPickerHelper(selectRowProtocol: self)
        
        tournamentPickerView.delegate = tournamentPickerHelper
        tournamentPickerView.dataSource = tournamentPickerHelper
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        saveBtn.image = saveBtn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
    }
    
    func updateUI() {
        if viewModel.isEmpty() {
            setState(state: .loading)
        } else {
            tournamentPickerHelper.setRows(rows: viewModel.tournaments.leagues)
            clubPickerHelper.setRows(rows: viewModel.clubs.clubs)
        }
    }

    // MARK: - Tournament picker view
    
    @IBAction func onTournamentBtnPressed(_ sender: UIButton) {
        if tournamentPickerView.isHidden {
            showTournamentPicker()
        } else {
            hideTournamentPicker()
        }
    }
    
    func showTournamentPicker() {
        tournamentPickerView.isHidden = false
        self.view.layoutIfNeeded()
        tournamentPickerView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5) {
            self.tournamentPickerViewHeight.constant = 120
            self.view.layoutIfNeeded()
            self.tournamentPickerView.layoutIfNeeded()
        }
    }
    
    func hideTournamentPicker() {
        self.view.layoutIfNeeded()
        tournamentPickerView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5) {
            self.tournamentPickerViewHeight.constant = 0
            self.view.layoutIfNeeded()
            self.tournamentPickerView.layoutIfNeeded()
        }
        tournamentPickerView.isHidden = true
        
    }
    
    // MARK: - Club picker view
    
    @IBAction func onClubBtnPressed(_ sender: UIButton) {
        if clubPickerView.isHidden {
            showClubPicker()
        } else {
            hideClubPicker()
        }
    }
    
    func showClubPicker() {
        clubPickerView.isHidden = false
        self.view.layoutIfNeeded()
        clubPickerView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5) {
            self.clubPickerViewHeight.constant = 120
            self.view.layoutIfNeeded()
            self.clubPickerView.layoutIfNeeded()
        }
    }
    
    func hideClubPicker() {
        self.view.layoutIfNeeded()
        clubPickerView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5) {
            self.clubPickerViewHeight.constant = 0
            self.view.layoutIfNeeded()
            self.clubPickerView.layoutIfNeeded()
        }
        clubPickerView.isHidden = true
    }
    
}

extension CommandCreateLKViewController : SelectRowTournamentPickerHelper {
    func onSelectRow(row: Int, element: League) {
        tournamentBtn.setTitle(element.name, for: .normal)
    }
}

extension CommandCreateLKViewController : CommandCreateLKView {
    func onGetTournamentsSuccess(tournaments: Tournaments) {
        viewModel.tournaments = tournaments
    }
    
    func onGetTournamentsFailure(error: Error) {
        Print.m(error)
    }
    
    func onGetClubsSuccess(clubs: Clubs) {
        viewModel.clubs = clubs
    }
    
    func onGetClubsFailure(error: Error) {
        Print.m(error)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
