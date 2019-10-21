//
//  MyTourneysVC.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import WebKit

class MyTourneysVC: UIViewController {

    static func getInstance() -> MyTourneysVC {
        return MyTourneysVC()
    }
    
    var webView: WKWebView!
    var refreshControll = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = .green
        webView = WKWebView()
        webView.navigationDelegate = self
        refreshControll.addTarget(self, action: #selector(refresh), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControll
        view = webView
        webView.reload()
        
        let url = URL(string: "https://football.bwadm.ru")!
        webView.load(URLRequest(url: url))
          
        // 2
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func refresh() {
        webView.reload()
    }

}

extension MyTourneysVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
