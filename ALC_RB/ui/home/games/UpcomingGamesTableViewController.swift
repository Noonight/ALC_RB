//
//  GamesTableViewController.swift
//  ALC_RB
//
//  Created by user on 28.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class UpcomingGamesTableViewController: UITableViewController, MvpView {
    
    let cellId = "cell_upcoming_game"
    
    @IBOutlet var empty_view: UIView!
    
    var tableData = MmUpcomingMatches()
    
    private let presenter = UpcomingGamesPresenter()
    
    var backgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
//        tableView.register(UpcomingGameTableViewCell.self, forCellReuseIdentifier: UpcomingGameTableViewCell.idCell)
        
        tableView.tableFooterView = UIView()
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.getUpcomingGames()
    }
    
    func updateUI() {
        
        if (tableData.count == 0) {
            showEmptyView()
        } else {
            hideEmptyView()
        }
        
        self.tableView.reloadData()
    }
    
    func showEmptyView() {
        
        let newEmptyView = EmptyViewNew()
        
        //        backgroundView = UIView()
//        backgroundView.frame = tableView.frame
//
//        backgroundView.backgroundColor = .white
//        backgroundView.addSubview(newEmptyView)
//
//        tableView.addSubview(backgroundView)
//
//        newEmptyView.setText(text: "На этой неделе нет матчей")
//
//        backgroundView.translatesAutoresizingMaskIntoConstraints = true
//
//        newEmptyView.setCenterFromParent()
//        newEmptyView.containerView.setCenterFromParent()
//
//        backgroundView.setCenterFromParent()
//
//        tableView.bringSubviewToFront(backgroundView)
//
////        tableView.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
////        tableView.backgroundView?.addSubview(empty_view)
//        tableView.separatorStyle = .none
        
        
//        empty_view.setCenterFromParent()
//        let image = #imageLiteral(resourceName: "ic_empty")
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFit
//        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        showCustomViewHUD(cView: imageView)
        
        showEmptyViewHUD {
            self.hideHUD()
            self.showToastHUD(message: "Уже загрузилося")
        }
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//            self.hideHUD()
//        }
    }
    
    func hideEmptyView() {
//        tableView.backgroundView = nil
        backgroundView.removeFromSuperview()
        tableView.separatorStyle = .singleLine
    }
    
    func onGetUpcomingMatchesSuccesful(data: MmUpcomingMatches) {
        tableData = data
        //try! print(tableData.jsonString())
        updateUI()
    }
    
    func onGetUpcomingMatchesFailure(error: Error) {
        Print.m(error)
        let alert = UIAlertController(title: "Ошибка!", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Перезагрузить", style: .default, handler: { (action) in
            self.presenter.getUpcomingGames()
        }))
        self.present(alert, animated: true, completion: nil)
//        show(alert, sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.matches?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingGameTableViewCell.idCell, for: indexPath) as! UpcomingGameTableViewCell
        
        //cell!.configureCell(data: (tableData?.matches[indexPath.row])!)
        //cell?.data = tableData.matches[indexPath.row]
        
//        let model = tableData.matches![indexPath.row]
        if let model = tableData.matches?[indexPath.row] {
            if let date =  model.date {
                cell.mDate.text = date.convertDate(from: .utcTime, to: .local)

            }
            cell.mTime.text = model.date!.convertDate(from: .utcTime, to: .localTime)
            cell.mTour.text = model.tour
            cell.mPlace.text = model.place
            cell.mTitleTeam1.text = model.teamOne?.name
            cell.mTitleTeam2.text = model.teamTwo?.name
            cell.mScore.text = model.score ?? " - "
            
            presenter.findClub(clubId: (model.teamOne?.club)!) { (club) in
                cell.mImageTeam1.af_setImage(withURL: ApiRoute.getImageURL(image: club!.logo ?? ""), placeholderImage: #imageLiteral(resourceName: "ic_logo"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: true, completion: { (response) in
                    cell.mImageTeam1.image = response.result.value?.af_imageRoundedIntoCircle()
                })
            }
            
            presenter.findClub(clubId: (model.teamTwo?.club)!) { (club) in
                cell.mImageTeam2.af_setImage(withURL: ApiRoute.getImageURL(image: club!.logo ?? ""), placeholderImage: #imageLiteral(resourceName: "ic_logo"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: true, completion: { (response) in
                    cell.mImageTeam2.image = response.result.value?.af_imageRoundedIntoCircle()
                })
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
