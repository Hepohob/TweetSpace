//
//  HistoryTableViewController.swift
//  Smashtag
//
//  Created by Aleksei Neronov on 27.12.16.
//  Copyright © 2016 Aleksei Neronov. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    private struct Storyboard {
        static let HistoryCellIdentifier = "HistoryCell"
        static let MentionsSegueIdentifier = "MentionsSegue"
    }

    private var history: [String] {
        return History.searches
    }
    
    override func viewDidLoad() {
        updateUI()
    }
    
    private func updateUI() {
        let titleText = NSLocalizedString("History", comment: "Title 'History' in history view controller.")
        self.title = titleText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.HistoryCellIdentifier, for: indexPath)
        cell.textLabel?.text = history[indexPath.row]
        return cell
    }


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier , identifier == Storyboard.MentionsSegueIdentifier,
            let cell = sender as? UITableViewCell,
            let ttvc = segue.destination as? TweetTableViewController {
            ttvc.searchText = cell.textLabel?.text
            ttvc.title = cell.textLabel?.text
        }
        
    }

}
