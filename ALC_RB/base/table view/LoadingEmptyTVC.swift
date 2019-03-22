//
//  LoadingEmptyTVC.swift
//  ALC_RB
//
//  Created by ayur on 15.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class LoadingEmptyTVC: UITableViewController {

    let emptyView = EmptyViewNew()
    var backgroundView: UIView?
    var emptyStr = "Здесь будет отображаться ..."
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        prepareEmptyView()
//        emptyView
    }
    
    func prepareEmptyView() {
        emptyView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        
        let emptyImage = UIImageView(image: UIImage(named: "ic_empty"))
        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyImage.contentMode = .scaleAspectFit
        emptyImage.addConstraint(NSLayoutConstraint(item: emptyImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160))
        emptyImage.addConstraint(NSLayoutConstraint(item: emptyImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 160))
        
        let emptyLabel = UILabel(frame: .zero)
        emptyLabel.text = "Здесь ничего нет"
        
        let textLabel = UILabel(frame: .zero)
        textLabel.text = emptyStr
        textLabel.numberOfLines = 3
        textLabel.textColor = UIColor.lightText
        
        emptyView.addSubview(emptyImage)
        emptyView.addSubview(emptyLabel)
        emptyView.addSubview(textLabel)
        
        emptyView.translatesAutoresizingMaskIntoConstraints = true
        
        emptyView.addConstraints([
            NSLayoutConstraint(item: emptyView, attribute: .centerX, relatedBy: .equal, toItem: emptyImage, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: emptyView, attribute: .centerX, relatedBy: .equal, toItem: emptyLabel, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: emptyView, attribute: .centerX, relatedBy: .equal, toItem: textLabel, attribute: .centerX, multiplier: 1.0, constant: 0),
            
            NSLayoutConstraint(item: emptyView, attribute: .top, relatedBy: .equal, toItem: emptyImage, attribute: .top, multiplier: 1.0, constant: 8),
            NSLayoutConstraint(item: emptyImage, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: emptyLabel, attribute: .top, multiplier: 1.0, constant: 40),
            NSLayoutConstraint(item: emptyLabel, attribute: .left, relatedBy: .equal, toItem: emptyView, attribute: .left, multiplier: 1.0, constant: 16),
            NSLayoutConstraint(item: emptyLabel, attribute: .right, relatedBy: .equal, toItem: emptyView, attribute: .right, multiplier: 1.0, constant: 16),
            NSLayoutConstraint(item: emptyLabel, attribute: .bottom, relatedBy: .equal, toItem: textLabel, attribute: .top, multiplier: 1.0, constant: 16),
            NSLayoutConstraint(item: textLabel, attribute: .left, relatedBy: .equal, toItem: emptyView, attribute: .left, multiplier: 1.0, constant: 16),
            NSLayoutConstraint(item: textLabel, attribute: .right, relatedBy: .equal, toItem: emptyView, attribute: .right, multiplier: 1.0, constant: 16)/*,
            NSLayoutConstraint(item: textLabel, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: emptyView, attribute: .bottom, multiplier: 1.0, constant: 16)*/
            ])
    }

    func setEmptyText(text: String) {
        self.emptyStr = text
    }
    
//    func showEmptyView(view: UIView) {
////        emptyView.backgroundColor = UIColor.clear
//
//        backgroundView = UIView()
//
//        backgroundView?.frame = view.frame
//
////        emptyView.backgroundColor = .clear
////        emptyView.containerView.backgroundColor = .clear
//        backgroundView?.backgroundColor = .white
//        backgroundView?.addSubview(emptyView)
//
//        view.addSubview(backgroundView!)
//
//        backgroundView?.translatesAutoresizingMaskIntoConstraints = true
//
//        emptyView.setCenterFromParentTrue()
//        emptyView.containerView.setCenterFromParentTrue()
//
////        view.translatesAutoresizingMaskIntoConstraints = false
////
////        view.topAnchor.constraint(equalTo: (backgroundView?.topAnchor)!).isActive = true
////        view.leftAnchor.constraint(equalTo: (backgroundView?.leftAnchor)!).isActive = true
////        view.rightAnchor.constraint(equalTo: (backgroundView?.rightAnchor)!).isActive = true
////        view.bottomAnchor.constraint(equalTo: (backgroundView?.bottomAnchor)!).isActive = true
//
////        backgroundView?.translatesAutoresizingMaskIntoConstraints = false
////
////        backgroundView?.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
////        backgroundView?.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
//    }
    
}

extension LoadingEmptyTVC : EmptyProtocol {
//    func showEmptyView() {
//
//        backgroundView = UIView()
//
////        backgroundView?.frame = view.frame
//
////        Print.m("Screen frame = \(UIScreen.main.bounds)")
////        Print.m("Background view frame = \(backgroundView?.frame)")
////        Print.m("view frame of view controller = \(view.frame)")
////        Print.m("empty view frame = \(emptyView.frame)")
//
//
//        view.addSubview(backgroundView!)
//
//        view.translatesAutoresizingMaskIntoConstraints = true
//        backgroundView?.translatesAutoresizingMaskIntoConstraints = true
//
//        view?.topAnchor.constraint(equalTo: (backgroundView?.topAnchor)!).isActive = true
//        view?.leftAnchor.constraint(equalTo: (backgroundView?.leftAnchor)!).isActive = true
//        view?.rightAnchor.constraint(equalTo: (backgroundView?.rightAnchor)!).isActive = true
//        view?.bottomAnchor.constraint(equalTo: (backgroundView?.bottomAnchor)!).isActive = true
//
//        backgroundView?.addSubview(emptyView)
//
//        backgroundView?.backgroundColor = .red
//
//        tableView.backgroundColor = .blue
//
//        view.backgroundColor = UIColor.darkText
//
//        emptyView.setCenterFromParentTrue()
//
////        backgroundView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height)
////        backgroundView.backgroundColor = .white
////        backgroundView.addSubview(emptyView)
//
//        emptyView.textLabel.text = emptyStr
//
//        tableView.isScrollEnabled = false
//        tableView.separatorStyle = .none
//
////        emptyView.setCenterFromParent()
//
//
////        view.addConstraints([
////            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: emptyView, attribute: .left, multiplier: 1.0, constant: 0),
////            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: emptyView, attribute: .top, multiplier: 1.0, constant: 0),
////            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: emptyView, attribute: .right, multiplier: 1.0, constant: 0),
////            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: emptyView, attribute: .bottom, multiplier: 1.0, constant: 0)
////            ])
//
////        emptyView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
////        emptyView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
////        emptyView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
////        emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
////        emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
////        emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//
//
//        view.bringSubviewToFront(backgroundView!)
//    }
    
    func showEmptyView() {
        backgroundView = UIView()
        
        backgroundView?.frame = view.frame
        
        //        emptyView.backgroundColor = .clear
        //        emptyView.containerView.backgroundColor = .clear
        backgroundView?.backgroundColor = .white
        backgroundView?.addSubview(emptyView)
        
        view.addSubview(backgroundView!)
        
        backgroundView?.translatesAutoresizingMaskIntoConstraints = true
        
        emptyView.setText(text: emptyStr)
        
        emptyView.setCenterFromParentTrue()
        emptyView.containerView.setCenterFromParentTrue()
        
        tableView.isScrollEnabled = false
    }
    
    func hideEmptyView() {
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = true
        
        if let backgroundView = backgroundView {
            backgroundView.removeFromSuperview()
        }
    }
}

extension LoadingEmptyTVC : ActivityIndicatorProtocol {
    func showLoading() {
        activityIndicator.frame = view.frame
        activityIndicator.backgroundColor = .white
        
        tableView.isScrollEnabled = false
        
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        
        tableView.isScrollEnabled = true
        
        activityIndicator.removeFromSuperview()
    }
    
    
}
