//
//  UserViewController.swift
//  ALC_RB
//
//  Created by user on 29.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Kingfisher

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
    var menuHelper: MenuHelper?
    
    var authUser: AuthUser?
    
    let presenter = UserLKPresenter()
    
    let userDefaultsHelper = UserDefaultsHelper()
    
    var firstInit = true
    
    // MARK: - Drawer controllers
    
    private lazy var invitation: InvitationLKTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "InvitationLKTableViewController") as! InvitationLKTableViewController
        
        return viewController
    }()
    
//    private lazy var ongoingLeagues: OngoingLeaguesLKTableViewController = {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//
//        var viewController = storyboard.instantiateViewController(withIdentifier: "OngoingLeaguesLKTableViewController") as! OngoingLeaguesLKTableViewController
//
//        return viewController
//    }()
    private lazy var ongoingLeagues = TourneyWebViewVC()
    
    private lazy var club: ClubLKViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "ClubLKViewController") as! ClubLKViewController
        
        return viewController
    }()
    
    
    
    private lazy var commands: TeamsLKTVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "CommandsLKTableViewController") as! TeamsLKTVC
        
        return viewController
    }()
    
    private lazy var schedule: ScheduleRefTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "ScheduleRefTableViewController") as! ScheduleRefTableViewController
        
        return viewController
    }()
    
    private lazy var referees: RefereesLKTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "RefereesLKTableViewController") as! RefereesLKTableViewController
        
        return viewController
    }()
    
    private lazy var myMatches: MyMatchesRefTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "MyMatchesRefTableViewController") as! MyMatchesRefTableViewController
        
        return viewController
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        segmentHelper = SegmentHelper(self, containerView)
        menuHelper = MenuHelper()
        
        menuHelper?.playerMenuOptionActions = playerSelectMenuOption(menuOption:)
        menuHelper?.refereeMenuOptionActions = refereeSelectMenuOption(menuOption:)
        menuHelper?.mainRefereeMenuOptionActions = mainRefereeMenuOption(menuOption:)
        
        tableView.delegate = menuHelper
        tableView.dataSource = menuHelper
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        authUser = userDefaultsHelper.getAuthorizedUser()
        self.presenter.refreshUser(token: userDefaultsHelper.getAuthorizedUser()!.token)
        
        
//        menuHelper?.userType = authUser?.person.getUserType()
        
        barMenuBtn.image = barMenuBtn.image?.af_imageAspectScaled(toFit: CGSize(width: 24, height: 24))
//        showFirstItem()

        self.userHeaderMenuLabel.text = authUser?.person.getFullName()
//        if authUser?.person.photo != nil {
//            self.presenter.getProfileImage(imagePath: (authUser?.person.photo!)!)
//        } else {
////            self.userHeaderMenuImage.image = UIImage(named: "ic_user")
//            self.userHeaderMenuImage.image = UIImage(named: "ic_logo")?.af_imageRoundedIntoCircle()
//        }
//        if let image = authUser?.person.photo {
//            let url = ApiRoute.getImageURL(image: image)
//            let processor = CroppingImageProcessorCustom(size: self.userHeaderMenuImage.frame.size)
//                .append(another: RoundCornerImageProcessor(cornerRadius: self.userHeaderMenuImage.getHalfWidthHeight()))
//
//            self.userHeaderMenuImage.kf.indicatorType = .activity
//            self.userHeaderMenuImage.kf.setImage(
//                with: url,
//                placeholder: UIImage(named: "ic_logo"),
//                options: [
//                    .processor(processor),
//                    .scaleFactor(UIScreen.main.scale)//,
////                    .transition(.fade(1))//,
////                    .cacheOriginalImage
//                ])
//        }
        if let imagePath = authUser?.person.photo {
            self.userHeaderMenuImage.kfLoadRoundedImage(path: imagePath, placeholder: #imageLiteral(resourceName: "ic_account2"))
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if firstInit {
            showFirstItem()
            firstInit = false
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
//            destination.authUser = self.authUser
            // MARK: TODO CHECK IT 
        }
    }
    
    // MARK: - Drawer menu
    
    func showFirstItem() {
        // MARK: TODO: user type is deprecated
//        if authUser?.person.getUserType() == Person.TypeOfPerson.player {
//            segmentHelper?.add(invitation)
//            navigationItem.title = invitation.title
//        } else if authUser?.person.getUserType() == Person.TypeOfPerson.referee {
//            segmentHelper?.add(myMatches)
//            navigationItem.title = myMatches.title
//        } else if authUser?.person.getUserType() == Person.TypeOfPerson.mainReferee {
//            segmentHelper?.add(schedule)
//            navigationItem.title = schedule.title
//        }
        // set pointer of choose at first item that equal first item in person's menu
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

    func playerSelectMenuOption(menuOption: PlayerMenuOption) {
        switch menuOption {
        case .Invites:
            segmentHelper?.remove(ongoingLeagues)
            segmentHelper?.remove(club)
            segmentHelper?.remove(commands)
            segmentHelper?.add(invitation)
            navigationItem.title = invitation.title
        case .Tourneys:
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
//        case .Referees:
//            segmentHelper?.remove(invitation)
//            segmentHelper?.remove(ongoingLeagues)
//            segmentHelper?.remove(club)
//            segmentHelper?.remove(commands)
//            segmentHelper?.add(referees)
//            navigationItem.title = referees.title
        case .SignOut:
            signOut()
        }
        setDrawerState()
    }
    
    func refereeSelectMenuOption(menuOption: RefereeMenuOption) {
        switch menuOption {
        case .MyMatches:
//            segmentHelper?.remove(referees)
            // shedule
            segmentHelper?.add(myMatches)
            navigationItem.title = myMatches.title
//            Print.m("Schedule")
        case .SignOut:
            signOut()
        }
        setDrawerState()
    }
    
    func mainRefereeMenuOption(menuOption: MainRefereeMenuOption) {
        switch menuOption {
        case .Schedule:
            segmentHelper?.remove(referees)
            segmentHelper?.remove(myMatches)
            segmentHelper?.add(schedule)
            navigationItem.title = schedule.title
        case .MyMatches:
            segmentHelper?.remove(referees)
            segmentHelper?.remove(schedule)
            segmentHelper?.add(myMatches)
            navigationItem.title = myMatches.title
        case .Referees:
            segmentHelper?.remove(myMatches)
            segmentHelper?.remove(schedule)
            segmentHelper?.add(referees)
            navigationItem.title = referees.title
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
// MARK: - Presenter
extension UserLKViewController: UserLKView {
    func onRefreshUserSuccessful(authUser: AuthUser) {
        userDefaultsHelper.setAuthorizedUser(user: authUser)
        self.authUser = userDefaultsHelper.getAuthorizedUser()
    }
    
    func onRefreshUserFailure(authUser: Error) {
        Print.m(authUser)
//        showAlert(message: authUser.localizedDescription)
    }
    
//    func fetchRefereesSuccess(referees: Players) {
////        self.referees = referees
//    }
//    
//    func fetchRefereesFailure(error: Error) {
//        Print.m("referees")
//    }
    
//    func getProfileImageSuccessful(image: UIImage) {
//        self.userHeaderMenuImage.image = image.af_imageRoundedIntoCircle()
//    }
//
//    func getProfileImageFailure(error: Error) {
//        Print.d(error: error)
//        self.userHeaderMenuImage.image = UIImage(named: "ic_user")
//    }
    
    func initPresenter() {
        self.presenter.attachView(view: self)
    }
}

//extension UserLKViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DrawerMenuTableViewCell
//
//        let menuOption = PlayerMenuOption(rawValue: indexPath.row)
//        cell.image_view.image = menuOption?.image
//        cell.name_label.text = menuOption?.description
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let menuOption = PlayerMenuOption(rawValue: indexPath.row)
//        didSelectMenuOption(menuOption: menuOption!)
////        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
