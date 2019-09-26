//
//  LoadingRepeatView.swift
//  ALC_RB
//
//  Created by ayur on 26.09.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class LoadingRepeatView: UIView {

    @IBOutlet var container_view: UIView!
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
    @IBOutlet weak var btn: UIButton!
    
    var isLoadingComplete: Bool = false {
        didSet {
            if self.isLoadingComplete == true
            {
                self.activity_indicator.isHidden = true
                self.btn.isHidden = false
            }
            else
            {
                self.activity_indicator.isHidden = false
                self.btn.isHidden = true
            }
        }
        
    }
    
    private var action: (() -> ())?
    
    func configureAction(action: @escaping () -> ()) {
        self.action = action
        self.btn.addTarget(self, action: #selector(doAction), for: .touchUpInside)
    }
    
    @objc private func doAction() {
        if self.action != nil
        {
            self.action!()
        }
    }
    
    private func setupDefault() {
        self.activity_indicator.startAnimating()
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
    
    func initView() {
        Bundle.main.loadNibNamed("LoadingRepeatView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupDefault()
    }
    
}
