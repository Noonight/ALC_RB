//
//  NewsAllTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 07.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class NewsAllTableViewController: UITableViewController {

    let cellId = "cell_news_dynamic"
    
    var tableData: News? {
        didSet {
            updateUI()
        }
    }
    
    let newsDetailIdentifier = "NewsDetail"
    let newsDetailSegueIdentifier = "NewsDetailIdentifier"
    
    let mTitle = "Новости"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationController?.navigationItem.title = mTitle
        
        //print(parent!.navigationController?.navigationBar)
        
        self.title = mTitle
        
        tableView.tableFooterView = UIView()
    }

    func updateUI() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableData?.news.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? NewsTableViewCell

        cell?.content?.text = tableData?.news[indexPath.row].caption
        cell?.date?.text = tableData?.news[indexPath.row].updatedAt.UTCToLocal(from: .utc, to: .local)
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == newsDetailSegueIdentifier,
            let destination = segue.destination as? NewsDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.content = NewsDetailViewController.Content(
                title: tableData!.news[cellIndex].caption,
                date: (tableData!.news[cellIndex].updatedAt).UTCToLocal(from: .utc, to: .local),
                content: tableData!.news[cellIndex].content,
                imagePath: tableData!.news[cellIndex].img)
        }
    }

}
