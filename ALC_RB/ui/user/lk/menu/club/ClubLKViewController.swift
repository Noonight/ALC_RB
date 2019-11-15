//
//  ClubLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 19.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

class ClubLKViewController: BaseStateViewController {

    // MARK: - Variables
    
    @IBOutlet weak var commandLogo_image: UIImageView!
    @IBOutlet weak var commandTitle_label: UILabel!
    @IBOutlet weak var commandDescription_label: UITextView!
    @IBOutlet weak var settingBarBtn: UIBarButtonItem!
    @IBOutlet weak var addBarBtn: UIBarButtonItem!
    
    let segueId = "segue_editClub"
    
    let presenter = ClubLKPresenter()
    
    let userDefaults = UserDefaultsHelper()
    
    var club: Club?
    var clubs: [Club]?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
        setEmptyMessage(message: "Вы пока не состоите ни в одном клубе")
        navigationController?.navigationBar.topItem?.rightBarButtonItems = [addBarBtn, settingBarBtn]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter.getClubs()
        if navigationController?.navigationBar.topItem?.rightBarButtonItems?.count != 2 {
            navigationController?.navigationBar.topItem?.rightBarButtonItems = [addBarBtn, settingBarBtn]
        }
//        navigationController?.navigationBar.topItem?.rightBarButtonItem = settingBarBtn
        settingBarBtn.image = settingBarBtn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        updateUI()
//        setState(state: .loading)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.updateUI()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.topItem?.rightBarButtonItems = nil
    }
    
//    func updateUI() {
//        updateNavBar()
//        if club != nil {
//            setState(state: .normal)
//            presenter.getImage(imagePath: club!.logo)
//            commandTitle_label.text = club!.name
//            commandDescription_label.text = club!.info
//        } else {
//            setState(state: .empty)
//        }
//    }
    
    func updateNavBar() {
        if club != nil {
            settingBarBtn.isEnabled = true
            addBarBtn.isEnabled = false
        } else {
            settingBarBtn.isEnabled = false
            addBarBtn.isEnabled = true
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueId,
            let destination = segue.destination as? ClubEditLKViewController
        {
            destination.club = club
        }
    }
}

extension ClubLKViewController: ClubLKView {
    func getClubImageSuccess(image: UIImage) {
        self.commandLogo_image.image = image.af_imageRoundedIntoCircle()
    }
    
    func getClubImageFailure(error: Error) {
        Print.d(error: error)
    }
    
    func getClubsSuccess(clubs: [Club]) {
        self.clubs = clubs
        let club = clubs.clubs.filter { (club) -> Bool in
            return club.id == userDefaults.getAuthorizedUser()?.person.club
        }.first
        if let club = club {
            self.club = club
            self.setState(state: .normal)
            updateNavBar()
            
            presenter.getImage(imagePath: club.logo ?? "")
//            if let image = club.logo {
//                let url = ApiRoute.getImageURL(image: image)
//                let processor = CroppingImageProcessorCustom(size: self.commandLogo_image.frame.size)
//                    .append(another: RoundCornerImageProcessor(cornerRadius: self.commandLogo_image.getHalfWidthHeight()))
//
//                self.commandLogo_image.kf.indicatorType = .activity
//                self.commandLogo_image.kf.setImage(
//                    with: url,
//                    placeholder: UIImage(named: "ic_con"),
//                    options: [
//                        .processor(processor),
//                        .scaleFactor(UIScreen.main.scale),
//                        .transition(.fade(1)),
//                        .cacheOriginalImage
//                    ])
//            }
            commandTitle_label.text = club.name
            commandDescription_label.text = club.info
            
//            self.updateNavBar()
        } else {
            self.setState(state: .empty)
            updateNavBar()
        }
        
    }
    
    func getClubsFailure(error: Error) {
        Print.d(error: error)
//        showToast(message: "Клуб не найден")
        showRefreshAlert(message: error.localizedDescription) {
            self.presenter.getClubs()
        }
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
    }
}
