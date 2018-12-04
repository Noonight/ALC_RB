//
//  TournamentsTableViewController.swift
//  ALC_RB
//
//  Created by user on 27.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class TournamentsTableViewController: UITableViewController {

    //MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    fileprivate func initView() {
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_tournament", for: indexPath) as! TournamentTableViewCell
        cell.img?.image = #imageLiteral(resourceName: "ic_logo2")
        cell.title?.text = "some text"
        cell.date?.text = "10.03.2018 - 10.04.2018"
        cell.commandNum?.text = "???"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
