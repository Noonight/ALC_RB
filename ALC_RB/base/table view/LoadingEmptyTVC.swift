//
//  LoadingEmptyTVC.swift
//  ALC_RB
//
//  Created by ayur on 15.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class LoadingEmptyTVC: UITableViewController {

    let emptyView = EmptyView()
    let backgroundView = UIView()
    var emptyStr = "Здесь будут отображаться ..."
    
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
    
}

extension LoadingEmptyTVC : EmptyProtocol {
    func showEmptyView() {
//        backgroundView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height)
//        backgroundView.backgroundColor = .white
//        backgroundView.addSubview(emptyView)
        
        emptyView.text_label.text = emptyStr
        
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
//        emptyView.setCenterFromParent()
        
        view.addSubview(emptyView)
        
//        view.addConstraints([
//            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: emptyView, attribute: .left, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: emptyView, attribute: .top, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: emptyView, attribute: .right, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: emptyView, attribute: .bottom, multiplier: 1.0, constant: 0)
//            ])

        emptyView.frame = view.frame
        
        view.bringSubviewToFront(emptyView)
    }
    
    func hideEmptyView() {
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = true
        
        emptyView.removeFromSuperview()
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
