//
//  TweetersTableViewСontroller.swift
//  Smashtag
//
//  Created by Aleksei Neronov on 27.12.16.
//  Copyright © 2016 Aleksei Neronov. All rights reserved.
//

import UIKit
import CoreData

class TweetersTableViewController: CoreDataTableViewController {
    
    //MARK: Model
    
    var mention:String? { didSet{ updateUI() }}
    var managedObjectContext:NSManagedObjectContext? { didSet{ updateUI() }}
    
    //MARK: UI setiings
    
    private func updateUI() {
        if let context = managedObjectContext, mention!.characters.count > 0 {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            request.sortDescriptors = [NSSortDescriptor(
                key: "screenName",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]

            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUserCell", for: indexPath)
        if let twitterUser = fetchedResultsController?.object(at: indexPath) as? TwitterUser {
            var screenName: String?
            twitterUser.managedObjectContext?.performAndWait {
                // dont forget to do it in right queue, because we use performAndWait
                screenName = twitterUser.screenName
            }
            cell.textLabel?.text = screenName
            if let count = tweetCountWithMentionByTwitterUser(twitterUser) {
                cell.detailTextLabel?.text = (count == 1) ? "1 tweet" : "\(count) tweets"
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
        return cell
    }
    
    // private func, detect count of tweets, contains mention,
    // was set by user
    
    private func tweetCountWithMentionByTwitterUser(_ user: TwitterUser) -> Int?
    {
        var count: Int?
        user.managedObjectContext?.performAndWait {
            let request = NSFetchRequest<Tweet>(entityName: "Tweet")
            request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@", self.mention!, user)
            count = try! user.managedObjectContext?.count(for: request)
        }
        return count
    }


}
