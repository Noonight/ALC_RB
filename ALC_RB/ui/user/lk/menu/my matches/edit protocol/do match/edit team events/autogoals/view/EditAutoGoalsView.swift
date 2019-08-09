//
//  EditAutoGoalsView.swift
//  ALC_RB
//
//  Created by ayur on 09.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class EditAutoGoalsView: UIView {

    @IBOutlet var container_view: UIView!
    @IBOutlet weak var team_label: UILabel!
    @IBOutlet weak var value_label: UILabel!
    @IBOutlet weak var minus_button: UIButton!
    @IBOutlet weak var plus_button: UIButton!
    @IBOutlet weak var accept_button: UIButton!
    
    private var team: String = "" {
        didSet {
            self.team_label.text = team
        }
    }
    var value: Int = 0 {
        didSet {
            self.value_label.text = String(value)
        }
    }
    
    public func initValues(team: String, defValue: Int) {
        self.team = team
        self.value = defValue
        
        setupButtons()
    }
    
    // MARK: SETUP
    
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
        Bundle.main.loadNibNamed("EditAutoGoalsView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}