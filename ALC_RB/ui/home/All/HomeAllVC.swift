//
//  HomeAllVC.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa

final class HomeAllVC: UIViewController {

    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var news_collection: UICollectionView!
    @IBOutlet weak var matches_table: IntrinsicTableView!
    
    var announcesReloadCallBack: AnnouncesReloadCallBack?
    
    private var news_hud: MBProgressHUD?
    
    private var homeAllViewModel: HomeAllViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNewsCollection()
        setupHomeAllViewModel()
        setupBinds()
        setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.homeAllViewModel.fetch()
    }
}

// MARK: EXTENSIONS



// MARK: SETUP

extension HomeAllVC {
    
    func setupPullToRefresh() {
        let refreshController = UIRefreshControl()
        scroll_view.refreshControl = refreshController
        
        refreshController.rx
            .controlEvent(.valueChanged)
            .map { _ in !refreshController.isRefreshing}
            .filter { $0 == false }
            .subscribe({ event in
                self.homeAllViewModel.fetch()
                self.announcesReloadCallBack?.reload()
            }).disposed(by: disposeBag)
        
        refreshController.rx.controlEvent(.valueChanged)
            .map { _ in refreshController.isRefreshing }
            .filter { $0 == true }
            .subscribe({ event in
                refreshController.endRefreshing()
            })
            .disposed(by: self.disposeBag)
    }
    
    func setupNewsCollection() {
        news_collection.delegate = nil
        news_collection.dataSource = nil
        
        news_collection.register(UINib(nibName: "HomeNewsCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: HomeNewsCollectionViewCell.ID)
    }
    
    func setupHomeAllViewModel() {
        homeAllViewModel = HomeAllViewModel(newDataManager: ApiRequests())
    }
    
    func setupBinds() {
        
        homeAllViewModel.newsViewModel
            .items
            .bind(to: news_collection.rx.items(cellIdentifier: HomeNewsCollectionViewCell.ID, cellType: HomeNewsCollectionViewCell.self)) { (row, news, cell) in
            cell.newsModelItem = news
        }.disposed(by: disposeBag)
        
        news_collection.rx
            .itemSelected
            .subscribe { indexPath in
                guard let mIndexPath = indexPath.element else { return }
                let cell = self.news_collection.cellForItem(at: mIndexPath) as! HomeNewsCollectionViewCell
                self.showNewsDetail(news: cell.newsModelItem)
        }.disposed(by: disposeBag)
        
        homeAllViewModel.newsViewModel
            .items
            .subscribe({ modelItems in
                guard let mModelItems = modelItems.element else { return }
                if mModelItems.count == 0 {
                    if self.news_hud != nil {
                        self.news_hud?.setToEmptyView(message: Constants.Texts.NO_STARRED_TOURNEYS, detailMessage: Constants.Texts.GO_TO_CHOOSE_TOURNEYS, tap: {
                            self.showTourneyChooser()
                        })
                    } else {
                        self.news_hud = self.showEmptyViewHUD(
                            addTo: self.news_collection,
                            message: Constants.Texts.NO_STARRED_TOURNEYS,
                            detailMessage: Constants.Texts.GO_TO_CHOOSE_TOURNEYS,
                            tap: {
                                self.showTourneyChooser()
                        })
                    }
                } else {
                    self.news_hud?.hide(animated: false)
                    self.news_hud = nil
                }
            }).disposed(by: disposeBag)
        
        homeAllViewModel.newsViewModel
            .loading
            .subscribe { isLoading in
                if isLoading.element ?? false {
                    if self.news_hud != nil {
                        self.news_hud?.setToLoadingView()
                    } else {
                        self.news_hud = self.showLoadingViewHUD(addTo: self.news_collection)
                    }
                } else {
                    self.news_hud?.hide(animated: false)
                    self.news_hud = nil
                }
        }.disposed(by: disposeBag)
        
        homeAllViewModel.newsViewModel
            .error
            .subscribe { error in
                guard let mError = error.element else { return }
                if self.news_hud != nil {
                    self.news_hud?.setToFailureView(detailMessage: mError?.localizedDescription, tap: {
                        self.homeAllViewModel.newsViewModel.fetch()
                    })
                } else {
                    self.news_hud = self.showFailureViewHUD(addTo: self.news_collection, detailMessage: mError?.localizedDescription, tap: {
                        self.homeAllViewModel.newsViewModel.fetch()
                    })
                }
        }.disposed(by: disposeBag)
    }
}

// MARK: HELPERS

extension HomeAllVC {
    
    func showNewsDetail(news: NewsModelItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        newViewController.newsModelItem = news
        self.navigationController?.show(newViewController, sender: self)
    }
    
    func showTourneyChooser() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TournamentSearchVC") as! TournamentSearchVC
        self.navigationController?.show(newViewController, sender: self)
    }
    
}
