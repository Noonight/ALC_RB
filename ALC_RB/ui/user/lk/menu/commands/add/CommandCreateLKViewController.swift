//
//  CommandCreateLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 25.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CommandCreateLKViewController: BaseStateViewController, UITextFieldDelegate {

    struct ViewModel {
//        var tournaments = Tournaments()
        var tournaments: [League] = []
//        var clubs = Clubs()
        
        func isEmpty() -> Bool {
            return tournaments.count < 1 //&& clubs.clubs.count == 0
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
    
    var viewModel = ViewModel()
    
    let fieldsCantBeEmpty = "Заполните все поля."
//    let teamCreatedMessage = "Команда создана.\n Название: "
    let chooseTournament = "Выберите турнир."
    
    let userDefaults = UserDefaultsHelper()
    
    var tournamentItem: League?
    var clubItem: Club?
    
    var tmpTournamentTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
//        presenter.getTournaments()
//        presenter.getClubs()
        
        nameTextField.delegate = self
        
//        tournamentPickerHelper.setRows(rows: <#T##[League]#>)
        tournamentPickerHelper.setSelectRowPickerHelper(selectRowProtocol: self)
//        clubPickerHelper.setSelectRowPickerHelper(selectRowProtocol: self)
        
        tournamentPickerView.delegate = tournamentPickerHelper
        tournamentPickerView.dataSource = tournamentPickerHelper
        
//        clubPickerView.delegate = clubPickerHelper
//        clubPickerView.dataSource = clubPickerHelper
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        saveBtn.image = saveBtn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
        
        if viewModel.tournaments.count < 1 {
            presenter.getTournaments()
            setState(state: .loading)
        }
        
//        updateUI()
    }
    
    func updateUI() {
        if viewModel.isEmpty() {
//            setState(state: .loading)
            showAlert(title: "Предупреждение", message: "Активных турниров нет.")
        } else {
        setState(state: .normal)
        self.tournamentPickerHelper.setRows(rows: viewModel.tournaments)
        self.tournamentPickerView.reloadAllComponents()
        // select row in middle
//        self.tournamentPickerView.selectRow(tournamentPickerView.numberOfRows(inComponent: 0) / 2, inComponent: 0, animated: true)
//            tournamentPickerView.layoutIfNeeded()
//            clubPickerHelper.setRows(rows: viewModel.clubs.clubs)
        }
    }
    
    // MARK: - Toolbar actions
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
//        if !nameTextField.isEmpty() && tournamentItem != nil && clubItem != nil {
        if !nameTextField.isEmpty() && tournamentItem != nil {
            presenter.createTeam(token: userDefaults.getAuthorizedUser()?.token ?? "", teamInfo: CreateTeamInfo(
                name: nameTextField.text!,
                _id: (tournamentItem?.id)!,
//                club: (clubItem?.id)!,
                club: (userDefaults.getAuthorizedUser()?.person.club)!,
                creator: (userDefaults.getAuthorizedUser()?.person.id)!)
            )
//        } else if !nameTextField.isEmpty() && tournamentItem == nil || clubItem == nil {
        } else if !nameTextField.isEmpty() && tournamentItem == nil {
            showToast(message: "\(chooseTournament)")
        } else {
            showToast(message: "\(fieldsCantBeEmpty)")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func filterPendingTournaments(tournaments: Tournaments) -> [League] {
        return tournaments.leagues.filter({ league -> Bool in
            return league.getStatus() == League.Statuses.pending
        })
    }
    
}

extension CommandCreateLKViewController : SelectRowTournamentPickerHelper {
    func onSelectRow(row: Int, element: League) {
        tournamentItem = element
        tmpTournamentTitle = "\(tournamentItem?.tourney ?? "") \(tournamentItem?.name ?? "")"
//        tournamentBtn.setTitle(element.name, for: .normal)
    }
}

extension CommandCreateLKViewController : SelectRowClubPickerHelper {
    func onSelectRow(row: Int, element: Club) {
        clubItem = element
        clubBtn.setTitle(element.name, for: .normal)
    }
}

extension CommandCreateLKViewController : CommandCreateLKView {
    func onCreateTeamSuccess(team: SoloTeam) {
//        showToast(message: "\(teamCreatedMessage)\(team.team.name)", seconds: 5)
        if let tournamentTitle = self.tmpTournamentTitle {
            showAlert(title: "Успех", message: "Команда '\(team.team.name)' заявлена на турнир '\(tournamentTitle)'")
        } else {
            showAlert(title: "Успех", message: "Команда '\(team.team.name)' создана")
        }
        
        var tmpUser = userDefaults.getAuthorizedUser()
        tmpUser?.person.participation.append(Participation(league: presenter.createTeamCache!._id, id: "", team: team.team.id))
        userDefaults.setAuthorizedUser(user: tmpUser!)
//        dismiss(animated: true) {
//            Print.m("Dismiss complete")
//        }
    }
    
    func onCreateTeamFailure(error: Error) {
        Print.m(error)
        showRepeatAlert(message: error.localizedDescription) {
            self.presenter.createTeam(token: self.userDefaults.getAuthorizedUser()!.token, teamInfo: self.presenter.createTeamCache!)
        }
//        showToast(message: "Ошибка! Что-то пошло не так.")
    }
    
    func onCreateTeamMessage(message: SingleLineMessage) {
        Print.m(message)
        showAlert(title: "Сообщение", message: message.message)
//        showToast(message: message.message, seconds: 5)
    }
    
    func onGetTournamentsSuccess(tournaments: Tournaments) {
//        viewModel.tournaments = tournaments
        viewModel.tournaments = filterPendingTournaments(tournaments: tournaments)
//        setState(state: .normal)
//        dump(viewModel.tournaments)
        updateUI()
    }
    
    func onGetTournamentsFailure(error: Error) {
        Print.m(error)
    }
    
    func onGetClubsSuccess(clubs: Clubs) {
//        viewModel.clubs = clubs
    }
    
    func onGetClubsFailure(error: Error) {
        Print.m(error)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
