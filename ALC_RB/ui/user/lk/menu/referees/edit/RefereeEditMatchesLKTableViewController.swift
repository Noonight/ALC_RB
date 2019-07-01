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
    
    var comingRefId: String?
    var tableModel: [RefereeEditMatchesLKTableViewCell.CellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        tableView.tableFooterView = UIView()
        setEmptyMessage(message: "Здесь будут отображаться текущие матчи")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let refId = comingRefId {
            presenter.fetch(refId: refId)
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

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
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
            if let refId = self.comingRefId {
                self.presenter.fetch(refId: refId)
            }
        }
//        setState(state: .error(message: error.localizedDescription))
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
