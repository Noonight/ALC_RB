//
//  ImageWithTextInCenter.swift
//  ALC_RB
//
//  Created by ayur on 24.09.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ImageWithTextInCenter: UIView {

    @IBOutlet var container_view: UIView!
    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var text_label: UILabel!
    
    var width: Int = 45 {
        didSet {
            self.container_view.frame.size = CGSize(width: self.width, height: self.width)
        }
    }
    
    var text: String = "" {
        didSet {
            self.text_label.text = self.text
        }
    }
    
    var textColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            self.text_label.textColor = self.textColor
        }
    }
    
    var backColor: UIColor = .yellow {
        didSet {
            self.image_view.image = createImage(color: self.backColor)
        }
    }
    
    private func createImage(color: UIColor) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: self.width, height: self.width))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.setStrokeColor(color.cgColor)
            ctx.cgContext.setLineWidth(0)
            
            let rectangle = CGRect(x: 0, y: 0, width: self.width, height: self.width)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        return img
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
        Bundle.main.loadNibNamed("ImageWithTextInCenter", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
