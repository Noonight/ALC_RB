//
//  NewsAllTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 07.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class NewsAllTableViewController: UITableViewController {
    
    private var homeNewsViewModel: HomeNewsViewModel!
    private let disposeBag = DisposeBag()
    
    private var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        setupNewsViewModel()
        setupBinds()
        
        homeNewsViewModel.fetch()
    }
    
}

// MARK: EXTENSIONS



// MARK: SETUP

extension NewsAllTableViewController {
    
    func setupNewsViewModel() {
        homeNewsViewModel = HomeNewsViewModel(newDataManager: ApiRequests())
    }
    
    func setupBinds() {
        
        homeNewsViewModel
            .items
            .bind(to: tableView.rx.items(cellIdentifier: NewsTableViewCell.ID, cellType: NewsTableViewCell.self)) { (row, news, cell) in
                cell.newsModelItem = news
        }.disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe { indexPath in
                guard let mIndexPath = indexPath.element else { return }
                let cell = self.tableView.cellForRow(at: mIndexPath) as! NewsTableViewCell
                self.showNewsDetail(news: cell.newsModelItem)
        }.disposed(by: disposeBag)
        
        homeNewsViewModel
            .loading
            .subscribe { isLoading in
                if isLoading.element ?? false {
                    if self.hud != nil {
                        self.hud?.setToLoadingView()
                    } else {
                        self.hud = self.showLoadingViewHUD(addTo: self.tableView)
                    }
                } else {
                    self.hud?.hide(animated: false)
                    self.hud = nil
                }
        }.disposed(by: disposeBag)
        
        homeNewsViewModel
            .error
            .subscribe { error in
                guard let mError = error.element else { return }
                if self.hud != nil {
                    self.hud?.setToFailureView(detailMessage: mError?.localizedDescription, tap: {
                        self.homeNewsViewModel.fetch()
                    })
                } else {
                    self.hud = self.showFailureViewHUD(addTo: self.tableView, detailMessage: mError?.localizedDescription, tap: {
                        self.homeNewsViewModel.fetch()
                    })
                }
        }.disposed(by: disposeBag)
        
    }
    
}

// MARK: NAVIGATION

extension NewsAllTableViewController {
    
    func showNewsDetail(news: NewsModelItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        newViewController.newsModelItem = news
        self.navigationController?.show(newViewController, sender: self)
        
    }
    
}
