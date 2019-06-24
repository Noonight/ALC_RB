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
    private enum AlertLets {
        static let alertTitle = "Ошибка!"
        static let alertMessage = "Не получилось получить данные пользователя. Нажмите 'Перезагрузить' чтобы попробовать снова"
        static let okBtn = "Ок"
        static let refreshBtn = "Перезагрузить"
    }
    
    var viewModel: MyMatchesRefViewModel!
    let disposeBag = DisposeBag()
    let userDefaults = UserDefaultsHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        viewModel = MyMatchesRefViewModel(dataManager: ApiRequests())
        
        tableView.tableFooterView = UIView()
        
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUser()
        
        viewModel.fetch()
    }
    
    func setupUser() {
        do {
            viewModel.participationMatches.value = (userDefaults.getAuthorizedUser()?.person.participationMatches)!
//            viewModel.participationMatches.onNext((userDefaults.getAuthorizedUser()?.person.participationMatches)!)
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
            .bind(to: tableView.rx.items(cellIdentifier: CellIdentifiers.cell, cellType: MyMatchesRefTableViewCell.self)) {  (row, model, cell) in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { (indexPath) in
                self.tableView.deselectRow(at: indexPath.element!, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}
