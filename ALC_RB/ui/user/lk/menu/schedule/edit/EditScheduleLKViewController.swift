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
import ActionSheetPicker_3_0

class EditScheduleLKViewController: BaseStateViewController {
    private enum Texts {
        static let NO_REF = "Не назначен"
        static let REFEREES = "Рефери"
        static let NO_REF_FIO = "ФИО не указано"
    }
    private enum Colors {
        static let NO_REF = #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)
        static let YES_REF = #colorLiteral(red: 0.07843137255, green: 0.5568627451, blue: 1, alpha: 1)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainRefShowProtocol_btn: UIBarButtonItem!
    @IBOutlet weak var save_btn: UIBarButtonItem!
    @IBOutlet weak var referee1_btn: UIButton!
    @IBOutlet weak var referee2_btn: UIButton!
    @IBOutlet weak var referee3_btn: UIButton!
    @IBOutlet weak var timekeeper_btn: UIButton!
    
    var viewModel: EditScheduleViewModel? = EditScheduleViewModel(dataManager: ApiRequests())
    private let disposeBag = DisposeBag()
    
//    private var
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.keyboardDismissMode = .interactive
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        mainRefShowProtocol_btn.image = mainRefShowProtocol_btn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
        save_btn.image = save_btn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
    }
    
    deinit {
        self.viewModel = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        clearUI()
    }
    
    // MARK: - SETUP UI
    
    func setupUI() {
        clearUI()
        setupReferee()
        setupShowProtocolBtn()
        
        setupSliders()
        
//        Print.m(viewModel?.comingReferees.value)
    }
    
    func clearUI() {
        referee1_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
        referee2_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
        referee3_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
        timekeeper_btn.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
    }
    
    func setupShowProtocolBtn() {
        viewModel!.comingCellModel.value.activeMatch.played ? (mainRefShowProtocol_btn.isEnabled = false) : (mainRefShowProtocol_btn.isEnabled = true)
    }
    
    func setupSliders() {
        
    }
    
    func setupReferee() {
        for ref in viewModel!.comingCellModel.value.activeMatch.referees {
            switch ref.getRefereeType() {
            case .referee1:
                self.referee1_btn.setTitle(ref.person, for: .normal)
                self.referee1_btn.setTitleColor(Colors.YES_REF, for: .normal)
            case .referee2:
                self.referee2_btn.setTitle(ref.person, for: .normal)
                self.referee2_btn.setTitleColor(Colors.YES_REF, for: .normal)
            case .referee3:
                self.referee3_btn.setTitle(ref.person, for: .normal)
                self.referee3_btn.setTitleColor(Colors.YES_REF, for: .normal)
            case .timekeeper:
                self.timekeeper_btn.setTitle(ref.person, for: .normal)
                self.timekeeper_btn.setTitleColor(Colors.YES_REF, for: .normal)
            case .invalid:
                showRepeatAlert(message: "Не удалось настроить интерфейс") {
                    self.setupUI()
                }
//                self.setState(state: .error(message: "Ошибка преобразования рефери."))
            }
        }
    }
    
    func setupBindings() {
        
        viewModel!.error
            .observeOn(MainScheduler.instance)
            .subscribe { (error) in
                self.setState(state: .error(message: error.element?.localizedDescription ?? "Ошибка"))
            }
            .disposed(by: disposeBag)
        
        viewModel!.refreshing
            .subscribe { (refreshing) in
                refreshing.element ?? false ? self.setState(state: .loading) : self.setState(state: .normal)
            }
            .disposed(by: disposeBag)
        
//        viewModel.comingCellModel.value.activeMatch
//            .map { (activeMatch) -> Bool in
//                return activeMatch.played
//            }
//            .subscribe { (played) in
//                played.element! ? (self.mainRefShowProtocol_btn.isEnabled = false) : (self.mainRefShowProtocol_btn.isEnabled = true)
//            }
//            .disposed(by: disposeBag)
        
//        viewModel.activeMatch
//            .map { (activeMatch) -> [Referee] in
//                return activeMatch.referees
//            }
//            .subscribe { (referees) in
//                for ref in referees.element! {
//                    switch ref.getRefereeType() {
//                    case .referee1:
//                        self.referee1_btn.setTitle(ref.person, for: .normal)
//                    case .referee2:
//                        self.referee2_btn.setTitle(ref.person, for: .normal)
//                    case .referee3:
//                        self.referee3_btn.setTitle(ref.person, for: .normal)
//                    case .timekeeper:
//                        self.timekeeper_btn.setTitle(ref.person, for: .normal)
//                    case .invalid:
//                        self.setState(state: .error(message: "Ошибка преобразования рефери."))
//                    }
//                }
//            }
//            .disposed(by: self.disposeBag)
    }
    
    @IBAction func onReferee1BtnPressed(_ sender: UIButton) {
        ActionSheetStringPicker.show(
            withTitle: Texts.REFEREES,
            rows: viewModel?.comingReferees.value.people.filter({ person -> Bool in
                return person.getFullName().count > 2
            }).map({ person -> String in
                return person.getFullName()
            }),
            initialSelection: 1,
            doneBlock: { (picker, indexes, values) in
                
                Print.m("we find person in referees array with name - \(values).\nThe person is \(self.viewModel?.comingReferees.value.findPersonBy(fullName: values as! String))")
        }, cancel: { (picker) in
            Print.m("cancel")
        }, origin: sender)
    }
    
    @IBAction func onReferee2BtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func onReferee3BtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func onTimekeeperBtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func onMainRefShowProtocolBtnPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        
    }
    
}

//extension EditScheduleLKViewController : ActionSheetCustomPickerDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        <#code#>
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//
//    }
//
//
//}
