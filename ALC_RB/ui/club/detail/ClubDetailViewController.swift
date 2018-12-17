//
//  ClubDetailViewController.swift
//  ALC_RB
//
//  Created by user on 17.12.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

struct ClubDetailContent {
    var cImage = UIImage(named: "ic_con")
    var cTitle = String()
    var cOwner = String()
    var cText = String()
    
    init(image: UIImage, title: String, owner: String, text: String) {
        self.cImage = image
        self.cTitle = title
        self.cOwner = owner
        self.cText = text
    }
}

class ClubDetailViewController: UIViewController {

    @IBOutlet weak var mImage: UIImageView?
    @IBOutlet weak var mTitle: UILabel?
    @IBOutlet weak var mOwner: UILabel?
    @IBOutlet weak var mText: UITextView?
    
    let presenter = ClubDetailPrersenter()
    
    var content: ClubDetailContent? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
    func updateUI() {
        mImage?.image = content?.cImage
        mTitle?.text = content?.cTitle
        mOwner?.text = content?.cOwner
        mText?.text = content?.cText
    }
}

extension ClubDetailViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
