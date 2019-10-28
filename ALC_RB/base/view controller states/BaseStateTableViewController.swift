//
//  LoadingEmptyTVC.swift
//  ALC_RB
//
//  Created by ayur on 15.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class BaseStateTableViewController: UITableViewController {

    let emptyView = EmptyViewNew()
    var backgroundView: UIView?
    var emptyMessage = "Здесь будет отображаться ..."
    
    var state = BaseState.normal
    
    var headerFooterOfSectionsIsHidden = false {
        didSet {
            if headerFooterOfSectionsIsHidden == true {
                tableView.beginUpdates()
                tableView.sectionHeaderHeight = 0
                tableView.sectionFooterHeight = 0
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                tableView.sectionHeaderHeight = inMemorySectionHeaderHeight
                tableView.sectionFooterHeight = inMemorySectionFooterHeight
                tableView.endUpdates()
            }
        }
    }
    var inMemorySectionHeaderHeight: CGFloat = 0
    var inMemorySectionFooterHeight: CGFloat = 0
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    var fetch: (() -> ())? // for fetch data in pull to refresh extension ** need init in view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inMemorySectionHeaderHeight = tableView.sectionHeaderHeight
        inMemorySectionFooterHeight = tableView.sectionFooterHeight
        self.setupPullToRefresh()
//        tableView.tableFooterView = UIView()
    }

    func setEmptyMessage(message new: String) {
        self.emptyMessage = new
    }
    
}

extension BaseStateTableViewController : BaseStateActions {
    func setState(state: BaseState) {
        if self.state != state {
            switch state {
            case .normal:
                hideLoading()
                hideEmptyView()
                headerFooterOfSectionsIsHidden = false
                self.state = .normal
            case .loading:
                headerFooterOfSectionsIsHidden = true
                hideEmptyView()
                showLoading()
                self.state = .loading
            case .error(let message):
                showAlert(message: message)
                self.state = .error(message: message)
            case .empty:
                headerFooterOfSectionsIsHidden = true
                hideLoading()
                showEmptyView()
                self.state = .empty
            }
        }
    }
}

protocol PullToRefresh {
    // var fetch() -> for downloads new data, and after complete download, need use end refreshing method
    func setupPullToRefresh() // use in viewDidLoad
    func refreshData() // @objc func
    func endRefreshing() // use when fetch data is complete
    func hasContent() -> Bool // need to override
}

// MARK: PULL TO REFRESH

extension BaseStateTableViewController : PullToRefresh {

    func setupPullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        if self.state == .loading { return }
        if self.refreshControl?.isRefreshing == false {
            self.setState(state: .loading)
        }
        if tableView.isDragging == false
        {
            self.fetch!()
        }
    }
    
    func endRefreshing() {
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
        
        if self.hasContent() == true {
            self.setState(state: .normal)
        } else {
            self.setState(state: .empty)
        }
    }
    
    @objc func hasContent() -> Bool {
        return true
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl?.isRefreshing == true
        {
            refreshData()
        }
    }
}

// MARK: EMPTY PROTOCOL

extension BaseStateTableViewController : EmptyProtocol {
    
    func showEmptyView() {
//        backgroundView = UIView()
//
//        backgroundView?.frame = view.frame
//
//        backgroundView?.backgroundColor = .white
//        backgroundView?.addSubview(emptyView)
//
//        view.addSubview(backgroundView!)
//
//        backgroundView?.translatesAutoresizingMaskIntoConstraints = true
//
//        emptyView.setText(text: emptyMessage)
//
//        emptyView.setCenterFromParentTrue()
//        emptyView.containerView.setCenterFromParentTrue()
        
        tableView.isScrollEnabled = false
        
        if self.hud != nil {
            self.hud?.setToEmptyView {
                self.emptyAction?()
            }
        } else {
            self.hud = self.showEmptyViewHUD {
                self.emptyAction?()
            }
        }
        
    }
    
    func hideEmptyView() {
//        tableView.separatorStyle = .singleLine
//        tableView.isScrollEnabled = true
//
//        if let backgroundView = backgroundView {
//            backgroundView.removeFromSuperview()
//        }
        tableView.isScrollEnabled = true
        self.hideHUD()
        self.hud = nil
    }
}

// MARK: LOADING PROTOCOL

extension BaseStateTableViewController : ActivityIndicatorProtocol {
    func showLoading() {
        
//        backgroundView = UIView()
//
//        backgroundView?.frame = view.frame
//        backgroundView?.backgroundColor = .white
//        backgroundView?.addSubview(activityIndicator)
//
//        view.addSubview(backgroundView!)
//
//        backgroundView?.translatesAutoresizingMaskIntoConstraints = true
//
//        activityIndicator.frame = view.frame
//        activityIndicator.backgroundColor = .white
//
//        activityIndicator.setCenterFromParent()
//
//        activityIndicator.startAnimating()
//
        tableView.isScrollEnabled = false
//
//        view.bringSubviewToFront(backgroundView!)
//
//        activityIndicator.startAnimating()
        if self.hud != nil {
            self.hud?.setToLoadingView()
        } else {
            self.hud = self.showLoadingViewHUD()
        }
    }
    
    func hideLoading() {
//        activityIndicator.stopAnimating()
//
//        if let backgroundView = backgroundView {
//            backgroundView.removeFromSuperview()
//        }
        tableView.isScrollEnabled = true
        
        self.hideHUD()
        self.hud = nil
    }
    
}
