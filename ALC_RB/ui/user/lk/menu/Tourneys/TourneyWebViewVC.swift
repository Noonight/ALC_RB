//
//  TourneyWebViewVC.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 25.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WebKit

final class TourneyWebViewVC: UIViewController {
    
    var webView: WKWebView!
    var refreshControll = UIRefreshControl()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Мой турнир"
        
        setupWebView()
        setupPullToRefresh()
        
    }
    
}

// MARK: SETUP

extension TourneyWebViewVC {
    
    func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        webView.allowsBackForwardNavigationGestures = true
        
        let url = URL(string: "https://football.bwadm.ru")!
        webView.load(URLRequest(url: url))
    }
    
    func setupPullToRefresh() {
        let refreshController = UIRefreshControl()
        webView.scrollView.refreshControl = refreshController
        
        refreshController.rx
            .controlEvent(.valueChanged)
            .map { _ in !refreshController.isRefreshing}
            .filter { $0 == false }
            .observeOn(MainScheduler.instance)
            .subscribe({ event in
                self.webView.reload()
            }).disposed(by: self.bag)
        
        refreshController.rx.controlEvent(.valueChanged)
            .map { _ in refreshController.isRefreshing }
            .filter { $0 == true }
            .observeOn(MainScheduler.instance)
            .subscribe({ event in
                refreshController.endRefreshing()
            })
            .disposed(by: self.bag)
    }
    
}

// MARK: WKNavigationDelegate

extension TourneyWebViewVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.hud = showLoadingViewHUD()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.navigationController?.navigationBar.topItem?.title = webView.title
        self.hideHUD()
    }
}
