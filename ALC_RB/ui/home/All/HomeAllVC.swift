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
    
    private var news_hud: MBProgressHUD?
    
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.news_collection.layoutIfNeeded()
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
    }
    
    func setupNewsDS() {
        self.news_hud = self.showLoadingViewHUD(addTo: self.news_collection)
        self.homeAllPresenter.fetchNews(success: { news in
            self.fSuccess(news: news)
        }, r_message: { message in
            self.fMessage(message: message)
        }, failureAll: { error in
            self.fAllFailure(error: error)
        }, failureServer: { error in
            self.fServerFailure(error: error)
        }, failureLocal: { error in
            self.fLocalFailure(error: error)
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
    
    func fSuccess(news: News) {
        news_hud?.hide(animated: true)
        self.newsCollection?.dataSource = news.news
        self.news_collection.reloadData()
    }
    
    func fMessage(message: SingleLineMessage) {
        news_hud?.setToButtonHUD(message: message.message, btn: {
            self.setupNewsDS()
        })
    }
    
    func fAllFailure(error: Error) {
        news_hud?.setToButtonHUD(message: Constants.Texts.UNDEFINED_FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupNewsDS()
        })
    }
    
    func fServerFailure(error: Error) {
        news_hud?.setToButtonHUD(message: Constants.Texts.SERVER_FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupNewsDS()
        })
    }
    
    func fLocalFailure(error: Error) {
        news_hud?.setToButtonHUD(message: Constants.Texts.FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupNewsDS()
        })
    }
    
}
