//
//  EmptyView.swift
//  ALC_RB
//
//  Created by ayur on 15.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    @IBOutlet var root_view: UIView!
    @IBOutlet var content_view: UIView!
    @IBOutlet var empty_img: UIImageView!
    @IBOutlet var nothing_label: UILabel!
    @IBOutlet var text_label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)
//        content_view.translatesAutoresizingMaskIntoConstraints = false
        root_view.fixInView(self)
    }
    
    func setText(text: String) {
        text_label.text = text
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
