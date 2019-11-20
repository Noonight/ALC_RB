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

class TeamCreateLKVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var tourneyBtn: UIButton!
    
    var viewModel: TeamCreateLKViewModel!
    
    var leagueChooser: ChooseTourneyLeagueVC!
    
    private let bag = DisposeBag()
    
    let nameIsEmpty = "Укажите название команды"
    let creatorPhoneIsEmpty = "Укажите номер телефона"
    let leagueIsEmpty = "Выберите лигу"
    
    let userDefaults = UserDefaultsHelper()
    
    var leagueItem: League?
    
//    var teamController: TeamCommandsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupBinds()
        setupChooser()
        
        phoneNumberTextField.delegate = self
        
        tourneyBtn.addTarget(self, action: #selector(tapOnTourney(_:)), for: .touchUpInside)
    }
}

// MARK: - SETUP

extension TeamCreateLKVC {
    
    func setupViewModel() {
        self.viewModel = TeamCreateLKViewModel(teamApi: TeamApi())
    }
    
    func setupChooser() {
        self.leagueChooser = ChooseTourneyLeagueVC()
        self.leagueChooser.callBack = self
    }
    
    func setupBinds() {
        
        self.viewModel
            .message
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.message)
            .disposed(by: bag)
        
        self.viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.loading)
            .disposed(by: bag)
        
        self.viewModel
            .error
            .asDriver(onErrorJustReturn: nil)
            .drive(self.rx.error)
            .disposed(by: bag)
    }
    
}

// MARK: ACTIONS

extension TeamCreateLKVC {
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        if !nameTextField.isEmpty() && leagueItem != nil && !phoneNumberTextField.isEmpty() {
            self.viewModel.request()
//            presenter.createTeam(token: userDefaults.getAuthorizedUser()?.token ?? "", teamInfo: CreateTeamInfo(
//                name: nameTextField.text!,
//                _id: (leagueItem?.id)!,
//                creatorPhone: phoneNumberTextField.text!
//            ))
            return
        }
        if nameTextField.isEmpty() == true {
            showToast(message: "\(leagueIsEmpty)")
        }
        if phoneNumberTextField.isEmpty() == true {
            showToast(message: "\(creatorPhoneIsEmpty)")
        }
        if leagueItem == nil {
            showToast(message: "\(leagueIsEmpty)")
        }
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
    
    @objc func tapOnTourney(_ sender: UIButton) {
        self.presentAsStork(leagueChooser)
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
}

// MARK: - ChooseLeagueResult

extension TeamCreateLKVC: ChooseLeagueResult {
    func complete(league: League) {
        self.tourneyBtn.setTitle(league.name, for: .normal)
        
        self.leagueItem = league
    }
}
