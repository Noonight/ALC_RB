//
//  RefereeEditLKTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 30.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class RefereeEditMatchesLKTableViewController: BaseStateTableViewController {
    enum CellIdentifiers {
        static let cell = "cell_referee_matches"
    }
    enum Texts {
        static let EDITED_SAVED = "Изменения сохранены"
        static let SAVE_CHANGES_QUESTION = "Сохранить изменения?"
        static let EMPTY = "Empty"
    }
    
    let presenter = RefereeEditMatchesLKPresenter()
    
    var comingPerson: Person?
    var comingReferees: Players?
    var tableModel: [RefereeEditMatchesLKTableViewCell.CellModel] = []
    let userDefaults = UserDefaultsHelper()

//    var refereeFullName: UILabel {
//        let refFullName = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
//        refFullName.textAlignment = .center
//        refFullName.numberOfLines = 2
//        refFullName.backgroundColor = navigationController?.navigationBar.barTintColor ?? UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
//        return refFullName
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        tableView.tableFooterView = UIView()
        setEmptyMessage(message: "Здесь будут отображаться активные или доступные матчи для выбранного судьи")
        
        self.refreshControl = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Print.m(comingPerson)
        if let refId = comingPerson {
//            if comingPerson?.getFullName().count ?? 0 > 2 {
//                refereeFullName.text = comingPerson?.getFullName()
////                tableView.tableHeaderView = refereeFullName
////                let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
////                view.addSubview(refereeFullName)
////                tableView.tableHeaderView = view
//            } else {
//                refereeFullName.text = "Не указано"
////                tableView.tableHeaderView = refereeFullName
////                let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
////                view.addSubview(refereeFullName)
////                tableView.tableHeaderView = view
//            }
            presenter.fetch(refId: refId.id)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cell, for: indexPath) as! RefereeEditMatchesLKTableViewCell
        let model = tableModel[indexPath.row]
        
        cell.comingTargetPerson = comingPerson
        cell.configure(model: model)
        cell.saveBtn.tag = indexPath.row
        cell.saveBtn.addTarget(self, action: #selector(onSaveBtnPressed), for: .touchUpInside)
        
        return cell
    }
    
    @objc func onSaveBtnPressed(_ sender: UIButton) {
//        Print.m(sender.tag)
        showAlert(title: "Сохранить изменения?", message: "", actions:
            [
                UIAlertAction(title: "Отмена", style: .cancel, handler: { alert in
                    self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                }),
                UIAlertAction(title: "Сохранить", style: .destructive, handler: { alert in
                    let editedMatch = EditMatchReferees(id: (self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? RefereeEditMatchesLKTableViewCell)!.cellModel.activeMatch.id, referees: EditMatchReferees.Referees(referees: self.getRefereesArray(tag: sender.tag)))
                    dump(editedMatch)
                    self.presenter.requestEditMatchReferee(
                        token: (self.userDefaults.getAuthorizedUser()?.token)!,
                        editMatchReferees: editedMatch)
                })
                
            ]
        )
    }
    
    func getRefereesArray(tag: Int) -> [EditMatchReferee] {
//        Print.m(tag)
        func getPersonId(_ fullName: String) -> String? {
            return self.comingReferees!.findPersonBy(fullName: fullName)?.id
        }
        func isCorrectTitleOrSwitchIsOn(labelSwitch: LabelSwitchView) -> Bool {
//            Print.m("\(labelSwitch.name) \(labelSwitch.name?.count ?? 0 > 2 ? true : false)")
//            return labelSwitch.name != Texts.EMPTY ? true : false
            if labelSwitch.name?.count ?? 0 > 2 || labelSwitch.isAppointed {
                return true
            }
            return false
//            return labelSwitch.name?.count ?? 0 > 2 ? true : false
        }
        
        var resultArray: [EditMatchReferee] = []
        
        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! RefereeEditMatchesLKTableViewCell
//        Print.m(cell.cellModel)
        
        if isCorrectTitleOrSwitchIsOn(labelSwitch: cell.refereeOneSwitch) {
            if cell.refereeOneSwitch.isAppointed {
                resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee1.rawValue, person: (comingPerson?.id)!))
            } else {
                resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee1.rawValue, person: getPersonId(cell.refereeOneSwitch.name!)!))
            }
//            resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee1.rawValue, person: getPersonId(cell.refereeOneSwitch.name!)!))
        }
        if isCorrectTitleOrSwitchIsOn(labelSwitch: cell.refereeTwoSwitch) {
            if cell.refereeTwoSwitch.isAppointed {
                resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee2.rawValue, person: (comingPerson?.id)!))
            } else {
                resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee2.rawValue, person: getPersonId(cell.refereeTwoSwitch.name!)!))
            }
//            resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee2.rawValue, person: getPersonId(cell.refereeTwoSwitch.name!)!))
        }
        if isCorrectTitleOrSwitchIsOn(labelSwitch: cell.refereeThreeSwitch) {
            if cell.refereeThreeSwitch.isAppointed {
                resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee3.rawValue, person: (comingPerson?.id)!))
            } else {
                resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee3.rawValue, person: getPersonId(cell.refereeThreeSwitch.name!)!))
            }
//            resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee3.rawValue, person: getPersonId(cell.refereeThreeSwitch.name!)!))
        }
        if isCorrectTitleOrSwitchIsOn(labelSwitch: cell.timeKeeperSwitch) {
            if cell.timeKeeperSwitch.isAppointed {
                resultArray.append(EditMatchReferee(type: Referee.RefereeType.timekeeper.rawValue, person: (comingPerson?.id)!))
            } else {
                resultArray.append(EditMatchReferee(type: Referee.RefereeType.timekeeper.rawValue, person: getPersonId(cell.timeKeeperSwitch.name!)!))
            }
//            resultArray.append(EditMatchReferee(type: Referee.RefereeType.timekeeper.rawValue, person: getPersonId(cell.timeKeeperSwitch.name!)!))
        }
        
        return resultArray
    }
}

extension RefereeEditMatchesLKTableViewController: RefereeEditMatchesView {
    func onResponseEditMatchSuccess(soloMatch: SoloMatch) {
        self.setMatchValue(
            id: soloMatch.match!.id,
            match: soloMatch
        )
        showAlert(title: Texts.EDITED_SAVED, message: "") {
//            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onResponseEditMatchMessage(message: SingleLineMessage) {
        self.showAlert(title: "Сообщение", message: message.message)
    }
    
    func onResponseEditMatchFailure(error: Error) {
        self.showRepeatAlert(message: error.localizedDescription, repeat_closure: {
            self.presenter.requestEditMatchReferee(
                token: (self.userDefaults.getAuthorizedUser()?.token)!,
                editMatchReferees: self.presenter.cache!
            )
        })
    }
    
    // edit match for userDefaults value at id match
    func setMatchValue(id: String, match: SoloMatch) {
//        Print.m(match)
        var user = userDefaults.getAuthorizedUser()
//        dump(user?.person)
        
        if user?.person.participationMatches!.contains(where: { pMatch -> Bool in
            return pMatch.id == match.match?.id
        }) ?? false {
//            user?.person.participationMatches.filter({ pMatch -> Bool in
//                return pMatch.id == match.match?.id
//            }).first
            user?.person.participationMatches!.removeAll(where: { pMatch -> Bool in
                return pMatch.id == match.match?.id
            })
            if match.match?.referees.count ?? 0 > 0 {
                user?.person.participationMatches!.append(match.match!)
            }
//            for i in 0..<user!.person.participationMatches.count {
//                if user?.person.participationMatches[i].id == match.match?.id {
//                    user?.person.participationMatches[i] = match.match!
//                }
//            }
        } else {
            user?.person.participationMatches!.append(match.match!)
        }
        userDefaults.setAuthorizedUser(user: user!)
//        dump(userDefaults.getAuthorizedUser()?.person)
    }
    
    func onFetchModelSuccess(dataModel: [RefereeEditMatchesLKTableViewCell.CellModel]) {
        if dataModel.count > 0 {
            tableModel = dataModel
            tableView.reloadData()
            setState(state: .normal)
        } else {
            setState(state: .empty)
        }
    }
    
    func onFetchModelMessage(message: SingleLineMessage) {
        self.showAlert(message: message.message)
    }
    
    func onFetchModelFailure(error: Error) {
        Print.m(error)
        showRepeatAlert(message: error.localizedDescription) {
            if let refId = self.comingPerson {
                self.presenter.fetch(refId: refId.id)
            }
        }
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
