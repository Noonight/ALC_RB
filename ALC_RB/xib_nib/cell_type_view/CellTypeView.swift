//
//  CellTypeView.swift
//  ALC_RB
//
//  Created by ayur on 11.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CellTypeView: UIView {

    @IBOutlet weak var container_view: UIView!
    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
    
    var type: CellType = .none {
        didSet {
            Print.m("new cell type is \(type)")
            configureView()
        }
    }
    
    private func configureView() {
        switch type {
        case .none:
            image_view.isHidden = true
            image_view.image = nil
            activity_indicator.isHidden = true
        case .checkmark:
            image_view.isHidden = false
            image_view.image = #imageLiteral(resourceName: "hud_checkmark")
            activity_indicator.isHidden = true
        case .loading:
            activity_indicator.startAnimating()
            image_view.isHidden = true
            image_view.image = nil
            activity_indicator.isHidden = false
        }
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
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
        Bundle.main.loadNibNamed("CellTypeView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}
