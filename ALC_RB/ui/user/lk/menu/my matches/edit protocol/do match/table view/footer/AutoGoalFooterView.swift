//
//  AutoGoalFooter.swift
//  ALC_RB
//
//  Created by ayur on 28.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class AutoGoalFooterView: UIView {

    static let HEIGHT: CGFloat = 40
    
    @IBOutlet var container_view: UIView!
    @IBOutlet weak var goals_label: UILabel!
    
    var countOfGoals = 0 {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI() {
        self.resetUI()
        
        self.goals_label.text = String(self.countOfGoals)
    }
    
    private func resetUI() {
        self.goals_label.text = "0"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        Bundle.main.loadNibNamed("AutoGoalFooterView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
