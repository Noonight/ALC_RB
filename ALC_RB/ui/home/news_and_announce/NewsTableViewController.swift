//
//  NewsTableViewController.swift
//  ALC_RB
//
//  Created by user on 28.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, MvpView {

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
                    return news.count
                }
                return countItemsOfSection
            }
            if (section == 1) {
                if (announces.count < countItemsOfSection) {
                    return announces.count
                }
                return countItemsOfSection
            }
            return 0
        }
    }
    
    let cellNews = "cell_news_dynamic"
    let cellAnnounce = "cell_announce_dynamic"
    
    private let presenter = NewsFewPresenter()
    
    var tableData = NewsTableData()
    
    let newsDetailIdentifier = "NewsDetail"
    let newsDetailSegueIdentifier = "NewsDetailIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        //tableView.backgroundView = noNewsView
        //navigationController?.navigationItem.title = "title"
        //print(navigationController?.navigationItem.title)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
        presenter.getFewNews()
        presenter.getFewAnnounces()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == newsDetailSegueIdentifier,
            let destination = segue.destination as? NewsDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            print(navigationItem.backBarButtonItem)
            destination.content = NewsDetailViewController.Content(
                title: tableData.news.news[cellIndex].caption,
                date: (tableData.news.news[cellIndex].updatedAt).UTCToLocal(from: .utc, to: .local),
                content: tableData.news.news[cellIndex].content,
                imagePath: tableData.news.news[cellIndex].img)
//            destination.cTitle = tableData.news.news[cellIndex].caption
//            destination.cDate = tableData.news.news[cellIndex].updatedAt
//            destination.cImagePath = tableData.news.news[cellIndex].img
//            destination.cText = tableData.news.news[cellIndex].content
        }
    }
    
    func onGetNewsDataSuccess(news: News) {
        tableData.news = news
        self.tableView.reloadData()
    }
    
    func onGetAnnounceDataSuccess(announces: Announce) {
        tableData.announces = announces
        //try! print(tableData.announces.jsonString())
        self.tableView.reloadData()
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
        
        print("section: \(indexPath.section), row: \(indexPath.row)")
        
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
        //navigationController?.pushViewController(NewsDetailViewController(), animated: true)
        //self.navigationController?.pushViewController(NewsDetailViewController(), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
//        btn.backgroundColor = UIColor.white
//
//        btn.addTarget(self, action: #selector(onBtnPressed), for: .touchUpInside)
//        btn.setTitle(tableData.footer[section], for: .normal)
//        btn.setTitleColor(.black, for: .normal)

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
        
        //let footerBtn = FooterBtn.instanceBtn(id: .news, title: <#T##String#>, viewContainer: <#T##UIView#>)
        
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
            print("on all announce pressed")
            //navigationController?.pushViewController(AnnounceAllTableViewController(), animated: true)
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
    //var btn: UIButton?
    var viewContainer: UIView?
    
    init(id: BtnType, title: String, viewContainer: UIView/*, actionTouchUpInside: @escaping () -> ()*/) {
        self.btnType = id
        self.viewContainer = viewContainer
//        btn = UIButton(frame: CGRect(x: DefaultParams.x,
//                                     y: DefaultParams.y,
//                                     width: Int(viewContainer.frame.width),
//                                     height: DefaultParams.height))
//        btn?.backgroundColor = DefaultParams.backgroundColor
//        btn?.setTitle(title, for: .normal)
//        btn?.setTitleColor(DefaultParams.titleColor, for: .normal)
//        self.actionTouchUpInside = actionTouchUpInside
//        btn?.addTarget(self, action: #selector(actionTouchUpInside), for: .touchUpInside)
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
    
//    func addTouchUpInside(() -> ()) {
//        
//    }
    
    static func instanceBtn(id: BtnType, title: String, viewContainer: UIView/*, actionTouchUpInside: () -> ()*/) -> FooterBtn {
        return FooterBtn(id: id, title: title, viewContainer: viewContainer).getInstance()
    }
}















