//
//  ClubDetailViewController.swift
//  ALC_RB
//
//  Created by user on 17.12.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Lightbox

struct ClubDetailContent {
    var cImage = UIImage(named: "ic_con")
    var cTitle = String()
    var cOwner = String()
    var cText = String()
    
    init(image: UIImage?, title: String, owner: String, text: String) {
        if let mImage = image {
            self.cImage = mImage
        }
        self.cTitle = title
        self.cOwner = owner
        self.cText = text
    }
}

class ClubDetailViewController: UIViewController {

    @IBOutlet weak var mImage: UIImageView!
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
        initLightBox()
//        debugPrint(navigationController?.navigationBar ?? "no")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
    func initLightBox() {
        self.mImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap)))
        self.mImage.isUserInteractionEnabled = true
    }
    
    @objc func imageTap() {
        let images = [LightboxImage(image: self.mImage.image!)]
        let controller = LightboxController(images: images)
        controller.dynamicBackground = true
        
        present(controller, animated: true, completion: nil)
    }
    
    func updateUI() {
        DispatchQueue.main.async {
//            self.mImage.layer.cornerRadius = self.mImage.frame.size.width / 2
//            self.mImage.clipsToBounds = true
            self.mImage.image = self.content?.cImage
            self.mImage?.cropAndRound()
            self.mTitle?.text = self.content?.cTitle
            self.mOwner?.text = self.content?.cOwner
            self.mText?.text = self.content?.cText
        }
    }
}

extension ClubDetailViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
