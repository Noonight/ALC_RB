//
//  UITitleLabelSwitch.swift
//  ALC_RB
//
//  Created by ayur on 30.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class UITitleLabelSwitch: UIView {
    enum Constants {
        static let NIB_NAME = "UITitleLabelSwitch"
    }
    
    @IBOutlet weak var container_view: UIView!
    
    // load from xib/nib
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    // load programmaticly
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Constants.NIB_NAME, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func xibSetUp() {
        // setup the view from .xib
        container_view = loadViewFromNib()
        container_view.frame = self.bounds
        container_view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(container_view)
    }
    
    func setColor(color: UIColor) {
        container_view.backgroundColor = color
    }
}
