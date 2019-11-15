//
//  CommandCreateLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 25.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CommandCreateLKViewController: BaseStateViewController, UITextFieldDelegate {

    struct ViewModel {
        var tournaments: [League] = []
        
        func isEmpty() -> Bool {
            return tournaments.count < 1 //&& clubs.clubs.count == 0
        }
    }
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var tournamentPickerView: UIPickerView!
    
    let presenter = CommandCreateLKPresenter()
    
    let tournamentPickerHelper = TournamentPickerHelper()
    let clubPickerHelper = ClubPickerHelper()
    
    var viewModel = ViewModel()
    
    let fieldsCantBeEmpty = "Заполните все поля."
    let chooseTournament = "Выберите турнир."
    
    let userDefaults = UserDefaultsHelper()
    
    var tournamentItem: League?
    var clubItem: Club?
    
    var tmpTournamentTitle: String?
    
    // MARK: - model controllers
    var teamController: TeamCommandsController!
    var participationController: ParticipationCommandsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
//        presenter.getTournaments()
//        presenter.getClubs()
        
//        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        
//        tournamentPickerHelper.setRows(rows: <#T##[League]#>)
        tournamentPickerHelper.setSelectRowPickerHelper(selectRowProtocol: self)
//        clubPickerHelper.setSelectRowPickerHelper(selectRowProtocol: self)
        
        tournamentPickerView.delegate = tournamentPickerHelper
        tournamentPickerView.dataSource = tournamentPickerHelper
        
//        clubPickerView.delegate = clubPickerHelper
//        clubPickerView.dataSource = clubPickerHelper
    }
    
    private func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XX-XX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
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
        if !nameTextField.isEmpty() && tournamentItem != nil && !phoneNumberTextField.isEmpty() {
            presenter.createTeam(token: userDefaults.getAuthorizedUser()?.token ?? "", teamInfo: CreateTeamInfo(
                name: nameTextField.text!,
                _id: (tournamentItem?.id)!,
                creatorPhone: phoneNumberTextField.text!//,
//                club: (clubItem?.id)!,
//                club: (userDefaults.getAuthorizedUser()?.person.club)!,
//                creator: (userDefaults.getAuthorizedUser()?.person.id)!)
            ))
//            presenter.createTeamNEW(token: userDefaults.getAuthorizedUser()?.token, teamInfo: <#T##CreateTeamInfo#>)
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
        
    }
    
    func hideTournamentPicker() {
        self.view.layoutIfNeeded()
        tournamentPickerView.layoutIfNeeded()
        
        tournamentPickerView.isHidden = true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func filterPendingTournaments(tournaments: Tournaments) -> [League] {
        return tournaments.leagues.filter({ league -> Bool in
            return league.status == League.Status.pending
//            return league.getStatus() == League.Statuses.pending
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
//        clubBtn.setTitle(element.name, for: .normal)
    }
}

extension CommandCreateLKViewController : CommandCreateLKView {
    func onCreateTeamSuccess(team: SoloTeam) {
        self.teamController.teams.append(team.team)
        
        if let tournamentTitle = self.tmpTournamentTitle {
            showAlert(title: "Успех", message: "Команда '\(team.team.name)' заявлена на турнир '\(tournamentTitle)'") {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            showAlert(title: "Успех", message: "Команда '\(team.team.name)' создана") {
                self.navigationController?.popViewController(animated: true)
            }
        }
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
        updateUI()
    }
    
    func onGetTournamentsFailure(error: Error) {
        Print.m(error)
    }
    
    func onGetClubsSuccess(clubs: [Club]) {
//        viewModel.clubs = clubs
    }
    
    func onGetClubsFailure(error: Error) {
        Print.m(error)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
