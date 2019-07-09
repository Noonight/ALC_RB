//
//  AddEventsProtocolViewController.swift
//  ALC_RB
//
//  Created by ayur on 07.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class AddEventsProtocolViewController: BaseStateViewController {
    enum Images {
        static let eventGoal = #imageLiteral(resourceName: "ic_con")
        static let eventYellowCard = #imageLiteral(resourceName: "ic_yellow_card")
        static let eventRedCard = #imageLiteral(resourceName: "ic_red_card")
        static let eventFoul = #imageLiteral(resourceName: "ic_faul")
        static let eventAutoGoal = #imageLiteral(resourceName: "ic_goal")
        static let eventPenalty = #imageLiteral(resourceName: "ic_penalty")
    }
    enum Texts {
        static let eventGoal = "Гол"
        static let eventYellowCard = "ЖК"
        static let eventRedCard = "КК"
        static let eventFoul = "Фол"
        static let eventAutoGoal = "Автогол"
        static let eventPenalty = "Пенальти"
        
        static let DEFAULT_TEAM_BTN = "Обе команды"
        static let DEFAULT_PLAYER_BTN = "Игрок"
    }
    
    @IBOutlet weak var saveBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var eventGol: EventTypeView!
    @IBOutlet weak var eventYellowCard: EventTypeView!
    @IBOutlet weak var eventRedCard: EventTypeView!
    @IBOutlet weak var eventFol: EventTypeView!
    @IBOutlet weak var eventAutoGoal: EventTypeView!
    @IBOutlet weak var eventPenalty: EventTypeView!
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var teamBtn: UIButton!
    @IBOutlet weak var playerBtn: UIButton!
    
    let presenter = AddEventsProtocolPresenter()
    
    // MARK: - Vars
    var model: MyMatchesRefTableViewCell.CellModel!
    var teamOneController: ProtocolPlayersController!
    var teamTwoController: ProtocolPlayersController!
    
    var fetchedTeamOnePlayers: [GetPerson.Person]?
    var fetchedTeamTwoPlayers: [GetPerson.Person]?
    
    // MARK: - model controllers
    var eventsController: ProtocolEventsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareEvents()

        fetchTeamOnePersons()
        fetchTeamTwoPersons()
        self.setState(state: .normal)
    }
    
    // MARK: - Actions
    @IBAction func onCommandBtnPressed(_ sender: UIButton) {
        showTeamPicker(sender: sender)
    }
    
    @IBAction func onPlayerBtnPressed(_ sender: UIButton) {
        showPlayerPicker(sender: sender)
    }
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
//        showAlert(message: getEventType().rawValue)
        Print.m(getEventType().rawValue)
        Print.m(timeTextField.text)
//        Print.m(<#T##m: Any##Any#>)
        if isCorrectPlayer() {
            Print.m(findPlayerId(playerFullName: (playerBtn.titleLabel?.text)!))
        }
    }
    
    @objc func eventTap(_ sender: UITapGestureRecognizer) {
        if sender.hash == eventGol.viewTapper.hash {
            setEvent(eventGol)
        }
        if sender.hash == eventYellowCard.viewTapper.hash {
            setEvent(eventYellowCard)
        }
        if sender.hash == eventRedCard.viewTapper.hash {
            setEvent(eventRedCard)
        }
        if sender.hash == eventFol.viewTapper.hash {
            setEvent(eventFol)
        }
        if sender.hash == eventAutoGoal.viewTapper.hash {
            setEvent(eventAutoGoal)
        }
        if sender.hash == eventPenalty.viewTapper.hash {
            setEvent(eventPenalty)
        }
    }
    
    // MARK: - Helpers
    
    func fetchTeamOnePersons() {
        self.setState(state: .loading)
        presenter.fetchPersons(persons: teamOneController.players.map({ liPlayer -> String in
            return liPlayer.playerId
        }), closure: { persons in
            self.fetchedTeamOnePlayers = persons
        }, failure: { error in
            Print.m(error)
        })
    }
    
    func fetchTeamTwoPersons() {
        self.setState(state: .loading)
        presenter.fetchPersons(persons: teamTwoController.players.map({ liPlayer -> String in
            return liPlayer.playerId
        }), closure: { persons in
            self.fetchedTeamTwoPlayers = persons
        }, failure: { error in
            Print.m(error)
        })
    }
    
    func setEvent(_ sender: EventTypeView) {
        eventGol.setState(newState: false)
        eventYellowCard.setState(newState: false)
        eventRedCard.setState(newState: false)
        eventFol.setState(newState: false)
        eventAutoGoal.setState(newState: false)
        eventPenalty.setState(newState: false)
        if sender.tag == eventGol.tag {
            eventGol.setState(newState: true)
            return
        }
        if sender.tag == eventYellowCard.tag {
            eventYellowCard.setState(newState: true)
            return
        }
        if sender.tag == eventRedCard.tag {
            eventRedCard.setState(newState: true)
            return
        }
        if sender.tag == eventFol.tag {
            eventFol.setState(newState: true)
            return
        }
        if sender.tag == eventAutoGoal.tag {
            eventAutoGoal.setState(newState: true)
            return
        }
        if sender.tag == eventPenalty.tag {
            eventPenalty.setState(newState: true)
            return
        }
    }
    
    func getEventType() -> LIEvent.EventType {
        func eventState(view: EventTypeView) -> Bool {
            return view.getState()
        }
        if eventState(view: eventGol) {
            return LIEvent.EventType.goal
        }
        if eventState(view: eventYellowCard) {
            return LIEvent.EventType.yellowCard
        }
        if eventState(view: eventRedCard) {
            return LIEvent.EventType.redCard
        }
        if eventState(view: eventFol) {
            return LIEvent.EventType.foul
        }
        if eventState(view: eventAutoGoal) {
            return LIEvent.EventType.autoGoal
        }
        if eventState(view: eventPenalty) {
            return LIEvent.EventType.penalty
        }
        return LIEvent.EventType.non
    }
    
    func showTeamPicker(sender: UIButton) {
        let acp = ActionSheetStringPicker(title: "", rows: [model.team1Name!, model.team2Name!], initialSelection: 0, doneBlock: { (picker, index, value) in
            self.teamBtn.setTitle(value as? String, for: .normal)
        }, cancel: { (picker) in
            self.teamBtn.setTitle(Texts.DEFAULT_TEAM_BTN, for: .normal)
        }, origin: sender)
        
        acp?.show()
    }

    func showPlayerPicker(sender: UIButton) {

        // default team, both players
        if teamBtn.titleLabel?.text == Texts.DEFAULT_TEAM_BTN {
            let acp = ActionSheetStringPicker(title: "", rows: getFullNamePlayers(persons: filterFullNamePlayers(persons: connectTeamOneAndTeamTwoPlayers())), initialSelection: 0, doneBlock: { (picker, index, value) in
                self.playerBtn.setTitle(value as? String, for: .normal)
            }, cancel: { (picker) in
                self.playerBtn.setTitle(Texts.DEFAULT_PLAYER_BTN, for: .normal)
            }, origin: sender)
            acp?.show()
        } else if teamBtn.titleLabel?.text == model.team1Name {
            let acp = ActionSheetStringPicker(title: "", rows: getFullNamePlayers(persons: filterFullNamePlayers(persons: fetchedTeamOnePlayers!)), initialSelection: 0, doneBlock: { (picker, index, value) in
                self.playerBtn.setTitle(value as? String, for: .normal)
            }, cancel: { (picker) in
                self.playerBtn.setTitle(Texts.DEFAULT_PLAYER_BTN, for: .normal)
            }, origin: sender)
            acp?.show()
        } else if teamBtn.titleLabel?.text == model.team2Name {
            let acp = ActionSheetStringPicker(title: "", rows: getFullNamePlayers(persons: filterFullNamePlayers(persons: fetchedTeamTwoPlayers!)), initialSelection: 0, doneBlock: { (picker, index, value) in
                self.playerBtn.setTitle(value as? String, for: .normal)
            }, cancel: { (picker) in
                self.playerBtn.setTitle(Texts.DEFAULT_PLAYER_BTN, for: .normal)
            }, origin: sender)
            acp?.show()
        }
    }
    
    func isCorrectPlayer() -> Bool {
        if playerBtn.titleLabel?.text != Texts.DEFAULT_PLAYER_BTN {
            if findPlayerId(playerFullName: (playerBtn.titleLabel?.text)!) != nil {
                return true
            }
        }
        return false
    }
    
    func findPlayerId(playerFullName: String) -> String? {
        return connectTeamOneAndTeamTwoPlayers().filter({ getPerson -> Bool in
            return getPerson.getFullName() == playerFullName
        }).first?.id
    }
    
    func getFullNamePlayers(persons: [GetPerson.Person]) -> [String] {
        return persons.map({ getPerson -> String in
            return getPerson.getFullName()
        })
    }
    
    func filterFullNamePlayers(persons: [GetPerson.Person]) -> [GetPerson.Person] {
        return persons.filter({ getPerson -> Bool in
            return getPerson.getFullName().count > 2
        })
    }
    
    func connectTeamOneAndTeamTwoPlayers() -> [GetPerson.Person] {
        return [fetchedTeamOnePlayers, fetchedTeamTwoPlayers].flatMap({ element -> [GetPerson.Person] in
            return element!
        })
    }
    
    func reset() {
        timeTextField.text = ""
        teamBtn.setTitle(Texts.DEFAULT_TEAM_BTN, for: .normal)
        playerBtn.setTitle(Texts.DEFAULT_PLAYER_BTN, for: .normal)
    }
    
    // MARK: - Prepare
    func prepareEvents() {
        eventGol.tag = 0
        eventYellowCard.tag = 1
        eventRedCard.tag = 2
        eventFol.tag = 3
        eventAutoGoal.tag = 4
        eventPenalty.tag = 5
        
        eventGol.initElement(imageVal: Images.eventGoal, labelVal: Texts.eventGoal)
        eventYellowCard.initElement(imageVal: Images.eventYellowCard, labelVal: Texts.eventYellowCard)
        eventRedCard.initElement(imageVal: Images.eventRedCard, labelVal: Texts.eventRedCard)
        eventFol.initElement(imageVal: Images.eventFoul, labelVal: Texts.eventFoul)
        eventAutoGoal.initElement(imageVal: Images.eventAutoGoal, labelVal: Texts.eventAutoGoal)
        eventPenalty.initElement(imageVal: Images.eventPenalty, labelVal: Texts.eventPenalty)
        
        eventGol.viewTapper.addTarget(self, action: #selector(eventTap(_:)))
        eventYellowCard.viewTapper.addTarget(self, action: #selector(eventTap(_:)))
        eventRedCard.viewTapper.addTarget(self, action: #selector(eventTap(_:)))
        eventFol.viewTapper.addTarget(self, action: #selector(eventTap(_:)))
        eventAutoGoal.viewTapper.addTarget(self, action: #selector(eventTap(_:)))
        eventPenalty.viewTapper.addTarget(self, action: #selector(eventTap(_:)))
//        let touch = UITapGestureRecognizer(target: eventGol, action: #selector())
    }
}

extension AddEventsProtocolViewController : AddEventsProtocolView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
