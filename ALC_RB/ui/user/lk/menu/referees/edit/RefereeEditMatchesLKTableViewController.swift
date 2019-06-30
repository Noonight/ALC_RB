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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }
    
    var titleSwitch: UITitleLabelSwitch {
        let titleSwitch = UITitleLabelSwitch(frame: CGRect(x: 0, y: 0, width: tableView.frame.width / 2, height: 50))
        return titleSwitch
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.tableHeaderView = titleSwitch
        var btn: UIButton {
            let btn = UIButton(type: .infoDark)
            btn.addTarget(self, action: #selector(setColor), for: .touchUpInside)
            return btn
        }
        tableView.tableFooterView = btn
    }

    @objc func setColor(_ sender: UIButton) {
        titleSwitch.setColor(color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
        Print.m("JUST")
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cell, for: indexPath) as! RefereeEditMatchesLKTableViewCell

        cell.teamOneImage.image = #imageLiteral(resourceName: "ic_scoreboard")
        cell.teamTwoImage.image = #imageLiteral(resourceName: "ic_sign_out2")

        return cell
    }
}

extension RefereeEditMatchesLKTableViewController: RefereeEditMatchesView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
