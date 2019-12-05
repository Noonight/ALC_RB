//
//  EditScheduleLKViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SPStorkController

protocol EditScheduleCallBack {
    func back(match: Match)
}

class EditScheduleLKViewController: UIViewController {
    private enum Texts {
        static let NO_REF = "Не назначен"
        static let REFEREES = "Рефери"
        static let NO_REF_FIO = "ФИО не указано"
        static let EDITED_SAVED = "Изменения сохранены"
    }
    private enum Colors {
        static let NO_REF = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)
        static let YES_REF = #colorLiteral(red: 0.07843137255, green: 0.5568627451, blue: 1, alpha: 1)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainRefShowProtocol_btn: UIBarButtonItem!
    @IBOutlet weak var save_btn: UIBarButtonItem!
    
    @IBOutlet weak var tourneyLeagueLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var teamOneLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var teamTwoLabel: UILabel!
    
    @IBOutlet weak var referee1_btn: UIButton!
    @IBOutlet weak var referee2_btn: UIButton!
    @IBOutlet weak var referee3_btn: UIButton!
    @IBOutlet weak var timekeeper_btn: UIButton!
    
    var viewModel: EditScheduleViewModel = EditScheduleViewModel(matchApi: MatchApi())
    private let bag = DisposeBag()
    
    var editScheduleCallBack: EditScheduleCallBack?
    
    private var choosePersonVC: ChoosePersonVC!
    
    private lazy var refProtocol: EditMatchProtocolViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "EditMatchProtocolViewControllerProtocol") as! EditMatchProtocolViewController
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupPersonChooser()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainRefShowProtocol_btn.image = mainRefShowProtocol_btn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
        
        setupViewBinds()
        setupView()
        
    }
    
}

// MARK: - SETUP

extension EditScheduleLKViewController {
    
    func setupView() {
        guard let matchModel = viewModel.matchScheduleModel.value else { return }
        
        self.tourneyLeagueLabel.text = matchModel.leagueName
//        self.dateTimeLabel.text = "\(matchModel.date) : \(matchModel.time)"
        self.dateTimeLabel.text = matchModel.dateTime
        self.placeLabel.text = matchModel.place
        self.teamOneLabel.text = matchModel.teamOneName
        self.teamTwoLabel.text = matchModel.teamTwoName
        self.scoreLabel.text = matchModel.score
        
        
        self.viewModel.refereesModel.setup(referees: matchModel.match.referees)
    }
    
    func setupViewBinds() {
        
        viewModel
            .refereesModel
            .firstReferee
            .observeOn(MainScheduler.instance)
            .subscribe { element in
                if let person = element.element {
                    if let personName = person?.getSurnameNP() {
                        self.referee1_btn.setTitleAndColorWith(title: personName, color: Colors.YES_REF)
                    } else {
                        self.referee1_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
                    }
                } else {
                    self.referee1_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
                }
            }.disposed(by: bag)
        
        viewModel
            .refereesModel
            .secondReferee
            .observeOn(MainScheduler.instance)
            .subscribe { element in
                if let person = element.element {
                    if let personName = person?.getSurnameNP() {
                        self.referee2_btn.setTitleAndColorWith(title: personName, color: Colors.YES_REF)
                    } else {
                        self.referee2_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
                    }
                } else {
                    self.referee2_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
                }
            }.disposed(by: bag)
        
        viewModel
            .refereesModel
            .thirdReferee
            .observeOn(MainScheduler.instance)
            .subscribe { element in
                if let person = element.element {
                    if let personName = person?.getSurnameNP() {
                        self.referee3_btn.setTitleAndColorWith(title: personName, color: Colors.YES_REF)
                    } else {
                        self.referee3_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
                    }
                } else {
                    self.referee3_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
                }
            }.disposed(by: bag)
        
        viewModel
            .refereesModel
            .timekeeper
            .observeOn(MainScheduler.instance)
            .subscribe { element in
                if let person = element.element {
                    if let personName = person?.getSurnameNP() {
                        self.timekeeper_btn.setTitleAndColorWith(title: personName, color: Colors.YES_REF)
                    } else {
                        self.timekeeper_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
                    }
                } else {
                    self.timekeeper_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
                }
            }.disposed(by: bag)
        
        viewModel.editedMatch
            .observeOn(MainScheduler.instance)
            .subscribe({ element in
                guard let match = element.element else { return }
                Print.m("MATCH WAS EDITED = \(match)")
                self.showSuccessViewHUD(seconds: 2, closure: {
                    self.editScheduleCallBack?.back(match: match)
                })
            })
            .disposed(by: bag)
        
        viewModel.loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.loading)
            .disposed(by: bag)
        
        viewModel
            .error
            .asDriver(onErrorJustReturn: nil)
            .drive(self.rx.error)
            .disposed(by: bag)
        
        viewModel
            .message
            .asDriver(onErrorJustReturn: nil)
            .drive(self.rx.message)
            .disposed(by: bag)
    }
    
    func setupPersonChooser() {
        self.choosePersonVC = ChoosePersonVC()
        choosePersonVC.callBack = self
    }
    
}

// MARK: - ACTIONS

extension EditScheduleLKViewController {
    
    @IBAction func onReferee1BtnPressed(_ sender: UIButton) {
        self.showPersonChooser(type: .firstReferee)
    }
    
    @IBAction func onReferee2BtnPressed(_ sender: UIButton) {
        self.showPersonChooser(type: .secondReferee)
    }
    
    @IBAction func onReferee3BtnPressed(_ sender: UIButton) {
        self.showPersonChooser(type: .thirdReferee)
    }
    
    @IBAction func onTimekeeperBtnPressed(_ sender: UIButton) {
        self.showPersonChooser(type: .timekeeper)
    }
    
    @IBAction func onMainRefShowProtocolBtnPressed(_ sender: UIBarButtonItem) {
        self.showAlert(message: "Рабочий протокол")
        //        let activityIndicator = UIActivityIndicatorView(style: .gray)
        //        activityIndicator.hidesWhenStopped = true
        //
        //        let defaultView = sender.customView
        //        sender.customView = activityIndicator
        //
        //        activityIndicator.startAnimating()
        //
        //        guard let leagueId = viewModel?.comingCellModel.value.activeMatch.league?.getId() ?? viewModel?.comingCellModel.value.activeMatch.league?.getValue()?.id else {
        //            Print.m("cell league is nil")
        //            return
        //        }
        //
        //        self.viewModel?.fetchLeague(id: leagueId, resultMy: { result in
        //            switch result {
        //            case .success(let leagues):
        //                sender.customView = defaultView
        //
        //                self.refProtocol.leagueDetailModel.league = leagues.first!
        //                guard let match = leagues.first!.matches?.filter({ match -> Bool in
        //                    return match.id == self.viewModel?.comingCellModel.value.activeMatch.id
        //                }).first else {
        //                    Print.m("not found match in incoming league matches")
        //                    return
        //                }
        //                self.refProtocol.match = match
        //
        //                self.refProtocol.model = self.viewModel?.comingCellModel.value.convertToMyMatchesRefTableViewCellCellModle()
        //
        //                self.refProtocol.preConfigureModelControllers()
        //
        //                self.show(self.refProtocol, sender: self)
        //            case .message(let message):
        //                sender.customView = defaultView
        //
        //                self.showAlert(message: message.message)
        //            case .failure(.notExpectedData):
        //                Print.m("not expected data")
        //            case .failure(.error(let error)):
        //                self.showAlert(message: error.localizedDescription)
        //                Print.m(error)
        //            }
        //        })
    }
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        viewModel.editMatchReferees()
    }
    
}

// MARK: - HELPER

extension EditScheduleLKViewController {
    
    func showPersonChooser(type: Referee.rType) {
        let transitionDelegate = SPStorkTransitioningDelegate()
        choosePersonVC.transitioningDelegate = transitionDelegate
        choosePersonVC.modalPresentationStyle = .formSheet
        choosePersonVC.modalPresentationCapturesStatusBarAppearance = true
        choosePersonVC.refereeType = type
//        self.present(choosePersonVC, animated: true, completion: nil)
        self.presentAsStork(choosePersonVC)
    }
}

extension EditScheduleLKViewController: ChoosePersonResult {
    func complete(type: Referee.rType, person: Person) {
        switch type {
        case .firstReferee:
            self.viewModel.refereesModel.firstReferee.accept(person)
        case .secondReferee:
            self.viewModel.refereesModel.secondReferee.accept(person)
        case .thirdReferee:
            self.viewModel.refereesModel.thirdReferee.accept(person)
        case .timekeeper:
            self.viewModel.refereesModel.timekeeper.accept(person)
        }
    }
}

// MARK: NAVIGATION

extension EditScheduleLKViewController {
    
}
