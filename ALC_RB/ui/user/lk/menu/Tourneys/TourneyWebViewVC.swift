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
    private let userDefaults = UserDefaultsHelper()
    
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
        
        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        let token = userDefaults.getToken()
        let js = "javascript: localStorage.setItem('authToken', '\(token)')"
        let userScript = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        contentController.addUserScript(userScript)
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
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
