//
//  NewsAllTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 07.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class NewsAllTableViewController: UITableViewController {

    // MARK: - Var & Let
    let cellId = "cell_news_dynamic"
    
    var tableData: News? {
        didSet {
            updateUI()
        }
    }
    
    let newsDetailIdentifier = "NewsDetail"
    let newsDetailSegueIdentifier = "NewsDetailIdentifier"
    
    let mTitle = "Новости"
    
    let presenter = NewsAllPresenter()
    let refreshControll = UIRefreshControl()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPresenter()
        self.title = mTitle
        
        tableView.tableFooterView = UIView()
        
        tableView.refreshControl = self.refreshControll
        
        self.refreshControll.addTarget(self, action: #selector(fetch), for: .valueChanged)
    }

    func updateUI() {
        tableView.reloadData()
    }
    // MARK: - UIRefreshController
    @objc func fetch() {
        if !tableView.isDragging
        {
            presenter.fetchNews() {
                self.endRefreshing()
            }
        }
    }
    
    func endRefreshing() {
        if self.refreshControll.isRefreshing == true {
            self.refreshControll.endRefreshing()
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if refreshControl?.isRefreshing == true
        {
            fetch()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableData?.news.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? NewsTableViewCell

        cell?.content?.text = tableData?.news[indexPath.row].caption
        cell?.date?.text = tableData?.news[indexPath.row].updatedAt.UTCToLocal(from: .utc, to: .local)
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == newsDetailSegueIdentifier,
            let destination = segue.destination as? NewsDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.content = NewsDetailViewController.NewsDetailContent(
                title: tableData!.news[cellIndex].caption,
                date: (tableData!.news[cellIndex].updatedAt).UTCToLocal(from: .utc, to: .local),
                content: tableData!.news[cellIndex].content,
                imagePath: tableData!.news[cellIndex].img)
        }
    }
}

extension NewsAllTableViewController: NewsAllView {
    func fetchNewsSuccessful(news: News) {
        self.tableData = news
    }
    
    func fetchNewsFailure(error: Error) {
        Print.m(error)
        showRepeatAlert(message: error.localizedDescription) {
            self.presenter.fetchNews() { }
        }
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
