//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Алексей Неронов on 23.12.16.
//  Copyright © 2016 Алексей Неронов. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: Model
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    
    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
        static let MentionsIdentifier = "Mentions"
        static let TwittersControllerSegue = "TweetersMentioningSearchTerm"
    }
    
    private var twitterRequest:Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }

    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText:String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
            History.add(searchText!)
        }
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets{[weak weakself = self] newTweets in
                DispatchQueue.main.async {
                    if request == weakself?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakself?.tweets.insert(newTweets, at: 0)
                            weakself?.updateDatabase(newTweets)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Database working
    
    private func updateDatabase(_ newTweets:[Twitter.Tweet] ) {
        managedObjectContext?.perform {
            for tweeterInfo in newTweets {
                _ = Tweet.tweetWithTwitterInfo(twitterInfo: tweeterInfo, inManagedObjectContext:self.managedObjectContext!)
            }
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        printDatabaseStatistics()
    }
    
    private func printDatabaseStatistics() {
        managedObjectContext?.perform({
            let userCount = try! self.managedObjectContext!.count(for: NSFetchRequest(entityName: "TwitterUser"))
            print("\(userCount) TwitterUsers")
            let tweetCount = try! self.managedObjectContext!.count(for: NSFetchRequest(entityName: "Tweet"))
            print("\(tweetCount) Tweets")
            print("Done printing database statistics")
        })
    }

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        searchText = "#stanford"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)
        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        return cell
    }

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String?,
                                     sender: Any?) -> Bool {
        if identifier == Storyboard.MentionsIdentifier {
            if let tweetCell = sender as? TweetTableViewCell {
                if tweetCell.tweet!.hashtags.count + tweetCell.tweet!.urls.count +
                    tweetCell.tweet!.userMentions.count +
                    tweetCell.tweet!.media.count == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.MentionsIdentifier,
                let mtvc = segue.destination as? MentionsTableViewController,
                let tweetCell = sender as? TweetTableViewCell {
                mtvc.tweet = tweetCell.tweet
            }
        }
        else if segue.identifier == Storyboard.TwittersControllerSegue {
            if let tweetersTVC = segue.destination as? TweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.managedObjectContext = managedObjectContext
            }
        }

    }

}
