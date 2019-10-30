//
//  ProtocolAllFooterView.swift
//  ALC_RB
//
//  Created by ayur on 05.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ProtocolAllFooterView: UIView {
    static let HEIGHT = 54
    
    @IBOutlet var container_view: UIView!
    
    @IBOutlet weak var left_foul_view: DesignableView!
    @IBOutlet weak var right_foul_view: DesignableView!
    
    @IBOutlet weak var left_foul_score_label: UILabel!
    @IBOutlet weak var right_foul_score_label: UILabel!
    
    var leftFouls = 0 {
        didSet {
            left_foul_score_label.text = String(leftFouls)
//            updateUI()
        }
    }
    var rightFouls = 0 {
        didSet {
            right_foul_score_label.text = String(rightFouls)
//            updateUI()
        }
    }

    private func updateUI() {
        if isVisible() == true
        {
            left_foul_view.isHidden = false
            right_foul_view.isHidden = false
        }
        if isVisible() == false
        {
            left_foul_view.isHidden = true
            right_foul_view.isHidden = true
        }
    }
    
    func isVisible() -> Bool
    {
        if leftFouls != 0 || rightFouls != 0
        {
            return true
        }
        if leftFouls == 0 && rightFouls == 0
        {
            return false
        }
        return false
    }
    
    private func setupBorderViews() {
        self.left_foul_view.borderWidth = 1
        self.left_foul_view.borderColor = .red
        
        self.right_foul_view.borderWidth = 1
        self.right_foul_view.borderColor = .red
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setupBorderViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
        setupBorderViews()
    }
    
    func initView() {
        Bundle.main.loadNibNamed("ProtocolAllFooterView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}
