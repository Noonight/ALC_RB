//
//  MyMatchesRefTableViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MyMatchesRefTableViewController: BaseStateTableViewController {
    private enum CellIdentifiers {
        static let cell = "cell_my_matches"
    }
    private enum SegueIdentifiers {
        static let showProtocol = "segue_showProtocol"
    }
    private enum AlertLets {
        static let alertTitle = "Ошибка!"
        static let alertMessage = "Не получилось получить данные пользователя. Нажмите 'Перезагрузить' чтобы попробовать снова"
        static let okBtn = "Ок"
        static let refreshBtn = "Перезагрузить"
    }
    
    private lazy var refProtocol: EditMatchProtocolViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "EditMatchProtocolViewControllerProtocol") as! EditMatchProtocolViewController
        
        return viewController
    }()
    
    var viewModel: MyMatchesRefViewModel!
    let disposeBag = DisposeBag()
    let userDefaults = UserDefaultsHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        viewModel = MyMatchesRefViewModel(dataManager: ApiRequests())
        
        tableView.tableFooterView = UIView()
        
        setEmptyMessage(message: "Здвесь будут отображаться ваши матчи")
        
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // issue: cell not worked when we go back
        self.title = "Матчи"
        navigationController?.navigationBar.topItem?.title = self.title
        
        viewModel.participationMatches.value = (userDefaults.getAuthorizedUser()?.person.participationMatches)!.filter({ pMatch -> Bool in
            return pMatch.referees.contains(where: { referee -> Bool in
                return referee.person == userDefaults.getAuthorizedUser()?.person.id
            })
        })
        viewModel.fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewWillDisappear(animated)
//        viewModel.firstInit.value = true
    }
    
    func setupUser() {
        do {
            viewModel.participationMatches.value = (userDefaults.getAuthorizedUser()?.person.participationMatches)!.filter({ pMatch -> Bool in
                return pMatch.referees.contains(where: { referee -> Bool in
                    return referee.person == UserDefaultsHelper().getAuthorizedUser()?.person.id
                })
            })
        } catch {
            showAlert(title: AlertLets.alertTitle, message: AlertLets.alertMessage, actions:
                [
                    UIAlertAction(title: AlertLets.okBtn, style: .default, handler: nil),
                    UIAlertAction(title: AlertLets.refreshBtn, style: .default, handler: { alertAction in
                        self.setupUser()
                    })
                ]
            )
        }
    }
    
    // MARK: - Binds
    func bindViews() {
        
        viewModel.refreshing
            .subscribe { (refreshing) in
                refreshing.element! ? (self.setState(state: .loading)) : (self.setState(state: .normal))
            }
            .disposed(by: disposeBag)
        
        viewModel.error
            .subscribe { (error) in
                self.setState(state: .error(message: error.element!.localizedDescription))
            }
            .disposed(by: disposeBag)
        
        viewModel.tableModel
            .map({ (cellModel) -> [MyMatchesRefTableViewCell.CellModel] in
                return cellModel.sorted(by: { (lModel, rModel) -> Bool in
                    return lModel.participationMatch!.date.getDateOfType(type: .utcTime) < rModel.participationMatch!.date.getDateOfType(type: .utcTime)
                })
            })
            .bind(to: tableView.rx.items(cellIdentifier: CellIdentifiers.cell, cellType: MyMatchesRefTableViewCell.self)) {  (row, model, cell) in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
        
        viewModel.tableModel
            .subscribe { (tableModel) in
                if tableModel.element?.count == 0 {
                    self.setState(state: .empty)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { (indexPath) in
                self.tableView.deselectRow(at: indexPath.element!, animated: true)
                let cell = self.tableView.cellForRow(at: indexPath.element!) as? MyMatchesRefTableViewCell
                
                let activityIndicator = UIActivityIndicatorView(style: .gray)
                activityIndicator.hidesWhenStopped = true
                
                if cell?.accessoryType == .disclosureIndicator
                {
                    
                    cell?.accessoryView = activityIndicator
                   
                    activityIndicator.startAnimating()
                    
                    guard let leagueId = cell?.cellModel?.participationMatch?.league else {
                        Print.m("cell league is nil")
                        return
                    }
                    self.viewModel.fetchLeagueInfo(
                        id: leagueId,
                        success: { leagueInfo in
                            activityIndicator.stopAnimating()
                            cell?.accessoryView = nil

                            cell?.accessoryType = .detailDisclosureButton
                            cell?.accessoryType = .disclosureIndicator

                            self.refProtocol.leagueDetailModel.leagueInfo = leagueInfo
                            guard let match = leagueInfo.league.matches?.filter({ match -> Bool in
                                return match.id == cell?.cellModel?.participationMatch?.id
                            }).first else {
                                Print.m("not found match in incoming league matches")
                                return
                            }
                            self.refProtocol.match = match
                            
                            self.refProtocol.model = cell?.cellModel
                            
                            self.show(self.refProtocol, sender: self)
                        },
                        failure: { error in
                            self.showAlert(message: error.localizedDescription)
                        }
                    )
                    
                }
                // for feature, if referee is not 3-rd referee type then show protocol only for watching
            }
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.showProtocol,
            let destination = segue.destination as? EditMatchProtocolViewController,
            let cellIndex = tableView.indexPathForSelectedRow
        {
//            destination.leagueDetailModel =
            let cell = (tableView.cellForRow(at: cellIndex) as? MyMatchesRefTableViewCell)?.cellModel!.participationMatch!.leagueID
//            destination.leagueDetailModel = self.leagueDetailModel
//            destination.match = self.leagueDetailModel.leagueInfo.league.matches![cellIndex]
            //destination.scheduleCell = self.scheduleCell
        }
    }
}
