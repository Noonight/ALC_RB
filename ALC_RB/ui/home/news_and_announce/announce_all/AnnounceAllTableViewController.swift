//
//  AnnounceAllTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 07.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class AnnounceAllTableViewController: UITableViewController {

    let cellId = "cell_announce_date"
    
    var tableData: Announce? {
        didSet {
            updateUI()
        }
    }
    
    let mTitle = "Объявления"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = mTitle
        
        tableView.tableFooterView = UIView()
    }
    
    func updateUI() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableData?.announces.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? AnnounceDateTableViewCell

        cell?.content.text = tableData?.announces[indexPath.row].content
        cell?.date.text = tableData?.announces[indexPath.row].date.UTCToLocal(from: .utc, to: .local)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
