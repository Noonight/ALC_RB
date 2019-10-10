//
//  TournamentsTableViewController.swift
//  ALC_RB
//
//  Created by user on 27.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class TournamentsTableViewController: BaseStateTableViewController {
    
    let presenter = TournamentsPresenter()
    var tournamentsTable: TournamentsTable?
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        self.setupTournamentsTable()
        self.fetch = self.presenter.getTournaments
        setEmptyMessage(message: "Здесь будут отображаться турниры")
        refreshData()
    }
}

// MARK: EXTENSIONS



// MARK: SETUP

extension TournamentsTableViewController {
    
    func setupTournamentsTable() {
        self.tournamentsTable = TournamentsTable(actions: self)
        self.tableView.dataSource = tournamentsTable
        self.tableView.delegate = tournamentsTable
    }
    
    func setupTournamentsDS() {
        refreshData()
    }
    
}

// MARK: TABLE VIEW RELOAD

extension TournamentsTableViewController {
    override func hasContent() -> Bool {
        if self.tournamentsTable != nil
        {
            if tournamentsTable?.dataSource.count != 0
            {
                return true
            }
            else
            {
                return false
            }
        }
        return false
    }
}

// MARK: CELL ACTIONS

extension TournamentsTableViewController: CellActions {
    func onCellDeselected(model: CellModel) {
        
    }
    
    func onCellSelected(model: CellModel) {
        if model is League
        {
            
        }
    }
    
    
}

// MARK: PRESENTER

extension TournamentsTableViewController: TournamentsView {
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
    
    func onGetTournamentSuccess(tournament: Tournaments) {
//        self.tournaments = tournament
//        if self.tournamentsTable != nil
//        {
//            self.tournamentsTable?.dataSource = tournament.leagues
//        }
        endRefreshing()
    }
    
    func onGetTournamentFailure(error: Error) {
        endRefreshing()
        showFailFetchRepeatAlert(message: error.localizedDescription) {
            self.refreshData()
        }
        Print.m(error)
    }
}

// MARK: NAVIGATION

extension TournamentsTableViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if  segue.identifier == segueId,
//            let destination = segue.destination as? LeagueDetailViewController,
//            let cellIndex = tableView.indexPathForSelectedRow?.row
//        {
//            //destination.league = tournaments.leagues[cellIndex]
//            destination.leagueDetailModel = LeagueDetailModel(tournaments.leagues[cellIndex])
//        }
//    }
}


