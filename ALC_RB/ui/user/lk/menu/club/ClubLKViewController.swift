//
//  ClubLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 19.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ClubLKViewController: BaseStateViewController {

    // MARK: - Variables
    
    @IBOutlet weak var commandLogo_image: UIImageView!
    @IBOutlet weak var commandTitle_label: UILabel!
    @IBOutlet weak var commandDescription_label: UITextView!
    @IBOutlet weak var settingBarBtn: UIBarButtonItem!
    
    let segueId = "segue_editClub"
    
    let presenter = ClubLKPresenter()
    
    let userDefaults = UserDefaultsHelper()
    
    var club: Club? {
        didSet {
            updateUI()
        }
    }
    var clubs: Clubs?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
        setEmptyMessage(message: "Вы пока не состоите ни в одном клубе")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter.getClubs()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = settingBarBtn
        settingBarBtn.image = settingBarBtn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        updateUI()
        setState(state: .loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.updateUI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    func updateUI() {
        if club != nil {
            setState(state: .normal)
            presenter.getImage(imagePath: club!.logo)
            commandTitle_label.text = club!.name
            commandDescription_label.text = club!.info
        } else {
            setState(state: .empty)
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
    
    func getClubsSuccess(clubs: Clubs) {
        self.clubs = clubs
        let club = clubs.clubs.filter { (club) -> Bool in
            return club.id == userDefaults.getAuthorizedUser()?.person.club
        }.first
        if let club = club {
            self.club = club
        }
        
    }
    
    func getClubsFailure(error: Error) {
        Print.d(error: error)
        showToast(message: "Клуб не найден")
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
    }
}