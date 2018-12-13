//
//  NewsDetailViewController.swift
//  ALC_RB
//
//  Created by user on 03.12.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController, MvpView {

    @IBOutlet weak var mTitle: UILabel?
    @IBOutlet weak var mDate: UILabel?
    @IBOutlet weak var mImage: UIImageView?
    @IBOutlet weak var mText: UITextView?
    
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
    
//    var cTitle: String? = String()
//    var cDate: String? = String()
//    var cText: String? = String()
//    var cImagePath: String? = String()
    
    private let presenter = NewsDetailPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print()
        
        initPresenter()
        
        //mImage?.frame.minX = 0
        //mImage?.frame.midY = 0
        //mImage?.image
    }

    func refreshUI() {
        mTitle?.text = content?.cTitle
        mDate?.text = content?.cDate
        mText?.text = content?.cText
        presenter.getImage(imageName: (content?.cImagePath)!)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
        //presenter.getImage(imageName: cImagePath!)
    }

    
    func onGetImageSuccess(_ image: UIImage) {
        mImage?.image = image
        //mImage.st
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshUI()
//        mTitle?.text = cTitle
//        mDate?.text = cDate
//        //mImage.image = cImage
//        mText?.text = cText

    }
}
