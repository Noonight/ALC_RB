//
//  AnnounceAllTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 07.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class AnnounceAllTableViewController: BaseStateTableViewController {

    // MARK: - Var & Let
    let cellId = "cell_announce_date"
    
    var tableData: [Announce]? /*{
        didSet {
            if tableData?.count == 0 {
                self.setState(state: .empty)
            } else {
                updateUI()
            }
        }
    }*/
    
    let mTitle = "Объявления"
    
    let presenter = AnnouncesAllPresenter()
    let refreshControll = UIRefreshControl()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPresenter()
        self.title = mTitle
        
        self.fetch = self.presenter.fetch
        
        tableView.tableFooterView = UIView()
//        prepareRefreshControl()
        self.setEmptyMessage(message: "Здесь будут объявления")
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    // MARK: - Prepare
//    func prepareRefreshControl() {
//        tableView.refreshControl = self.refreshControll
//
//        self.refreshControll.addTarget(self, action: #selector(fetch), for: .valueChanged)
//    }
//
//    // MARK: - UIRefreshControll
//    @objc func fetch() {
//        if !tableView.isDragging
//        {
//            presenter.fetchAnnounces() {
//                self.endRefreshing()
//            }
//        }
//    }
//
//    func endRefreshing() {
//        self.setState(state: .normal)
//        if self.refreshControll.isRefreshing == true {
//            self.refreshControll.endRefreshing()
//        }
//    }
    override func hasContent() -> Bool {
        if tableData?.count != 0 {
            return true
        } else {
            return false
        }
    }
    
//    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
//    {
//        if refreshControl?.isRefreshing == true
//        {
//            fetch()
//        }
//    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableData?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? AnnounceDateTableViewCell

        cell?.content.text = tableData?[indexPath.row].content
        cell?.date.text = tableData?[indexPath.row].date.toFormat(DateFormats.local.rawValue)//convertDate(from: .utc, to: .local)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension AnnounceAllTableViewController : AnnouncesAllView {
    func fetchAnnouncesSuccess(announces: [Announce]) {
        self.tableData = announces
        endRefreshing()
    }
    
    func fetchAnnouncesFailure(error: Error) {
        Print.m(error)
        endRefreshing()
        showFailFetchRepeatAlert(message: error.localizedDescription) {
//            self.presenter.fetch()
            self.refreshData()
        }
    }
    
    func initPresenter() {
        self.presenter.attachView(view: self)
    }
}
