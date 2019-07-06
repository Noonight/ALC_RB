//
//  RefereeTeamTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 12.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EditRefereeTeamTableViewController: UITableViewController {
    enum SegueIdentifiers {
        static let EDIT = "segue_edit_referees_protocol"
    }
    
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
            var referee_id: String = ""
            var image: UIImage = UIImage(named: "ic_logo")!
            var name: String = "Не назначен"
            var image_path: String = ""
            init() { }
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
            tableModel = [CellStruct(), CellStruct(), CellStruct(), CellStruct(), CellStruct()]
        }
    }
    
    // MARK: - Variables
    
    let cellId = "referee_protocol_cell"
    
    let presenter = EditRefereeTeamPresenter()
    
    var tableModel = TableStruct()
    
    var match: LIMatch!
    
    // MARK: - model controllers
    
    var refereesController: ProtocolRefereesController! {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let mTitle = self.title
        title = mTitle
        tableView.tableFooterView = UIView()
        
        prepareTableModel(destinationData: refereesController.referees)
        tableView.reloadData()
    }
    
    // MARK: - Prepare tableModel
    
    func prepareTableModel(destinationData: [LIReferee]) {
        for ref in destinationData {
            switch ref.getType() {
            case .inspector:
                tableModel.tableModel[0].referee_id = ref.person
            case .first:
                tableModel.tableModel[1].referee_id = ref.person
            case .second:
                tableModel.tableModel[2].referee_id = ref.person
            case .third:
                tableModel.tableModel[3].referee_id = ref.person
            case .chrono:
                tableModel.tableModel[4].referee_id = ref.person
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EditRefereeProtocolTableViewCell

        configureCell(cell: cell, model: tableModel.tableModel[indexPath.section])

        return cell
    }

    func configureCell(cell: EditRefereeProtocolTableViewCell, model: TableStruct.CellStruct) {
        if model.referee_id.count > 2 {
            presenter.fetchGetPerson(person: model.referee_id, success: { getPerson in
                guard let person = getPerson.person else {
                    Print.m("Error getting person")
                    return
                }
                cell.name_label.text = person.getFullName()
                if person.photo != nil {
                    cell.photo_image.af_setImage(withURL: ApiRoute.getImageURL(image: person.photo!))
                    cell.photo_image.image?.af_imageRoundedIntoCircle()
                } else {
                    cell.photo_image.image = UIImage(named: "ic_logo")
                }
            }) { error in
                Print.m(error)
            }
        } else {
            Print.m("referee id is empty -> \(model)")
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.EDIT,
            let destination = segue.destination as? EditRefereesProtocolViewController
        {
            destination.refereesController = self.refereesController
            destination.viewModel?.comingMatch = self.match 
        }
    }
}

extension EditRefereeTeamTableViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}