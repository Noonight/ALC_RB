//
//  EventTypeView.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 08/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EventTypeView: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tickerImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var stateVal: Bool = false {
        didSet {
//            self.stateVal = newValue
            self.stateVal ? (tickerImage.isHidden = false) : (tickerImage.isHidden = true)
        }
    }
    var imageVal: UIImage = #imageLiteral(resourceName: "ic_bal") {
        didSet {
            self.image.image = self.imageVal
        }
    }
    var labelVal: String = "" {
        didSet {
//            self.labelVal = newValue
            self.label.text = self.labelVal
        }
    }
    
    @IBOutlet var viewTapper: UITapGestureRecognizer!
    
    func initElement(imageVal: UIImage, labelVal: String) {
        self.imageVal = imageVal
        self.labelVal = labelVal
    }
    
    func setState(newState: Bool) {
        self.stateVal = newState
    }
    
    func getState() -> Bool {
        return stateVal
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.tapAction = tmp
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.tapAction = tmp
        initView()
    }
    
    func initView() {
//        Bundle.main.loadNibNamed(Statics.NIB_NAME, owner: self, options: nil)
        Bundle.main.loadNibNamed("EventTypeView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    }
}
