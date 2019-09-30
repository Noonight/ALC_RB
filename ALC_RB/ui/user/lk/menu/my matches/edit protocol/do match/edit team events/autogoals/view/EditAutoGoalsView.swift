//
//  EditAutoGoalsView.swift
//  ALC_RB
//
//  Created by ayur on 09.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol EditAutoGoalsCallBack {
    func complete(value: Int)
}

final class EditAutoGoalsView: UIView {

    @IBOutlet var container_view: UIView!
    @IBOutlet weak var team_label: UILabel!
    @IBOutlet weak var value_label: UILabel!
    @IBOutlet weak var minus_button: UIButton!
    @IBOutlet weak var plus_button: UIButton!
    @IBOutlet weak var accept_button: UIButton!
    
    @IBOutlet weak var border_view: DesignableView!
    
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
    var callBack: EditAutoGoalsCallBack? {
        didSet {
            setupCallBacks()
        }
    }
    
    public func initValues(team: String, defValue: Int, callBack: EditAutoGoalsCallBack) {
        self.team = team
        self.value = defValue
        self.callBack = callBack
        
        setupButtons()
    }
    
    // MARK: SETUP
    
    private func setupButtons() {
        self.minus_button.addTarget(self, action: #selector(onMinusPressed), for: .touchUpInside)
        self.plus_button.addTarget(self, action: #selector(onPlusPressed), for: .touchUpInside)
    }
    
    private func setupCallBacks() {
        if self.callBack != nil
        {
            accept_button.addTarget(self, action: #selector(onAcceptPressed), for: .touchUpInside)
        }
    }
    
    private func setupBorderView() {
        self.border_view.borderWidth = 1
        self.border_view.borderColor = .red
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
        self.setupBorderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
        self.setupBorderView()
    }
    
    private func initView() {
        Bundle.main.loadNibNamed("EditAutoGoalsView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}
