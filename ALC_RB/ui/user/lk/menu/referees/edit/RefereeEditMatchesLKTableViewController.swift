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
    
    let presenter = RefereeEditMatchesLKPresenter()
    
    var comingPerson: Person?
    var tableModel: [RefereeEditMatchesLKTableViewCell.CellModel] = []

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
        
//        cell.refereeOneSwitch.frame = CGRect(x: 0, y: 0, width: 500, height: 51)
        
        cell.configure(model: model)

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}

extension RefereeEditMatchesLKTableViewController: RefereeEditMatchesView {
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
//        setState(state: .error(message: error.localizedDescription))
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
