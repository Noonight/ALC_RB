//
//  NewsTableViewController.swift
//  ALC_RB
//
//  Created by user on 28.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class NewsAnnounceTableViewController: BaseStateTableViewController {
    enum CellIdentifiers {
        static let NEWS = "cell_news_dynamic"
        static let ANNOUNCE = "cell_announce_dynamic"
    }
    enum SegueIdentifiers {
        static let NEWS_DETAIL = "NewsDetailIdentifier"
        static let ANNOUNCE_DETAIL = ""
    }
    
    // MARK: - Oulets
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
    
    // MARK: - Var & Let
    private let presenter = NewsAnnouncePresenter()
    private var tableData = NewsTableData()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPresenter()
        self.setupTableView()
//        self.setupRefreshControl()
        self.setupBaseState()
        self.fetch = self.presenter.fetch
        self.refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Setup
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
//    func setupRefreshControl() {
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//    }
    func setupBaseState() {
        self.setEmptyMessage(message: "Здесь будут отображаться новости и объявления")
    }
    
    // MARK: - Refresh control
//    @objc override func refreshData() {
//        if self.state == .loading { return }
//        if self.refreshControl?.isRefreshing == false {
//            self.setState(state: .loading)
//        }
//        if tableView.isDragging == false
//        {
//            presenter.fetch()
//        }
//    }
    
//    func endRefreshing() {
//        self.tableView.reloadData()
//        self.setState(state: .normal)
//
//        self.refreshControl?.endRefreshing()
//    }
    
//    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
//    {
//        if refreshControl?.isRefreshing == true
//        {
//            refreshData()
//        }
//    }
    override func hasContent() -> Bool {
        return (tableData.news.count != 0 || tableData.announces.count != 0) ? true : false
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == SegueIdentifiers.NEWS_DETAIL,
            let destination = segue.destination as? NewsDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.content = NewsDetailViewController.NewsDetailContent(
                title: tableData.news.news[cellIndex].caption,
                date: (tableData.news.news[cellIndex].updatedAt).convertDate(from: .utc, to: .local),
                content: tableData.news.news[cellIndex].content,
                imagePath: tableData.news.news[cellIndex].img)
        }
    }
}
// MARK: - Extensions

// MARK: - Presenter
extension NewsAnnounceTableViewController: NewsAnnounceView {
    func fetchSuccessful() {
        endRefreshing()
    }
    
    func onFetchNewsSuccess(news: News) {
        tableData.news = news
    }
    
    func onFetchNewsFailure(error: Error) {
        endRefreshing()
        Print.m(error)
    }
    
    func onFetchAnnouncesSuccess(announces: Announce) {
        tableData.announces = announces
    }
    
    func onFetchAnnouncesFailure(error: Error) {
        endRefreshing()
        Print.m(error)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

// MARK: - Table view data source
extension NewsAnnounceTableViewController {
    
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
        
        let cellNews = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.NEWS) as? NewsTableViewCell
        
        let cellAnnounce = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ANNOUNCE) as? AnnouncesTableViewCell
        
        if (indexPath.section == 0) {
            cellNews?.content?.text = tableData.news.news[indexPath.row].caption
            cellNews?.date?.text = (tableData.news.news[indexPath.row].updatedAt).convertDate(from: .utc, to: .local)
            
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















