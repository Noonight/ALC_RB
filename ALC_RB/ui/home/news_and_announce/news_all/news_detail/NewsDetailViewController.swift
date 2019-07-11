//
//  NewsDetailViewController.swift
//  ALC_RB
//
//  Created by user on 03.12.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import AlamofireImage
import Lightbox

class NewsDetailViewController: UIViewController, MvpView {

    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mDate: UILabel!
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    struct NewsDetailContent {
        var cTitle: String? = String()
        var cDate: String? = String()
        var cText: String? = String()
        var cImagePath: String? = String()
        
        init(title: String, date: String, content: String, imagePath: String) {
            cTitle = title
            cDate = date
            cText = content
            cImagePath = imagePath
        }
    }
    
    var content: NewsDetailContent? {
        didSet {
            refreshUI()
        }
    }
    
    private let presenter = NewsDetailPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        mImage.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleBottomMargin.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleRightMargin.rawValue | UIView.AutoresizingMask.flexibleLeftMargin.rawValue | UIView.AutoresizingMask.flexibleTopMargin.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        mImage!.contentMode = UIView.ContentMode.scaleAspectFit
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshUI()
    }
    
    func refreshUI() {
        mTitle?.text = content?.cTitle
        mDate?.text = content?.cDate
        mText?.text = content?.cText
        presenter.getImage(imageName: (content?.cImagePath)!)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
    
    func onGetImageSuccess(_ image: UIImage) {
        mImage?.image = image
        imageHeight.constant = image.size.height
        containerView.layoutIfNeeded()
        mImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap)))
        mImage.isUserInteractionEnabled = true
    }
    
    @objc func imageTap() {
        let images = [LightboxImage(image: mImage.image!)]
        let controller = LightboxController(images: images)
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
    }
}
