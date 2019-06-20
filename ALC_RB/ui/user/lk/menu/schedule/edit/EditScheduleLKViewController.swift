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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainRefShowProtocol_btn: UIBarButtonItem!
    @IBOutlet weak var save_btn: UIBarButtonItem!
    @IBOutlet weak var referee1_btn: UIButton!
    @IBOutlet weak var referee2_btn: UIButton!
    @IBOutlet weak var referee3_btn: UIButton!
    @IBOutlet weak var timekeeper_btn: UIButton!
    
    let viewModel = EditScheduleViewModel(dataManager: ApiRequests())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.keyboardDismissMode = .interactive
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainRefShowProtocol_btn.image = mainRefShowProtocol_btn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
        save_btn.image = save_btn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
    }
    
    func setupBindings() {
        
        viewModel.error
            .observeOn(MainScheduler.instance)
            .subscribe { (error) in
                self.setState(state: .error(message: error.element?.localizedDescription ?? "Ошибка"))
            }
            .disposed(by: disposeBag)
        
        viewModel.refreshing
            .subscribe { (refreshing) in
                refreshing.element ?? false ? self.setState(state: .loading) : self.setState(state: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.activeMatch
            .map { (activeMatch) -> Bool in
                return activeMatch.played
            }
            .subscribe { (played) in
                played.element! ? (self.mainRefShowProtocol_btn.isEnabled = false) : (self.mainRefShowProtocol_btn.isEnabled = true)
            }
            .disposed(by: disposeBag)
        
        viewModel.activeMatch
            .map { (activeMatch) -> [Referee] in
                return activeMatch.referees
            }
            .subscribe { (referees) in
                for ref in referees.element! {
                    switch ref.getRefereeType() {
                    case .referee1:
                        self.referee1_btn.setTitle(ref.person, for: .normal)
                    case .referee2:
                        self.referee2_btn.setTitle(ref.person, for: .normal)
                    case .referee3:
                        self.referee3_btn.setTitle(ref.person, for: .normal)
                    case .timekeeper:
                        self.timekeeper_btn.setTitle(ref.person, for: .normal)
                    case .invalid:
                        self.setState(state: .error(message: "Ошибка преобразования рефери."))
                    }
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    @IBAction func onReferee1BtnPressed(_ sender: UIButton) {
        ActionSheetStringPicker.show(withTitle: "we have a test here!", rows: ["Element1", "Element2", "Element3", "Element4"], initialSelection: 1, doneBlock: { (picker, indexes, values) in
            Print.m("in done blick picker index is \(indexes), value is \(values)")
//            self.viewModel.activeMatch.onNext(viewModel.activeMatch.takeLast(1).)
//            self.viewModel.activeMatch
//                .map({ (activeMatch) -> ActiveMatch in
//                    var referees = activeMatch.referees
//
////                    return activeMatch.referees
//                })
        }, cancel: { (picker) in
            Print.m("cancel")
        }, origin: sender)
//        let actionDelegate = ActionSheetCustomPickerDelegate()
//        ActionSheetCustomPicker.show(withTitle: <#T##String?#>, delegate: <#T##ActionSheetCustomPickerDelegate!#>, showCancelButton: <#T##Bool#>, origin: <#T##Any!#>)
//        ActionSheetCustomPicker(title: <#T##String!#>, delegate: <#T##ActionSheetCustomPickerDelegate!#>, showCancelButton: <#T##Bool#>, origin: <#T##Any!#>, initialSelections: <#T##[Any]!#>)
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
