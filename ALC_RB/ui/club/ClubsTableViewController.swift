//
//  ClubsTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 13.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Kingfisher

class ClubsTableViewController: BaseStateTableViewController {
    enum CellIdentifiers {
        static let CLUB = "cell_club"
    }
    enum SegueIdentifiers {
        static let DETAIL = "TeamDetailSegue"
    }
    
    // MARK: Var & Let
    
    let presenter = ClubsPresenter()
    var clubs = [Club]()
//    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurePresenter()
        self.configureEmptyView()
        self.configureTableView()
        self.configureRefreshController()
        
        self.refreshData()
    }
}
// MARK: Extensions

// MARK: Configure
extension ClubsTableViewController {
    func configurePresenter() {
        self.initPresenter()
    }
    func configureRefreshController() {
        self.fetch = self.presenter.getClubs
    }
    func configureEmptyView() {
        self.setEmptyMessage(message: "Здесь будут отображаться клубы")
    }
    func configureTableView() {
        self.tableView.tableFooterView = UIView()
    }
}

// MARK: Refresh controller
extension ClubsTableViewController {
    override func hasContent() -> Bool {
        if clubs.count != 0 {
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
    
    func onGetClubsSuccess(_ clubs: [Club]) {
        self.clubs = clubs
        endRefreshing()
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

// MARK: Table view
// MARK: Data source
extension ClubsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CLUB, for: indexPath) as! ClubTableViewCell

        let model = clubs[indexPath.row]
        
        cell.mTitle.text = model.name
//        cell.mImage.image = #imageLiteral(resourceName: "ic_con")
//        cell.mImage.image = nil
//        cell.mImage.layer.cornerRadius = cell.mImage.frame.size.width / 2
//        cell.mImage.clipsToBounds = true
        if model.logo != nil || model.logo?.count != 0 {
//            cell.mImage.image.downsampledImage
            let url = ApiRoute.getImageURL(image: model.logo!)
            let processor = DownsamplingImageProcessor(size: cell.mImage.frame.size)
                .append(another: CroppingImageProcessorCustom(size: cell.mImage.frame.size))
                .append(another: RoundCornerImageProcessor(cornerRadius: cell.mImage.getHalfWidthHeight()))
            
            cell.mImage.kf.indicatorType = .activity
            cell.mImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: "ic_bal"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "") size of image is \(value.image.size)")

                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
        
        return cell
    }
    
}

// MARK: Delegate
extension ClubsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Navigation
extension ClubsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == SegueIdentifiers.DETAIL,
            let destination = segue.destination as? ClubDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            let cacheImage = ImageCache.default
            
            if let imageUrl = clubs[cellIndex].logo
            {
                cacheImage.retrieveImage(forKey: ApiRoute.getAbsoluteImageRoute(imageUrl))
                { result in
                    switch result
                    {
                    case .success(let value):
                        if let image = value.image
                        {
                            destination.content = ClubDetailContent(
                                image: image,
                                title: self.clubs[cellIndex].name ?? "",
                                owner: (self.clubs[cellIndex].owner?.getValue()?.surname!)!,
                                text: self.clubs[cellIndex].info ?? "")
                        }
                        else
                        {
                            destination.content = ClubDetailContent(
                                image: nil,
                                title: self.clubs[cellIndex].name ?? "",
                                owner: (self.clubs[cellIndex].owner?.getValue()?.surname!)!,
                                text: self.clubs[cellIndex].info ?? "")
                        }
                    case .failure(let error):
                        print(error)
                        destination.content = ClubDetailContent(
                            image: nil,
                            title: self.clubs[cellIndex].name ?? "",
                            owner: (self.clubs[cellIndex].owner?.getValue()?.surname!)!,
                            text: self.clubs[cellIndex].info ?? "")
                    }
                }
            }
            else
            {
                destination.content = ClubDetailContent(
                    image: nil,
                    title: self.clubs[cellIndex].name ?? "",
                    owner: (self.clubs[cellIndex].owner?.getValue()?.surname!)!,
                    text: self.clubs[cellIndex].info ?? "")
            }
            
        }
    }
}
