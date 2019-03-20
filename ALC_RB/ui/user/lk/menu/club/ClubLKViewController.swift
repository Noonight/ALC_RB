//
//  ClubLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 19.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ClubLKViewController: UIViewController {

    // MARK: - Variables
    
    @IBOutlet weak var commandLogo_image: UIImageView!
    @IBOutlet weak var commandTitle_label: UILabel!
    @IBOutlet weak var commandDescription_label: UITextView!
    @IBOutlet weak var settingBarBtn: UIBarButtonItem!
    
    let segueId = "segue_editClub"
    
    let presenter = ClubLKPresenter()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        settingBarBtn.image = settingBarBtn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueId,
            let destination = segue.destination as? ClubDetailViewController
        {
            destination.content = ClubDetailContent(
                image: (tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! ClubTableViewCell).mImage.image!,
                title: clubs.clubs[cellIndex].name,
                owner: clubs.clubs[cellIndex].owner.surname,
                text: clubs.clubs[cellIndex].info)
        }
    }
}

extension ClubLKViewController: ClubLKView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
