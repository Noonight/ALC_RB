//
//  AdView.swift
//  ALC_RB
//
//  Created by ayur on 28.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
class AdView: UIView {

    @IBOutlet var container_view: UIView!
    @IBOutlet weak var advertisingText: UILabel!
    @IBOutlet weak var advertisingImage: UIImageView!
    
    var closeFunction : (() -> ())?
    
    func setAdText(ad text: String) {
        advertisingText.text = text
    }
    
    @IBAction func onExitBtnPressed(_ sender: UIButton) {
        if let closeFunction = closeFunction {
            closeFunction()
        }
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
        Bundle.main.loadNibNamed("AdView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
