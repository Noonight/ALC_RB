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
    @IBOutlet weak var content_view: UIView!
    @IBOutlet weak var empty_img: UIImageView!
    @IBOutlet weak var nothing_label: UILabel!
    @IBOutlet weak var text_label: UILabel!
    
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
        root_view.frame = self.frame
        addSubview(content_view)
//        content_view.setCenterFromParent()
        //content_view.frame = self.bounds
        //content_view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
