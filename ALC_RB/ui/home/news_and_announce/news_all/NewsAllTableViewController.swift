//
//  NewsAllTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 07.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import SystemConfiguration

class NewsAllTableViewController: BaseStateTableViewController {
    // MARK: - Static variables
    enum CellIdentifiers {
        static let CELL = "cell_news_dynamic"
    }
    enum SegueIdentifiers {
        static let DETAIL = "NewsDetailIdentifier"
    }
    enum Text {
        static let TITLE = "Новости"
    }
    
    // MARK: - Var & Let
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.raywenderlich.com")
    var tableData: News = News()
    let presenter = NewsAllPresenter()
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPresenter()
        self.prepareView()
        self.prepareTableView()
//        self.prepareTableViewRefreshController()
        self.fetch = self.presenter.fetch
        self.prepareEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setupInitialViewState()
    }
    
    // MARK: - Prepare
    func prepareView() {
        self.title = Text.TITLE
    }
    func prepareTableView() {
        tableView.tableFooterView = UIView()
    }
//    func prepareTableViewRefreshController() {
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//    }
    func prepareEmptyView() {
        self.setEmptyMessage(message: "Здесь будут новости")
    }
    // MARK: - Reachable
    private func checkReachable(){
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if (isNetworkReachable(with: flags))
        {
            print (flags)
            if flags.contains(.isWWAN) {
                self.showAlert(title: "via mobile", message: "Reachable")
                return
            }
            
            self.showAlert(title:"via wifi",message:"Reachable")
        }
        else if (!isNetworkReachable(with: flags)) {
            self.showAlert(title:"Sorry no connection",message: "unreachable")
            print (flags)
            return
        }
    }
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }
    
    // MARK: - UIRefreshController
//    @objc func refreshData() {
////        if lastState == .Loading { return }
////        checkReachable()
////        startLoading()
//        if !tableView.isDragging
//        {
//            presenter.fetchNews { }
//        }
//    }
//    func endRefreshing() {
//        self.tableView.reloadData()
////        self.endLoading(error: nil, completion: nil)
//
//        self.refreshControl?.endRefreshing()
//        if tableData.count == 0 {
//            self.setState(state: .empty)
//        } else {
//            self.setState(state: .normal)
//        }
//    }
//    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
//    {
//        if refreshControl?.isRefreshing == true
//        {
//            refreshData()
//        }
//    }
    override func hasContent() -> Bool {
        if tableData.count != 0 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.news.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CELL, for: indexPath) as? NewsTableViewCell

        cell?.content?.text = tableData.news[indexPath.row].caption
        cell?.date?.text = tableData.news[indexPath.row].updatedAt.convertDate(from: .utc, to: .local)
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == SegueIdentifiers.DETAIL,
            let destination = segue.destination as? NewsDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.content = NewsDetailViewController.NewsDetailContent(
                title: tableData.news[cellIndex].caption,
                date: (tableData.news[cellIndex].updatedAt).convertDate(from: .utc, to: .local),
                content: tableData.news[cellIndex].content,
                imagePath: tableData.news[cellIndex].img)
        }
    }
}
// MARK: - Extensions
// MARK: - Presenter
extension NewsAllTableViewController: NewsAllView {
    func fetchNewsSuccessful(news: News) {
        self.tableData = news
        self.endRefreshing()
    }
    
    func fetchNewsFailure(error: Error) {
        endRefreshing()
        Print.m(error)
        showFailFetchRepeatAlert(message: error.localizedDescription) {
//            self.presenter.fetch()
            self.refreshData()
        }
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
