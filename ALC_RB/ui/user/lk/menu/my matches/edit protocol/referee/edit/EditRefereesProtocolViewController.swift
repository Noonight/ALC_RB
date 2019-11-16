//
//  EditRefereesProtocolViewController.swift
//  ALC_RB
//
//  Created by ayur on 05.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ActionSheetPicker_3_0

class EditRefereesProtocolViewController: BaseStateViewController {
    private enum Texts {
        static let NO_REF = "Не назначен"
        static let REFEREES = "Рефери"
        static let NO_REF_FIO = "ФИО не указано"
        static let EDITED_SAVED = "Изменения сохранены"
        static let SAVE_EDITED_Q = "Сохранить изменения?"
        static let ALERT_MESSAGE_NOTHING_MORE = "Изменения будут сохранены сразу, дополнительного подтверждения протокола не требуется"
    }
    private enum Colors {
        static let NO_REF = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)
        static let YES_REF = #colorLiteral(red: 0.07843137255, green: 0.5568627451, blue: 1, alpha: 1)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContainer: UIView!
    @IBOutlet weak var referee1_btn: UIButton!
    @IBOutlet weak var referee2_btn: UIButton!
    @IBOutlet weak var timekeeper_btn: UIButton!
    @IBOutlet weak var inspector_btn: UIButton!
    @IBOutlet weak var referee3Label: UILabel!
    
    @IBOutlet weak var save_btn: UIBarButtonItem!
    
    var viewModel: EditRefereesProtocolViewModel? = EditRefereesProtocolViewModel(dataManager: ApiRequests(), personApi: PersonApi())
    private let disposeBag = DisposeBag()
    private let userDefaults = UserDefaultsHelper()
    
    var filteredRefereesWithFullName: [String]?
    
    // MARK: - MODEL CONTROLLERS
    
    var refereesController: ProtocolRefereesController!
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
        scrollView.keyboardDismissMode = .interactive
        
        self.viewModel?.fetchReferees {
            self.configureFilteredReferees()
            self.setupUI()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
//        filteredRefereesWithFullName = viewModel?.comingReferees.value.people.filter({ person -> Bool in
        configureFilteredReferees()
        
        save_btn.image = save_btn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
    }
    
    deinit {
        self.viewModel = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        clearUI()
    }
    
    // MARK: - Helpers
    
    func configureFilteredReferees() {
        filteredRefereesWithFullName = viewModel?.referees.value.people.filter({ person -> Bool in
            return person.getFullName().count > 2
        }).map({ person -> String in
            return person.getFullName()
        })
    }
    
    // MARK: - SETUP UI
    
    func setupUI() {
        clearUI()
        setupReferee()
    }
    
    func clearUI() {
        inspector_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
        referee1_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
        referee2_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
        timekeeper_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
    }
    
    func setupReferee() {
//        for ref in viewModel!.comingCellModel.value.activeMatch.referees {
//        for ref in viewModel!.comingMatch.referees {
        for ref in refereesController.referees {
//            let refPerson = viewModel?.comingReferees.value.people.filter({ person -> Bool in
            let refPerson = viewModel?.referees.value.people.filter({ person -> Bool in
                return person.id == ref.person
            }).first
            switch ref.type! {
            case .firstReferee:
                self.referee1_btn.setTitle(refPerson?.getFullName(), for: .normal)
                self.referee1_btn.setTitleColor(Colors.YES_REF, for: .normal)
            case .secondReferee:
                self.referee2_btn.setTitle(refPerson?.getFullName(), for: .normal)
                self.referee2_btn.setTitleColor(Colors.YES_REF, for: .normal)
            case .thirdReferee:
                referee3Label.text = refPerson?.getFullName()
            case .timekeeper:
                self.timekeeper_btn.setTitle(refPerson?.getFullName(), for: .normal)
                self.timekeeper_btn.setTitleColor(Colors.YES_REF, for: .normal)
            }
//            switch ref.convertToReferee().getRefereeType() {
//            case .inspector:
//                self.inspector_btn.setTitle(refPerson?.getFullName(), for: .normal)
//                self.inspector_btn.setTitleColor(Colors.YES_REF, for: .normal)
//            case .referee1:
//
//            case .referee2:
//
//            // ### referee 3 tmp
//            case .referee3:
////                Print.m("referee3 \(refPerson)")
//
////                referee3Label.textColor =
//            case .timekeeper:
//
//            case .invalid:
//                showRepeatAlert(message: "Не удалось настроить интерфейс") {
//                    self.setupUI()
//                }
//            }
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
        
        viewModel!.message
            .asDriver(onErrorJustReturn: SingleLineMessage(message: "Ошибка драйвера"))
            .drive(self.rx.message)
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func onInspectorBtnPressed(_ sender: UIButton) {
        showRefereesPicker(sender: sender)
    }
    
    @IBAction func onReferee1BtnPressed(_ sender: UIButton) {
        showRefereesPicker(sender: sender)
    }
    
    @IBAction func onReferee2BtnPressed(_ sender: UIButton) {
        showRefereesPicker(sender: sender)
    }
    
    @IBAction func onTimeKeeperBtnPressed(_ sender: UIButton) {
        showRefereesPicker(sender: sender)
    }
    
    // dictionary {person, type} of referee
    func getRefereesArray() -> [EditMatchReferee] {
        func getPersonId(_ fullName: String) -> String? {
            return self.viewModel?.referees.value.findPersonBy(fullName: fullName)?.id
//            return self.viewModel?.comingReferees.value.findPersonBy(fullName: fullName)?.id
        }
        func isCorrectTitle(btn: UIButton) -> Bool {
            return btn.title(for: .normal) != Texts.NO_REF ? true : false
        }
        
        var resultArray: [EditMatchReferee] = []
        
        if isCorrectTitle(btn: inspector_btn) {
//            resultArray.append(EditMatchReferee(type: Referee.rType.inspector.rawValue, person: getPersonId(inspector_btn.title(for: .normal)!)!))
        }
        if isCorrectTitle(btn: referee1_btn) {
            resultArray.append(EditMatchReferee(type: Referee.rType.firstReferee.rawValue, person: getPersonId(referee1_btn.title(for: .normal)!)!))
        }
        if isCorrectTitle(btn: referee2_btn) {
            resultArray.append(EditMatchReferee(type: Referee.rType.secondReferee.rawValue, person: getPersonId(referee2_btn.title(for: .normal)!)!))
        }
//        if isCorrectTitle(btn: referee3_btn) {
//            resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee3.rawValue, person: getPersonId(referee3_btn.title(for: .normal)!)!))
//        }
        if isCorrectTitle(btn: timekeeper_btn) {
            resultArray.append(EditMatchReferee(type: Referee.rType.timekeeper.rawValue, person: getPersonId(timekeeper_btn.title(for: .normal)!)!))
        }
        
        // add referee - 3 { by default }
        resultArray.append(EditMatchReferee(type: Referee.rType.thirdReferee.rawValue, person: (userDefaults.getAuthorizedUser()?.person.id)!))
        
        return resultArray
    }
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        showAlertOkCancel(title: Texts.SAVE_EDITED_Q, message: Texts.ALERT_MESSAGE_NOTHING_MORE, ok: {
            self.viewModel?.editMatchReferees(
                token: (self.userDefaults.getAuthorizedUser()?.token)!,
                editMatchReferees: EditMatchReferees(
                    //                id: (viewModel?.comingCellModel.value.activeMatch.id)!,
                    id: (self.viewModel?.comingMatch.id)!,
                    referees: EditMatchReferees.Referees(referees: self.getRefereesArray())
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
        }) {
            self.setupUI()
        }
        
    }
    
    // MARK: - Edit Match Response
    func onResponseSuccess(soloMatch: Match) {
        self.setMatchValue(
            id: soloMatch.id,
            match: soloMatch
        )
        
        self.refereesController.referees = soloMatch.referees ?? []
        //        showAlert(title: Texts.EDITED_SAVED, message: "", escaping: )
        showAlert(title: Texts.EDITED_SAVED, message: "") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onResponseMessage(message: SingleLineMessage) {
        self.showAlert(title: "Сообщение", message: message.message)
    }
    
    func onResponseFailure(error: Error) {
        Print.m(error)
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
    func setMatchValue(id: String, match: Match) {
        let user = userDefaults.getAuthorizedUser()
        
        // DEPRECATED: person participation match
//        if user?.person.participationMatches!.contains(where: { pMatch -> Bool in
//            return pMatch.isEqual({ $0.id == match.match?.id })
////            switch pMatch {
////            case .id(let id):
////                return id == match.match?.id
////            case .object(let obj):
////                return obj.id == match.match?.id
////            }
////            return pMatch.id == match.match?.id
//        }) ?? false {
//            user?.person.participationMatches!.removeAll(where: { pMatch -> Bool in
//                return pMatch.isEqual({ $0.id == match.match?.id })
////                switch pMatch {
////                case .id(let id):
////                    return id == match.match?.id
////                case .object(let obj):
////                    return obj.id == match.match?.id
////                }
////                return pMatch.id == match.match?.id
//            })
//            if match.match?.referees.count ?? 0 > 0 {
////                user?.person.participationMatches!.append(match.match!)
//               user?.person.participationMatches?.append(IdRefObjectWrapper(match.match!))
//            }
//        } else {
////            user?.person.participationMatches!.append(match.match!)
//            user?.person.participationMatches?.append(IdRefObjectWrapper(match.match!))
//        }
        userDefaults.setAuthorizedUser(user: user!)
    }
    
    func showRefereesPicker(sender: UIButton) {
        
        let acp = ActionSheetStringPicker(title: "", rows: filteredRefereesWithFullName, initialSelection: 0, doneBlock: { (picker, index, value) in
//            sender.setTitleAndColorWith(title: (self.viewModel?.comingReferees.value.findPersonBy(fullName: value as! String)?.getFullName())!, color: Colors.YES_REF)
            sender.setTitleAndColorWith(title: (self.viewModel?.referees.value.findPersonBy(fullName: value as! String)?.getFullName())!, color: Colors.YES_REF)
        }, cancel: { (picker) in
            
        }, origin: sender)
        
        acp?.addCustomButton(withTitle: "Снять", actionBlock: {
            sender.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
        })
        acp?.show()
        
    }
}
