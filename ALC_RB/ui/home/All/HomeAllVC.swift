//
//  HomeAllVC.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import MBProgressHUD

final class HomeAllVC: UIViewController {

    @IBOutlet weak var news_collection: UICollectionView!
    @IBOutlet weak var matches_table: IntrinsicTableView!
//    @IBOutlet weak var announces_table: IntrinsicTableView!
    
    var newsCollection: HomeNewsCollection?
    var scheduleTable: HomeScheduleTable?
    var announcesTable: HomeAnnouncesTable?
    
    private var homeAllPresenter: HomeAllPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupHomeAllPresenter()
        self.setupNewsTable()
        self.setupScheduleTable()
        
        self.setupNewsDS()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: EXTENSIONS



// MARK: SETUP

extension HomeAllVC {
    
    func setupHomeAllPresenter() {
        self.homeAllPresenter = HomeAllPresenter(dataManager: ApiRequests())
    }
    
    func setupNewsTable() {
        self.newsCollection = HomeNewsCollection(actions: self)
        self.news_collection.delegate = self.newsCollection
        self.news_collection.dataSource = self.newsCollection
        self.news_collection.register(self.newsCollection?.cellNib, forCellWithReuseIdentifier: HomeNewsCollectionViewCell.ID)
        Print.m("here")
    }
    
    func setupNewsDS() {
        let  hud = self.news_collection.showLoadingViewHUD()
        self.homeAllPresenter.fetchNews(success: { news in
            self.fSuccess(hud: hud, news: news)
        }, r_message: { message in
            self.fMessage(hud: hud, message: message)
        }, failureAll: { error in
            self.fAllFailure(hud: hud, error: error)
        }, failureServer: { error in
            self.fServerFailure(hud: hud, error: error)
        }, failureLocal: { error in
            self.fLocalFailure(hud: hud, error: error)
        })
    }
    
    func setupScheduleTable() {
        self.scheduleTable = HomeScheduleTable(actions: self)
        self.matches_table.delegate = self.scheduleTable
        self.matches_table.dataSource = self.scheduleTable
    }
    
    func setupScheduleTableDataSource() {
        
    }
}

// MARK: ACTIONS

extension HomeAllVC: CellActions {
    func onCellSelected(model: CellModel) {
        switch model  {
        case is NewsElement:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
//            newViewController.newsElement = (model as! NewsElement)
//            self.present(newViewController, animated: true, completion: nil)
//            self.navigationController?.present(newViewController, animated: true, completion: nil)
            let newsElement = model as! NewsElement
            newViewController.newsElement = newsElement
            self.navigationController?.show(newViewController, sender: self)
//            NewsDetailViewController
        case is MmMatch:
            Print.m("match cell selected")
        default:
            Print.m("default tap here")
        }
    }
}

// MARK: HELPERS

extension HomeAllVC {
    
    func fSuccess(hud: MBProgressHUD? = nil, news: News) {
        hud?.hide(animated: true)
        self.newsCollection?.dataSource = news.news
        self.news_collection.reloadData()
    }
    
    func fMessage(hud: MBProgressHUD? = nil, message: SingleLineMessage) {
        hud?.setToButtonHUD(message: message.message, btn: {
            self.setupNewsDS()
        })
    }
    
    func fAllFailure(hud: MBProgressHUD? = nil, error: Error) {
        hud?.setToButtonHUD(message: Constants.Texts.UNDEFINED_FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupNewsDS()
        })
    }
    
    func fServerFailure(hud: MBProgressHUD? = nil, error: Error) {
        hud?.setToButtonHUD(message: Constants.Texts.SERVER_FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupNewsDS()
        })
    }
    
    func fLocalFailure(hud: MBProgressHUD? = nil, error: Error) {
        hud?.setToButtonHUD(message: Constants.Texts.FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupNewsDS()
        })
    }
    
}
