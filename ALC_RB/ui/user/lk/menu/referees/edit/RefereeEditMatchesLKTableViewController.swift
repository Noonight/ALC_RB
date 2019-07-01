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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
        
        cell.configure(model: model)
        cell.saveBtn.tag = indexPath.row
        cell.saveBtn.addTarget(self, action: #selector(onSaveBtnPressed), for: .touchUpInside)
        
        return cell
    }
    
    @objc func onSaveBtnPressed(_ sender: UIButton) {
        Print.m(sender.tag)
        showAlert(title: "Сохранить изменения?", message: "", actions:
            [
                UIAlertAction(title: "Отмена", style: .cancel, handler: { alert in
                    self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                }),
                UIAlertAction(title: "Сохранить", style: .destructive, handler: { alert in
                    let editedMatch = EditMatchReferees(id: (self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? RefereeEditMatchesLKTableViewCell)!.cellModel.activeMatch.id, referees: EditMatchReferees.Referees(referees: self.getRefereesArray(tag: sender.tag)))
                    self.presenter.requestEditMatchReferee(
                        token: (self.userDefaults.getAuthorizedUser()?.token)!,
                        editMatchReferees: editedMatch)
                })
                
            ]
        )
    }
    
    func getRefereesArray(tag: Int) -> [EditMatchReferee] {
        func getPersonId(_ fullName: String) -> String? {
            return self.comingReferees!.findPersonBy(fullName: fullName)?.id
        }
        func isCorrectTitle(labelSwitch: LabelSwitchView) -> Bool {
            return labelSwitch.name != Texts.EMPTY ? true : false
        }
        
        var resultArray: [EditMatchReferee] = []
        
        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! RefereeEditMatchesLKTableViewCell
        
        if isCorrectTitle(labelSwitch: cell.refereeOneSwitch) {
            resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee1.rawValue, person: getPersonId(cell.refereeOneSwitch.name!)!))
        }
        if isCorrectTitle(labelSwitch: cell.refereeTwoSwitch) {
            resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee1.rawValue, person: getPersonId(cell.refereeTwoSwitch.name!)!))
        }
        if isCorrectTitle(labelSwitch: cell.refereeThreeSwitch) {
            resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee1.rawValue, person: getPersonId(cell.refereeThreeSwitch.name!)!))
        }
        if isCorrectTitle(labelSwitch: cell.timeKeeperSwitch) {
            resultArray.append(EditMatchReferee(type: Referee.RefereeType.referee1.rawValue, person: getPersonId(cell.timeKeeperSwitch.name!)!))
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
        var user = userDefaults.getAuthorizedUser()
        
        for i in 0..<user!.person.participationMatches.count {
            if user?.person.participationMatches[i].id == id {
                user?.person.participationMatches[i] = match.match!
            }
        }
        userDefaults.setAuthorizedUser(user: user!)
    }
    
    func onFetchModelSuccess(dataModel: [RefereeEditMatchesLKTableViewCell.CellModel]) {
        tableModel = dataModel
        tableView.reloadData()
        setState(state: .normal)
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
