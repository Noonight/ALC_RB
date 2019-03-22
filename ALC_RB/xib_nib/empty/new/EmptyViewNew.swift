//
//  EmptyView.swift
//  ALC_RB
//
//  Created by ayur on 15.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EmptyViewNew: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        Bundle.main.loadNibNamed("EmptyViewNew", owner: self, options: nil)
        //        content_view.translatesAutoresizingMaskIntoConstraints = false
        containerView.fixInView(self)
    }
    
    func setText(text: String) {
        textLabel.text = text
    }
}
