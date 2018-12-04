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
    
    var cTitle: String? = String()
    var cDate: String? = String()
    //var cImage = UII
    var cText: String? = String()
    
    var cImageText: String? = ""
    
    private let presenter = NewsDetailPresenter()
    
    override func viewDidLoad() {`
        super.viewDidLoad()
        
        initPresenter()
        initView()
    }

    func initPresenter() {
        presenter.attachView(view: self)
        
        presenter.getImage(imageName: cImageText!)
    }

    func initView() {

    }
    
    func onGetImageSuccess(_ image: UIImage) {
        mImage?.image = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mTitle?.text = cTitle
        mDate?.text = cDate
        //mImage.image = cImage
        mText?.text = cText

    }
}
