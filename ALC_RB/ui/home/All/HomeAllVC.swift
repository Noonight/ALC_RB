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

    @IBOutlet weak var news_collection: UICollectionView!
    @IBOutlet weak var matches_table: IntrinsicTableView!
    
    private var news_hud: MBProgressHUD?
    
    private var homeAllViewModel: HomeAllViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        news_collection.delegate = nil
        news_collection.dataSource = nil
        
        news_collection.register(UINib(nibName: "HomeNewsCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: HomeNewsCollectionViewCell.ID)
        
        setupHomeAllViewModel()
        setupBinds()
        
        self.homeAllViewModel.fetch()
    }
}

// MARK: EXTENSIONS



// MARK: SETUP

extension HomeAllVC {
    
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
    
}
