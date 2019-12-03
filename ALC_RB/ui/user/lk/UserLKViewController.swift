//
//  UserViewController.swift
//  ALC_RB
//
//  Created by user on 29.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

protocol RefreshUserProtocol {
    func refresh(closure: @escaping (AuthUser) -> ())
}

class UserLKViewController: UIViewController {

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
    
    let segueEditProfile = "segue_edit_profile"
    
    var drawerIsOpened = false
    
    var segmentHelper: SegmentHelper?
    var menuTable: MenuTable?
    
    var authUser: AuthUser?
    
    let presenter = UserLKPresenter()
    
    let userDefaultsHelper = UserDefaultsHelper()
    
    var firstInit = true
    
    private let bag = DisposeBag()
    
    // MARK: - Drawer controllers
    
    private lazy var invitation: InvitationLKTVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "InvitationLKTableViewController") as! InvitationLKTVC
        
        return viewController
    }()
    
    private lazy var ongoingLeagues = TourneyWebViewVC()
    
//    private lazy var club: ClubLKViewController = {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//
//        var viewController = storyboard.instantiateViewController(withIdentifier: "ClubLKViewController") as! ClubLKViewController
//
//        return viewController
//    }()
    
    private lazy var commands: TeamsLKTVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "CommandsLKTableViewController") as! TeamsLKTVC
        
        return viewController
    }()
    
    private lazy var schedule: ScheduleTVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "ScheduleRefTableViewController") as! ScheduleTVC
        
        return viewController
    }()
    
    private lazy var referees: RefereesLKTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "RefereesLKTableViewController") as! RefereesLKTableViewController
        
        return viewController
    }()
    
    private lazy var myMatches: MyMatchesTVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "MyMatchesRefTableViewController") as! MyMatchesTVC
        
        return viewController
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        segmentHelper = SegmentHelper(self, containerView)
        menuTable = MenuTable(menu: [
            MenuGroupModel(title: "Игрок", items: [.invites, .tourneys, .teams]),
            MenuGroupModel(title: "Выход", items: [.signOut])
        ])
        
        menuTable?.userMenuOptionActions = userSelectMenuOption(menuOption:)
        
        bindViews()
        
        tableView.delegate = menuTable
        tableView.dataSource = menuTable
        
        self.presenter.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.presenter.refreshUser(token: userDefaultsHelper.getAuthorizedUser()!.token)
        
        barMenuBtn.image = barMenuBtn.image?.af_imageAspectScaled(toFit: CGSize(width: 24, height: 24))

        self.userHeaderMenuLabel.text = authUser?.person.getFullName()

        if let imagePath = authUser?.person.photo {
            self.userHeaderMenuImage.kfLoadRoundedImage(path: imagePath, placeholder: #imageLiteral(resourceName: "ic_account2"))
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        if firstInit {
//            showFirstItem()
//            firstInit = false
//        }
    }
    
}

// MARK: - SETUP

extension UserLKViewController {
    
    func bindViews() {
        
        self.presenter
            .menuItems
            .observeOn(MainScheduler.instance)
            .subscribe { elements in
                guard let menu = elements.element else { return }
                Print.m(menu)
                self.menuTable?.menu = menu
                self.tableView.reloadData()
                if self.firstInit {
                    self.showFirstItem()
                    self.firstInit = false
                }
            }.disposed(by: bag)
        
    }
    
}

// MARK: - ACTIONS

extension UserLKViewController {
    
    @IBAction func drawerHeaderPressed(_ sender: UITapGestureRecognizer) {
        // show EditProfileViewcontroller
    }
    
    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        setDrawerState()
    }
    
    @IBAction func shadowBtnPressed(_ sender: UIButton) {
        setDrawerState()
    }
}

// MARK: - Drawer menu

extension UserLKViewController {
    
    func showFirstItem() {
        segmentHelper?.add(invitation)
        navigationItem.title = invitation.title
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
    
    func userSelectMenuOption(menuOption: UserMenuOption) {
        switch menuOption {
        case .invites:
            segmentHelper?.removeAll()
            segmentHelper?.add(invitation)
            navigationItem.title = invitation.title
        case .tourneys:
            segmentHelper?.removeAll()
            segmentHelper?.add(ongoingLeagues)
            navigationItem.title = ongoingLeagues.title
        case .teams:
            segmentHelper?.removeAll()
            segmentHelper?.add(commands)
            navigationItem.title = commands.title
        case .schedule:
            segmentHelper?.removeAll()
            segmentHelper?.add(schedule)
            navigationItem.title = schedule.title
        case .myMatches:
            segmentHelper?.removeAll()
            segmentHelper?.add(myMatches)
            navigationItem.title = myMatches.title
        case .signOut:
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
        
        tabBarController?.viewControllers![countOfViewControllers! - 1] = viewController
    }
    
}

// MARK: - RefreshUser

extension UserLKViewController: RefreshUserProtocol {
    func refresh(closure: @escaping (AuthUser) -> ()) {
        self.presenter.refreshUser { result in
            switch result {
            case .success(let authorizedUser):
                closure(authorizedUser)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
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
    }
    
    func initPresenter() {
        self.presenter.attachView(view: self)
    }
}
