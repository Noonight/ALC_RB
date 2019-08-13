//
//  EditFoulsView.swift
//  ALC_RB
//
//  Created by ayur on 09.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol EditFoulsCallBack {
    func complete(value: Int)
}

final class EditFoulsView: UIView {

    @IBOutlet var container_view: UIView!
    @IBOutlet weak var minus_button: UIButton!
    @IBOutlet weak var plus_button: UIButton!
    @IBOutlet weak var value_label: UILabel!
    @IBOutlet var team_label: UILabel!
    @IBOutlet weak var accept_button: UIButton!
    
    private var team: String = "" {
        didSet {
            self.team_label.text = team
        }
    }
    var value: Int = 0 {
        didSet {
            self.value_label.text = String(value)
            if self.value == 0
            {
                self.disableMinusBtn()
            }
            else
            {
                self.activeMinusBtn()
            }
        }
    }
    var callBack: EditFoulsCallBack? {
        didSet {
            setupCallBacks()
        }
    }

    public func initValues(team: String, defValue: Int, callBack: EditFoulsCallBack) {
        self.team = team
        self.value = defValue
        self.callBack = callBack
        
        self.setupButtons()
    }
    
    // MARK: SETUP
    
    private func setupCallBacks() {
        if self.callBack != nil
        {
            accept_button.addTarget(self, action: #selector(onAcceptPressed), for: .touchUpInside)
        }
    }
    
    private func setupButtons() {
        self.minus_button.addTarget(self, action: #selector(onMinusPressed), for: .touchUpInside)
        self.plus_button.addTarget(self, action: #selector(onPlusPressed), for: .touchUpInside)
    }
    
    // MARK: ACTIONS
    
    @objc func onMinusPressed() {
        self.value -= 1
    }
    
    @objc func onPlusPressed() {
        self.value += 1
    }
    
    @objc func onAcceptPressed() {
        self.callBack?.complete(value: self.value)
    }
    
    // MARK: HELPER
    
    func disableMinusBtn() {
        self.minus_button.isEnabled = false
    }
    
    func activeMinusBtn() {
        self.minus_button.isEnabled = true
    }
    
    // MARK: INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        Bundle.main.loadNibNamed("EditFoulsView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
