//
//  RefereeTeamTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 12.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class RefereeTeamTableViewController: UITableViewController {

    // MARK: - Table Struct
    
    struct TableStruct {
        enum RefereeType: String{
            case inspector = "Инспектор"
            case first = "1 судья"
            case second = "2 судья"
            case third = "3 судья"
            case chrono = "Хронометрист"
        }
        
        struct CellStruct {
            var image: UIImage = UIImage(named: "ic_logo")!
            var name: String = "Не назначен"
            init() {
                
            }
        }
        var tableModel: [CellStruct]
        var tableHeader = [
            "Инспектор",
            "1-й судья",
            "2-й судья",
            "3-й судья",
            "Хронометрист"
        ]
        
        init() {
            tableModel = [CellStruct]()
        }
    }
    
    // MARK: - Variables
    
    let cellId = "referee_protocol_cell"
    
    let presenter = RefereeTeamPresenter()
    
    var tableModel = TableStruct()
    
    var destinationData: [LIReferee] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableModel.tableModel.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableModel.tableHeader[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RefereeProtocolTableViewCell

        configureCell(cell: cell, model: destinationData[indexPath.section])

        return cell
    }
    
    func configureCell(cell: RefereeProtocolTableViewCell, model: LIReferee) {
        switch  model.getType() {
        case .inspector:
            presenter.getReferee(referee: model.person, get_referee: { (referee) in
                cell.name_label.text = referee.person.getFullName()
                if referee.person.photo != nil {
                    cell.photo_image.af_setImage(withURL: ApiRoute.getImageURL(image: referee.person.photo!))
                    //cell.photo_image.image?.af_imageRoundedIntoCircle()
                } else {
                    cell.photo_image.image = UIImage(named: "ic_logo")
                }
            }) { (error) in
                
            }
        case .first:
            presenter.getReferee(referee: model.person, get_referee: { (referee) in
                cell.name_label.text = referee.person.getFullName()
                if referee.person.photo != nil {
                    cell.photo_image.af_setImage(withURL: ApiRoute.getImageURL(image: referee.person.photo!))
                    //cell.photo_image.image?.af_imageRoundedIntoCircle()
                } else {
                    cell.photo_image.image = UIImage(named: "ic_logo")
                }
            }) { (error) in
                
            }
        case .second:
            presenter.getReferee(referee: model.person, get_referee: { (referee) in
                cell.name_label.text = referee.person.getFullName()
                if referee.person.photo != nil {
                    cell.photo_image.af_setImage(withURL: ApiRoute.getImageURL(image: referee.person.photo!))
                    //cell.photo_image.image?.af_imageRoundedIntoCircle()
                } else {
                    cell.photo_image.image = UIImage(named: "ic_logo")
                }
            }) { (error) in
                
            }
        case .third:
            presenter.getReferee(referee: model.person, get_referee: { (referee) in
                cell.name_label.text = referee.person.getFullName()
                if referee.person.photo != nil {
                    cell.photo_image.af_setImage(withURL: ApiRoute.getImageURL(image: referee.person.photo!))
                    //cell.photo_image.image?.af_imageRoundedIntoCircle()
                } else {
                    cell.photo_image.image = UIImage(named: "ic_logo")
                }
            }) { (error) in
                
            }
        case .chrono:
            presenter.getReferee(referee: model.person, get_referee: { (referee) in
                cell.name_label.text = referee.person.getFullName()
                if referee.person.photo != nil {
                    cell.photo_image.af_setImage(withURL: ApiRoute.getImageURL(image: referee.person.photo!))
                    //cell.photo_image.image?.af_imageRoundedIntoCircle()
                } else {
                    cell.photo_image.image = UIImage(named: "ic_logo")
                }
            }) { (error) in
                
            }
        default:
            break
        }
        
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RefereeTeamTableViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
