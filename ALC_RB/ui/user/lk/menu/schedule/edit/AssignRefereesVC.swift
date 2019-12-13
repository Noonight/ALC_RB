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

protocol AssignRefereesCallBack {
    func assignRefereesBack(match: Match)
}

class AssignRefereesVC: UIViewController {
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
    enum Kind {
        // show: match info, show editMatchProtocol btn
        case schedule
        // hide: match info, hide editMatchProtocol btn
        case editMatchProtocol // before work protocol view
    }
    
    static func getInstance(kind: AssignRefereesVC.Kind, match: Match, callBack: AssignRefereesCallBack) -> AssignRefereesVC {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let assignRefereesVC = storyboard.instantiateViewController(withIdentifier: "AssignRefereesVC") as! AssignRefereesVC
        
        assignRefereesVC.assignRefereesCallBack = callBack
        assignRefereesVC.viewModel = AssignRefereesViewModel(matchApi: MatchApi())
        assignRefereesVC.viewModel.match.accept(match)
        assignRefereesVC.kind = kind
        
        return assignRefereesVC
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainRefShowProtocol_btn: UIBarButtonItem!
    @IBOutlet weak var save_btn: UIBarButtonItem!
    
    @IBOutlet weak var matchInfoHeight: NSLayoutConstraint!
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
    
    var viewModel: AssignRefereesViewModel = AssignRefereesViewModel(matchApi: MatchApi())
    private let bag = DisposeBag()
    
    var assignRefereesCallBack: AssignRefereesCallBack?
    var kind = Kind.schedule
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

extension AssignRefereesVC {
    
    func setupView() {
        
        guard let match = viewModel.match.value else { return }
        
        switch kind {
        case .schedule:
            self.matchInfoHeight.constant = 130
            self.tourneyLeagueLabel.text = match.league?.getValue()?.name
            self.dateTimeLabel.text = "\(match.date?.toFormat(DateFormats.local.rawValue) ?? "") : \(match.date?.toFormat(DateFormats.localTime.rawValue) ?? "")"
            self.placeLabel.text = match.place?.getValue()?.name
            self.teamOneLabel.text = match.teamOne?.getValue()?.name
            self.teamTwoLabel.text = match.teamTwo?.getValue()?.name
            self.scoreLabel.text = match.score
            
            self.mainRefShowProtocol_btn.isEnabled = true
            self.mainRefShowProtocol_btn.image = UIImage(named: "ic_document")
        case .editMatchProtocol:
            self.matchInfoHeight.constant = 0
            self.mainRefShowProtocol_btn.isEnabled = false
            self.mainRefShowProtocol_btn.image = nil
        }
        
        self.viewModel.refereesModel.setup(referees: match.referees)
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
                    self.assignRefereesCallBack?.assignRefereesBack(match: match)
                })
            })
            .disposed(by: bag)
        
        viewModel
            .matchIsFetched
            .observeOn(MainScheduler.instance)
            .subscribe {
                guard let match = self.viewModel.match.value else { return }
                self.viewModel.refereesModel.setup(referees: match.referees)
            }.disposed(by: bag)
        
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

extension AssignRefereesVC {
    
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
        self.showEditMatchProtocol()
    }
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        viewModel.editMatchReferees()
    }
    
}

// MARK: - HELPER

extension AssignRefereesVC {
    
    func showEditMatchProtocol() {
        let vc = EditMatchProtocolViewController.getInstance(match: self.viewModel.match.value!, callBack: self)
        self.show(vc, sender: self)
    }
    
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

extension AssignRefereesVC: ChoosePersonResult {
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

extension AssignRefereesVC: EditMatchProtocolCallBack {
    func back(match: Match) {
        self.viewModel.fetchMatchReferees()
    }
}

// MARK: NAVIGATION

extension AssignRefereesVC {
    
}
