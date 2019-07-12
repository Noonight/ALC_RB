//
//  NewsTableViewController.swift
//  ALC_RB
//
//  Created by user on 28.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class NewsAnnounceTableViewController: UITableViewController {

    @IBOutlet var noNewsView: UIView!
    @IBOutlet var noAnnounceView: UIView!
    
    struct NewsTableData {
        var news: News = News()
        var announces: Announce = Announce()
        
        let header = [
            "НОВОСТИ", "ОБЪЯВЛЕНИЯ"
        ]
        
        let footer = [
            "ВСЕ НОВОСТИ", "ВСЕ ОБЪЯВЛЕНИЯ"
        ]
        
        let countSections = 2
        private let countItemsOfSection = 3
        
        func getCountItemOfSection(_ section: Int) -> Int {
            if (section == 0) {
                if (news.count < countItemsOfSection) {
                    return news.news.count
                }
                return countItemsOfSection
            }
            if (section == 1) {
                if (announces.count < countItemsOfSection) {
                    return announces.announces.count
                }
                return countItemsOfSection
            }
            return 0
        }
    }
    
    let cellNews = "cell_news_dynamic"
    let cellAnnounce = "cell_announce_dynamic"
    
    private let presenter = NewsAnnouncePresenter()
    let refreshControll = UIRefreshControl()
    
    var tableData = NewsTableData()
    
    let newsDetailIdentifier = "NewsDetail"
    let newsDetailSegueIdentifier = "NewsDetailIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        fetch()
        tableView.tableFooterView = UIView()
        tableView.refreshControl = self.refreshControll
        
        self.refreshControll.addTarget(self, action: #selector(fetch), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
    }
    
    @objc func fetch() {
        if !tableView.isDragging
        {
            let group = DispatchGroup()
            group.enter()
            presenter.getFewNews() {
                group.leave()
            }
            group.enter()
            presenter.getFewAnnounces() {
                group.leave()
            }
            group.notify(queue: .main) {
                self.endRefreshing()
            }
        }
    }
    
    // MARK: - Helpers
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == newsDetailSegueIdentifier,
            let destination = segue.destination as? NewsDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.content = NewsDetailViewController.NewsDetailContent(
                title: tableData.news.news[cellIndex].caption,
                date: (tableData.news.news[cellIndex].updatedAt).UTCToLocal(from: .utc, to: .local),
                content: tableData.news.news[cellIndex].content,
                imagePath: tableData.news.news[cellIndex].img)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.countSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.getCountItemOfSection(section)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData.header[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellNews = tableView.dequeueReusableCell(withIdentifier: self.cellNews) as? NewsTableViewCell
        
        let cellAnnounce = tableView.dequeueReusableCell(withIdentifier: self.cellAnnounce) as? AnnouncesTableViewCell
        
        if (indexPath.section == 0) {
            cellNews?.content?.text = tableData.news.news[indexPath.row].caption
            cellNews?.date?.text = (tableData.news.news[indexPath.row].updatedAt).UTCToLocal(from: .utc, to: .local)
            
            return cellNews!
        }
        if (indexPath.section == 1) {
            cellAnnounce?.content?.text = tableData.announces.announces[indexPath.row].content
            
            return cellAnnounce!
        }
        
        return NoSectionCellTableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        if (section == 0) {
            let footerBtn = FooterBtn.instanceBtn(id: .news, title: tableData.footer[section], viewContainer: tableView)
            footerBtn.addTarget(self, action: #selector(onFooterBtnPressed), for: .touchUpInside)
            return footerBtn
        }
        if (section == 1) {
            let footerBtn = FooterBtn.instanceBtn(id: .announces, title: tableData.footer[section], viewContainer: tableView)
            footerBtn.addTarget(self, action: #selector(onFooterBtnPressed), for: .touchUpInside)
            return footerBtn
        }
        
        return UIView()
    }
    
    // MARK: - footer action
    @objc func onFooterBtnPressed(_ sender: FooterBtn) {
        if (sender.btnType == .news) {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

            let viewController = storyboard.instantiateViewController(withIdentifier: "NewsAllTableViewController") as! NewsAllTableViewController

            viewController.tableData = tableData.news

            navigationController?.pushViewController(viewController, animated: true)
        } else if (sender.btnType == .announces) {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let viewController = storyboard.instantiateViewController(withIdentifier: "AnnounceAllTableViewController") as! AnnounceAllTableViewController
            
            viewController.tableData = tableData.announces
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension NewsAnnounceTableViewController: NewsAnnounceView {
    func onFetchNewsSuccess(news: News) {
        tableData.news = news
        self.tableView.reloadData()
    }
    
    func onFetchNewsFailure(error: Error) {
        Print.m(error)
    }
    
    func onFetchAnnouncesSuccess(announces: Announce) {
        tableData.announces = announces
        self.tableView.reloadData()
    }
    
    func onFetchAnnouncesFailure(error: Error) {
        Print.m(error)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

class FooterBtn: UIButton {
    
    enum BtnType: Int {
        case news = 001
        case announces = 002
    }
    
    struct DefaultParams {
        static let x: Int = 0
        static let y: Int = 0
        static let height: Int = 50// width from view.frame.width
        static let titleColor: UIColor = .black
        static let backgroundColor: UIColor = .white
    }
    
    var btnType: BtnType?
    var viewContainer: UIView?
    
    init(id: BtnType, title: String, viewContainer: UIView/*, actionTouchUpInside: @escaping () -> ()*/) {
        self.btnType = id
        self.viewContainer = viewContainer
        super.init(frame: CGRect(x: DefaultParams.x,
                                 y: DefaultParams.y,
                                 width: Int(viewContainer.frame.width),
                                 height: DefaultParams.height))
        backgroundColor = DefaultParams.backgroundColor
        setTitle(title, for: .normal)
        setTitleColor(DefaultParams.titleColor, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getInstance() -> FooterBtn {
        return self
    }
    
    static func instanceBtn(id: BtnType, title: String, viewContainer: UIView/*, actionTouchUpInside: () -> ()*/) -> FooterBtn {
        return FooterBtn(id: id, title: title, viewContainer: viewContainer).getInstance()
    }
}















