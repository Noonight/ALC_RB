//
//  UserViewController.swift
//  ALC_RB
//
//  Created by user on 29.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class UserLKViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var drawerMenuView: UIView!
    @IBOutlet weak var headerMenuView: UIView!
    @IBOutlet weak var userHeaderMenuImage: UIImageView!
    @IBOutlet weak var userHeaderMenuLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerShadowButton: UIButton!
    
    @IBOutlet weak var drawerLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var barMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var containerView: UIView!
    
    let cellId = "drawer_menu_cell"
    let segueEditProfile = "segue_edit_profile"
    
    var drawerIsOpened = false
    
    var segmentHelper: SegmentHelper?
    
    var authUser: AuthUser?
    
    let presenter = UserLKPresenter()
    
    let userDefaultsHelper = UserDefaultsHelper()
    
    // MARK: - Drawer controllers
    
    private lazy var invitation: InvitationLKTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "InvitationLKTableViewController") as! InvitationLKTableViewController
        
        return viewController
    }()
    
    private lazy var ongoingLeagues: OngoingLeaguesLKTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "OngoingLeaguesLKTableViewController") as! OngoingLeaguesLKTableViewController
        
        return viewController
    }()
    
    private lazy var club: ClubLKViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "ClubLKViewController") as! ClubLKViewController
        
        return viewController
    }()
    
    
    
    private lazy var commands: CommandsLKTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "CommandsLKTableViewController") as! CommandsLKTableViewController
        
        return viewController
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        segmentHelper = SegmentHelper(self, containerView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        authUser = userDefaultsHelper.getAuthorizedUser()
        
        barMenuBtn.image = barMenuBtn.image?.af_imageAspectScaled(toFit: CGSize(width: 24, height: 24))
//        showFirstItem()

        self.userHeaderMenuLabel.text = authUser?.person.getFullName()
        if authUser?.person.photo != nil {
            self.presenter.getProfileImage(imagePath: (authUser?.person.photo!)!)
        } else {
//            self.userHeaderMenuImage.image = UIImage(named: "ic_user")
            self.userHeaderMenuImage.image = UIImage(named: "ic_logo")?.af_imageRoundedIntoCircle()
        }
        
    }
    
    // MARK: - Drawer btn action
    
    @IBAction func drawerHeaderPressed(_ sender: UITapGestureRecognizer) {
        // show EditProfileViewcontroller
    }
    
    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        setDrawerState()
    }

    @IBAction func shadowBtnPressed(_ sender: UIButton) {
        setDrawerState()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueEditProfile,
            let destination = segue.destination as? EditProfileViewController
        {
            destination.authUser = self.authUser
        }
    }
    
    // MARK: - Drawer menu
    
    func showFirstItem() {
        segmentHelper?.add(invitation)
        tableView.selectRow(at: IndexPath.init(row: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.top)
    }
    
    func setDrawerState() {
        if drawerIsOpened {
            drawerLeadingConstraint.constant = -220
            

        } else {
            self.drawerMenuView.layer.shadowOpacity = 0.5
            self.drawerMenuView.layer.shadowRadius = 5
            drawerLeadingConstraint.constant = 0
            
        }
    
        UIView.animate(withDuration: 0.3, animations: {
            if self.drawerIsOpened {
                self.drawerShadowButton.alpha = 0
            } else {
                self.drawerShadowButton.alpha = 0.5
                self.drawerShadowButton.isHidden = false
            }
            self.view.layoutIfNeeded()
        }) { (completed) in
            if self.drawerIsOpened {
                self.drawerMenuView.layer.shadowOpacity = 0
                self.drawerMenuView.layer.shadowRadius = 0
                self.drawerShadowButton.isHidden = true
            } else {
                self.drawerMenuView.layer.shadowOpacity = 0.5
                self.drawerMenuView.layer.shadowRadius = 5
                self.drawerShadowButton.isHidden = false
            }
            self.drawerIsOpened = !self.drawerIsOpened
        }
    }

    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .Invites:
            segmentHelper?.remove(ongoingLeagues)
            segmentHelper?.remove(club)
            segmentHelper?.remove(commands)
            segmentHelper?.add(invitation)
            navigationItem.title = invitation.title
        case .Tournaments:
            segmentHelper?.remove(invitation)
            segmentHelper?.remove(club)
            segmentHelper?.remove(commands)
            segmentHelper?.add(ongoingLeagues)
            navigationItem.title = ongoingLeagues.title
        case .Clubs:
            segmentHelper?.remove(invitation)
            segmentHelper?.remove(ongoingLeagues)
            segmentHelper?.remove(commands)
            segmentHelper?.add(club)
            navigationItem.title = club.title
        case .Teams:
            segmentHelper?.remove(invitation)
            segmentHelper?.remove(ongoingLeagues)
            segmentHelper?.remove(club)
            segmentHelper?.add(commands)
            navigationItem.title = commands.title
        case .SignOut:
            signOut()
        }
        setDrawerState()
    }
    
    func signOut() {
        UserDefaultsHelper().deleteAuthorizedUser()
        replaceUserLKVC()
    }
    
    func replaceUserLKVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AuthNC") as! UINavigationController
        
        let countOfViewControllers = tabBarController?.viewControllers?.count
        //        _ = tabBarController?.selectedViewController
        tabBarController?.viewControllers![countOfViewControllers! - 1] = viewController
    }
}

extension UserLKViewController: UserLKView {
    func getProfileImageSuccessful(image: UIImage) {
        self.userHeaderMenuImage.image = image.af_imageRoundedIntoCircle()
    }
    
    func getProfileImageFailure(error: Error) {
        Print.d(error: error)
        self.userHeaderMenuImage.image = UIImage(named: "ic_user")
    }
    
    func initPresenter() {
        self.presenter.attachView(view: self)
    }
    
    
}

extension UserLKViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DrawerMenuTableViewCell
        
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.image_view.image = menuOption?.image
        cell.name_label.text = menuOption?.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOption(rawValue: indexPath.row)
        didSelectMenuOption(menuOption: menuOption!)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
}
