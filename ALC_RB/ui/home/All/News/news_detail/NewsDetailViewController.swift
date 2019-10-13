//
//  NewsDetailViewController.swift
//  ALC_RB
//
//  Created by user on 03.12.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Kingfisher
import Lightbox

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mDate: UILabel!
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var newsModelItem: NewsModelItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mImage.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleBottomMargin.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleRightMargin.rawValue | UIView.AutoresizingMask.flexibleLeftMargin.rawValue | UIView.AutoresizingMask.flexibleTopMargin.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        mImage!.contentMode = UIView.ContentMode.scaleAspectFill
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshUI()
    }
    
    func refreshUI() {
        self.mTitle.text = newsModelItem?.caption
        self.title = newsModelItem?.updatedAt
        self.mText.text = newsModelItem?.content
        guard let imagePath = newsModelItem?.imagePath else { return }
        self.mImage.kfLoadImage(path: imagePath) { result in
            switch result {
            case .success(let image):
//                self.imageHeight.constant = image.size.height
//                self.containerView.layoutIfNeeded()
                self.mImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
                self.mImage.isUserInteractionEnabled = true
            case .failure(let error):
                Print.m(error)
            }
        }
    }
    
    @objc func imageTap() {
        let images = [LightboxImage(image: mImage.image!)]
        let controller = LightboxController(images: images)
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
    }
}
