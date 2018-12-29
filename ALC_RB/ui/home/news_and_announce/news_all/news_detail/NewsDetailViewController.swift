//
//  NewsDetailViewController.swift
//  ALC_RB
//
//  Created by user on 03.12.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import AlamofireImage

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
        
        //print()
        
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
        
        //prepareImage()
        mImage?.af_setImage(withURL: ApiRoute.getImageURL(image: (content?.cImagePath)!))
    }
    
    func prepareImage() {
        let width = view.frame.width
        print("width is \(width)")
        
        var oldImage: UIImage?
        presenter.getImage(imageName: (content?.cImagePath)!) { image in
            oldImage = image
            let oldWidth = oldImage?.cgImage?.width
            let oldHeight = oldImage?.cgImage?.height
            let newHeight = (Int(oldHeight!) / Int(oldWidth!)) * Int(width)
            print("height is \(newHeight)")
            //self.mImage?.image = oldImage?.af_imageAspectScaled(toFill: CGSize(width: Int(width), height: newHeight))
            //self.mImage?.image = oldImage?.af_imageScaled(to: CGSize(width: Int(width), height: newHeight))
            self.mImage?.image = oldImage?.cgImage?.scaleImageToSize(img: oldImage!, size: CGSize(width: Int(width), height: newHeight))
        }
        //mImage?.image?.af_inflate()
        //mImage?.image?.af_imageAspectScaled(toFit: CGSize(width: view.frame.width, height: view.frame.height))
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
        //presenter.getImage(imageName: cImagePath!)
    }

    
    func onGetImageSuccess(_ image: UIImage) {
        //mImage?.image = image
        
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
