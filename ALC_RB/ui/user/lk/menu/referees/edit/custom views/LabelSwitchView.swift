//
//  LabelSwitchView.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 01/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class LabelSwitchView: UIView {
    enum Constants {
        static let NIB_NAME = "LabelSwitchView"
    }
    
    @IBOutlet var container_view: UIView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var appoint_switch: UISwitch!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        Bundle.main.loadNibNamed(Constants.NIB_NAME, owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    var name: String? {
        get {
            return name_label.text
        }
        set {
            name = newValue
            showName(newValue!)
        }
    }
    var isAppointed: Bool {
        get {
            return appoint_switch.isOn
        }
        set {
            appoint_switch.isOn = newValue
            if appoint_switch.isOn {
                showSwitcher(appoint_switch.isOn)
            }
        }
    }
    
    func configure(state: State) {
        reset()
        switch state {
        case .switcher(let isOn):
            showSwitcher(isOn)
        case .name(let value):
            showName(value)
        }
    }
    
    func reset() {
        appoint_switch.isHidden = true
        name_label.isHidden = false
        name_label.text = ""
    }
    
    func showSwitcher(_ isOn: Bool) {
        appoint_switch.isOn = isOn
        name_label.isHidden = true
        appoint_switch.isHidden = false
    }
    
    func showName(_ name: String) {
        name_label.text = name
        name_label.isHidden = false
        appoint_switch.isHidden = true
    }
    
    enum State {
        case switcher(Bool)
        case name(String)
    }
}
