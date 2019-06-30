//
//  EditScheduleLKViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ActionSheetPicker_3_0

class EditScheduleLKViewController: BaseStateViewController {
    private enum Texts {
        static let NO_REF = "Не назначен"
        static let REFEREES = "Рефери"
        static let NO_REF_FIO = "ФИО не указано"
        static let EDITED_SAVED = "Изменения сохранены"
    }
    private enum Colors {
        static let NO_REF = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)
        static let YES_REF = #colorLiteral(red: 0.07843137255, green: 0.5568627451, blue: 1, alpha: 1)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainRefShowProtocol_btn: UIBarButtonItem!
    @IBOutlet weak var save_btn: UIBarButtonItem!
    @IBOutlet weak var referee1_btn: UIButton!
    @IBOutlet weak var referee2_btn: UIButton!
    @IBOutlet weak var referee3_btn: UIButton!
    @IBOutlet weak var timekeeper_btn: UIButton!
    
    var viewModel: EditScheduleViewModel? = EditScheduleViewModel(dataManager: ApiRequests())
    private let disposeBag = DisposeBag()
    private let userDefaults = UserDefaultsHelper()
    
    var filteredRefereesWithFullName: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.keyboardDismissMode = .interactive
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        filteredRefereesWithFullName = viewModel?.comingReferees.value.people.filter({ person -> Bool in
            return person.getFullName().count > 2
        }).map({ person -> String in
            return person.getFullName()
        })
        
        mainRefShowProtocol_btn.image = mainRefShowProtocol_btn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
        save_btn.image = save_btn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
    }
    
    deinit {
        self.viewModel = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        clearUI()
    }
    
    // MARK: - SETUP UI
    
    func setupUI() {
        clearUI()
        setupReferee()
        setupShowProtocolBtn()
    }
    
    func clearUI() {
        referee1_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
        referee2_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
        referee3_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
        timekeeper_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
    }
    
    func setupShowProtocolBtn() {
        viewModel!.comingCellModel.value.activeMatch.played ? (mainRefShowProtocol_btn.isEnabled = false) : (mainRefShowProtocol_btn.isEnabled = true)
    }
    
    func setupReferee() {
        for ref in viewModel!.comingCellModel.value.activeMatch.referees {
            let refPerson = viewModel?.comingReferees.value.people.filter({ person -> Bool in
                return person.id == ref.person
            }).first
            switch ref.getRefereeType() {
            case .referee1:
                self.referee1_btn.setTitle(refPerson?.getFullName(), for: .normal)
                self.referee1_btn.setTitleColor(Colors.YES_REF, for: .normal)
            case .referee2:
                self.referee2_btn.setTitle(refPerson?.getFullName(), for: .normal)
                self.referee2_btn.setTitleColor(Colors.YES_REF, for: .normal)
            case .referee3:
                self.referee3_btn.setTitle(refPerson?.getFullName(), for: .normal)
                self.referee3_btn.setTitleColor(Colors.YES_REF, for: .normal)
            case .timekeeper:
                self.timekeeper_btn.setTitle(refPerson?.getFullName(), for: .normal)
                self.timekeeper_btn.setTitleColor(Colors.YES_REF, for: .normal)
            case .invalid:
                showRepeatAlert(message: "Не удалось настроить интерфейс") {
                    self.setupUI()
                }
            }
        }
    }
    
    func setupBindings() {
        
        viewModel!.error
            .observeOn(MainScheduler.instance)
            .subscribe { (error) in
                self.setState(state: .error(message: error.element?.localizedDescription ?? "Ошибка"))
            }
            .disposed(by: disposeBag)
        
        viewModel!.refreshing
            .subscribe { (refreshing) in
                refreshing.element ?? false ? self.setState(state: .loading) : self.setState(state: .normal)
            }
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func onReferee1BtnPressed(_ sender: UIButton) {
        showRefereesPicker(sender: sender)
    }
    
    @IBAction func onReferee2BtnPressed(_ sender: UIButton) {
        showRefereesPicker(sender: sender)
    }
    
    @IBAction func onReferee3BtnPressed(_ sender: UIButton) {
        showRefereesPicker(sender: sender)
    }
    
    @IBAction func onTimekeeperBtnPressed(_ sender: UIButton) {
        showRefereesPicker(sender: sender)
    }
    
    @IBAction func onMainRefShowProtocolBtnPressed(_ sender: UIBarButtonItem) {
        
    }
    
    // dictionary {person, type} of referee
    func getRefereesArray() -> [EditMatchReferee] {
        func getPersonId(_ fullName: String) -> String? {
            return self.viewModel?.comingReferees.value.findPersonBy(fullName: fullName)?.id
        }
        func isCorrectTitle(btn: UIButton) -> Bool {
            return btn.title(for: .normal) != Texts.NO_REF ? true : false
        }
        
        var resultArray: [EditMatchReferee] = []
        
        if isCorrectTitle(btn: referee1_btn) {
            resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee1.rawValue, person: getPersonId(referee1_btn.title(for: .normal)!)!))
        }
        if isCorrectTitle(btn: referee2_btn) {
            resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee2.rawValue, person: getPersonId(referee2_btn.title(for: .normal)!)!))
        }
        if isCorrectTitle(btn: referee3_btn) {
            resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee3.rawValue, person: getPersonId(referee3_btn.title(for: .normal)!)!))
        }
        if isCorrectTitle(btn: timekeeper_btn) {
            resultArray.append(EditMatchReferee(type: Referee.RefereeType.timekeeper.rawValue, person: getPersonId(timekeeper_btn.title(for: .normal)!)!))
        }
        return resultArray
    }
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        viewModel?.editMatchReferees(
            token: (userDefaults.getAuthorizedUser()?.token)!,
            editMatchReferees: EditMatchReferees(
                id: (viewModel?.comingCellModel.value.activeMatch.id)!,
                referees: EditMatchReferees.Referees(referees: getRefereesArray())
            ),
            success: { soloMatch in
                self.onResponseSuccess(soloMatch: soloMatch)
            },
            message_single: { message in
                self.onResponseMessage(message: message)
            },
            failure: { error in
                self.onResponseFailure(error: error)
            }
        )
    }
    
    // MARK: - Edit Match Response
    func onResponseSuccess(soloMatch: SoloMatch) {
        self.setMatchValue(
            id: soloMatch.match!.id,
            match: soloMatch
        )
//        showAlert(title: Texts.EDITED_SAVED, message: "", escaping: )
        showAlert(title: Texts.EDITED_SAVED, message: "") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onResponseMessage(message: SingleLineMessage) {
        self.showAlert(title: "Сообщение", message: message.message)
    }
    
    func onResponseFailure(error: Error) {
        self.showRepeatAlert(message: error.localizedDescription, repeat_closure: {
            self.viewModel?.editMatchReferees(
                token: self.userDefaults.getAuthorizedUser()!.token,
                editMatchReferees: self.viewModel!.cache!,
                success: { soloMatch in
                    self.onResponseSuccess(soloMatch: soloMatch)
                },
                message_single: { message in
                    self.onResponseMessage(message: message)
                },
                failure: { error in
                    self.onResponseFailure(error: error)
                }
            )
        })
    }
    
    // edit match for userDefaults value at id match
    func setMatchValue(id: String, match: SoloMatch) {
        var user = userDefaults.getAuthorizedUser()
        
        for i in 0..<user!.person.participationMatches.count {
            if user?.person.participationMatches[i].id == id {
                user?.person.participationMatches[i] = match.match!
            }
        }
        userDefaults.setAuthorizedUser(user: user!)
    }
    
    func showRefereesPicker(sender: UIButton) {
        
        let acp = ActionSheetStringPicker(title: "", rows: filteredRefereesWithFullName, initialSelection: 0, doneBlock: { (picker, index, value) in
            sender.setTitleAndColorWith(title: (self.viewModel?.comingReferees.value.findPersonBy(fullName: value as! String)?.getFullName())!, color: Colors.YES_REF)
        }, cancel: { (picker) in
            
        }, origin: sender)
        
        acp?.addCustomButton(withTitle: "Снять", actionBlock: {
            sender.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
        })
        acp?.show()
        
    }
}
