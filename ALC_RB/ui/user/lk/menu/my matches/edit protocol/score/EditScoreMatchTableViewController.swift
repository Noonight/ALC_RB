//
//  ScoreMathTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 14.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EditScoreMatchTableViewController: UITableViewController {

    // MARK: - Table struct
    
    struct TableStruct {
        var events: [[LIEvent]] = []
    }
    
    // MARK: - Variables
    
    @IBOutlet var footer_view: UIView!
    @IBOutlet weak var footer_team_one_image: UIImageView!
    @IBOutlet weak var footer_team_one_label: UILabel!
    @IBOutlet weak var footer_score_label: UILabel!
    @IBOutlet weak var footer_team_two_label: UILabel!
    @IBOutlet weak var footer_team_two_image: UIImageView!
    
    
    let cellId = "score_match_cell"
    let presenter = EditScoreMatchPresenter()
    
    var leagueDetailModel = LeagueDetailModel()
    var match = LIMatch()
    
    var tableStruct: TableStruct = TableStruct()
    
    let resultScoreSection = 1
    let resultScoreHeader = "Итоговый счет"
    
    var teamOneCount = 0
    var teamTwoCount = 0
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
        //match.events.append(LIEvent(id: "apsifjsd0890", eventType: "yellowCard", player: "5be94d0206af116344942a58", time: "2 тайм"))
        
//        prepareTableStruct(leagueModel: leagueDetailModel, match: match)
        
//        tableStruct.events[1][0] = LIEvent(id: "eflgjko9u5ng0345jg904wjf0", eventType: "yellowCard", player: "5be94d0206af116344942a58", time: "2 тайм")
//        tableStruct.events[1].append(LIEvent(id: "eflgjko9u5ng0345jg904wjf0", eventType: "yellowCard", player: "5be94d0206af116344942a58", time: "2 тайм"))
//        tableStruct.events.append([LIEvent(id: "eflgjko9u5ng0345jg904wjf0", eventType: "yellowCard", player: "5be94d0206af116344942a58", time: "2 тайм")])
//        tableStruct.events[0].append(LIEvent(id: "203jirjg0sd8jfipsdj08", eventType: "", player: <#T##String#>, time: <#T##String#>))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.tableFooterView = footer_view
        footer_view.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 98)
        
        configureFooter(league: leagueDetailModel.leagueInfo.league, match: match)
        
        prepareTableStruct(leagueModel: leagueDetailModel, match: match)
    }

    // MARK: - Configure footer
    
    func configureFooter(league: LILeague, match: LIMatch) {
        let titleTeamOne = ClubTeamHelper.getTeamTitle(league: league, match: match, team: .one)
        footer_team_one_label.text = titleTeamOne
        //scheduleCell.mTitleTeam1 = titleTeamOne
        
        let titleTeamTwo = ClubTeamHelper.getTeamTitle(league: league, match: match, team: .two)
        footer_team_two_label.text = titleTeamTwo
        //scheduleCell.mTitleTeam2 = titleTeamTwo
        
//        footer_score_label.text = match.score ?? "-"
        footer_score_label.text = parseScoreString(score: match.score ?? "0:0")
//        footer_score_label.text = getScore(teamOne: teamOneCount, teamTwo: teamTwoCount)
        
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(match.teamOne!, league: league)) { (image) in
            self.footer_team_one_image.image = image.af_imageRoundedIntoCircle()
            //self.scheduleCell.mImageTeam1 = image
        }
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(match.teamTwo!, league: league)) { (image) in
            self.footer_team_two_image.image = image.af_imageRoundedIntoCircle()
            //self.scheduleCell.mImageTeam2 = image
        }
    }
    
    func parseScoreString(score: String) -> String {
        var scores = score.components(separatedBy: ":")
        return "\(scores[0]) : \(scores[1])"
    }
    
    // MARK: - Prepare Table struct
    
    func findUniqueHeader(destination: [LIEvent]) -> [String] {
        var allEventTypes: [String] = []
        for event in destination {
            if !allEventTypes.contains(event.time) {
                if event.getEventType() == LIEvent.EventType.goal || event.getEventType() == LIEvent.EventType.autoGoal {
                    allEventTypes.append(event.time)
                }
            }
        }
        return allEventTypes
    }
    
    func prepareTableStruct(leagueModel: LeagueDetailModel, match: LIMatch) {
        tableStruct.events = []
        let events = match.events
        let uniqueEventTypes = findUniqueHeader(destination: events)
        for uniqEvent in uniqueEventTypes {
            let arrEvents: [LIEvent] = events.filter { (event) -> Bool in
                return event.time == uniqEvent && (event.getSystemeventType() == LIEvent.SystemEventType.goal || event.getSystemeventType() == LIEvent.SystemEventType.autoGoal)
            }
            tableStruct.events.append(arrEvents)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableStruct.events.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableStruct.events[section][0].time
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableStruct.events[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EditScoreMatchTableViewCell

        configureCell(cell: cell, league: leagueDetailModel.leagueInfo.league, match: match, event: tableStruct.events[indexPath.section][indexPath.row])

        return cell
    }
    
    func configureCell(cell: EditScoreMatchTableViewCell, league: LILeague, match: LIMatch, event: LIEvent) {
        
        let playerId = event.player
//        print ("playerId =  \(playerId)")
//        print ("team One = \(match.teamOne) --- team Two = \(match.teamTwo)")
//        print(getTeamIdByPlayerId(league: league, match: match, player: playerId))
        
        if getTeamIdByPlayerId(league: league, match: match, player: playerId) == match.teamOne {
            teamOneCount = teamOneCount + 1
        } else if getTeamIdByPlayerId(league: league, match: match, player: playerId) == match.teamTwo {
            teamTwoCount = teamTwoCount + 1
        }
        
        let titleTeamOne = ClubTeamHelper.getTeamTitle(league: league, match: match, team: .one)
        cell.team_one_label.text = titleTeamOne
        
        let titleTeamTwo = ClubTeamHelper.getTeamTitle(league: league, match: match, team: .two)
        cell.team_two_label.text = titleTeamTwo
        
        cell.score_label.text = getScore(teamOne: teamOneCount, teamTwo: teamTwoCount)
        
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(match.teamOne!, league: league)) { (image) in
            cell.team_one_image.image = image.af_imageRoundedIntoCircle()
            //self.scheduleCell.mImageTeam1 = image
        }
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(match.teamTwo!, league: league)) { (image) in
            cell.team_two_image.image = image.af_imageRoundedIntoCircle()
            //self.scheduleCell.mImageTeam2 = image
        }
    }
    
    // MARK: - Configure cell helpers
    
    func getScore(teamOne: Int, teamTwo: Int) -> String {
        return "\(teamOne) : \(teamTwo)"
    }
    
    func getTeamIdByPlayerId(league: LILeague, match: LIMatch, player id: String) -> String {
        let playerId = id
        let teamOne = match.teamOne
        let teamTwo = match.teamTwo
        
        let teamOnePlayers = league.teams?.filter { (team) -> Bool in
            return team.id == teamOne
        }
        let teamTwoPlayers = league.teams?.filter { (team) -> Bool in
            return team.id == teamTwo
        }
        
        var result = ""
        
//        if teamOnePlayers?.players?.contains(where: { liPlayer -> Bool in
//            return liPlayer.playerId =
//        })
        
        if (teamOnePlayers?.contains(where: { (team) -> Bool in
            return team.players!.contains(where: { (player) -> Bool in
                return player.playerId == playerId
            })
        }) ?? false) {
            result = teamOne!
        }
        if (teamTwoPlayers?.contains(where: { (team) -> Bool in
            return team.players!.contains(where: { (player) -> Bool in
                return player.playerId == playerId
            })
        }) ?? false) {
            result = teamTwo!
        }
        
        return result
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EditScoreMatchTableViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
