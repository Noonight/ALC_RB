//
//  ClubsTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 13.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class ClubsTableViewController: UITableViewController, MvpView {

    let cellId = "cell_club"
    
    let presenter = ClubsPresenter()
    
    var clubs = Clubs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        initView()
    }

    func initView() {
        tableView.tableFooterView = UIView()
        
        //showLoading()
    }
    
    func updateUI() {
        tableView.reloadData()
    }
}

extension ClubsTableViewController {
    
    func initPresenter() {
        presenter.attachView(view: self)
        
        presenter.getClubs()
    }
}

extension ClubsTableViewController: ClubsTableView {
//    func showLoading() {
//        //UIActivityIndicatorView.startAnimating(self)
//    }
//
//    func hideLoading() {
//
//    }
    
    func onGetClubsSuccess(_ clubs: Clubs) {
        self.clubs = clubs
        //try! print(clubs.jsonString())
        updateUI()
    }
    
    func onGetImageSuccess(_ img: UIImage) {
        //
    }
}

//extension ClubsTableViewController: ActivityIndicator {
//
//    var indicator: UIActivityIndicatorView {
//        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
//        indicator.center = tableView.center
//        indicator.hidesWhenStopped = true
//        view.addSubview(indicator)
//        return indicator
//    }
//
//    func showLoading() {
//        indicator.startAnimating()
//    }
//
//    func hideLoading() {
//        indicator.stopAnimating()
//    }
//}

extension ClubsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubs.clubs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ClubTableViewCell
        
        cell.mTitle?.text = clubs.clubs[indexPath.row].name
        //print(clubs.clubs[indexPath.row].name)
//        cell.imageView?.image
        presenter.getImage(imageName: clubs.clubs[indexPath.row].logo) { (image) in
            cell.mImage?.image = image.af_imageRoundedIntoCircle()
        }
        return cell
    }
    
}

extension ClubsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ClubsTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if  segue.identifier == newsDetailSegueIdentifier,
//            let destination = segue.destination as? NewsDetailViewController,
//            let cellIndex = tableView.indexPathForSelectedRow?.row
//        {
//            destination.content = NewsDetailViewController.NewsDetailContent(
//                title: tableData!.news[cellIndex].caption,
//                date: (tableData!.news[cellIndex].updatedAt).UTCToLocal(from: .utc, to: .local),
//                content: tableData!.news[cellIndex].content,
//                imagePath: tableData!.news[cellIndex].img)
//        }
    }
    
}
