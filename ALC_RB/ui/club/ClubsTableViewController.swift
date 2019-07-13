//
//  ClubsTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 13.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class ClubsTableViewController: BaseStateTableViewController {

    let cellId = "cell_club"
    
    let segueId = "TeamDetailSegue"
    
    let presenter = ClubsPresenter()
    
    var clubs = Clubs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        self.fetch = self.presenter.getClubs
        initView()
        
        self.refreshData()
    }

    func initView() {
        tableView.tableFooterView = UIView()
        setEmptyMessage(message: "Здесь будут отображаться клубы")
    }
    
    func updateUI() {
        tableView.reloadData()
    }
}

extension ClubsTableViewController {
    override func hasContent() -> Bool {
        if clubs.clubs.count != 0 {
            return true
        } else {
            return false
        }
    }
}

// MARK: Presenter
extension ClubsTableViewController: ClubsTableView {
    func onGetClubsFailure(_ error: Error) {
        endRefreshing()
        Print.m(error)
        showFailFetchRepeatAlert(message: error.localizedDescription) {
            self.refreshData()
        }
    }
    
    func onGetClubsSuccess(_ clubs: Clubs) {
        self.clubs = clubs
        endRefreshing()
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

extension ClubsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubs.clubs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ClubTableViewCell

        cell.configure(with: clubs.clubs[indexPath.row])
        
//        cell.mTitle?.text = clubs.clubs[indexPath.row].name
//        //print(clubs.clubs[indexPath.row].name)
////        cell.imageView?.image
//        cell.imageView?.image = #imageLiteral(resourceName: "ic_con")
//        cell.imageView?.af_setImage(withURL: ApiRoute.getImageURL(image: clubs.clubs[indexPath.row].logo), placeholderImage: #imageLiteral(resourceName: "ic_con"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: true, completion: { (response) in
//            cell.imageView?.image = response.result.value?.af_imageRoundedIntoCircle()
//        })
//        presenter.getImage(imageName: clubs.clubs[indexPath.row].logo) { (image) in
//            cell.mImage?.image = image.af_imageRoundedIntoCircle()
//        }
        
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
        if  segue.identifier == segueId,
            let destination = segue.destination as? ClubDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.content = ClubDetailContent(
                image: (tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! ClubTableViewCell).mImage.image!,
                title: clubs.clubs[cellIndex].name ?? "",
                owner: clubs.clubs[cellIndex].owner?.surname ?? "",
                text: clubs.clubs[cellIndex].info ?? "")
        }
    }
    
}
