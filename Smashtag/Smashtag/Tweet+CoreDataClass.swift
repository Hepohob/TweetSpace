//
//  Tweet+CoreDataClass.swift
//  Smashtag
//
//  Created by Aleksei Neronov on 05.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import Foundation
import CoreData
import Twitter

public class Tweet: NSManagedObject {

    class func tweetWithTwitterInfo(twitterInfo:Twitter.Tweet, inManagedObjectContext context:NSManagedObjectContext) -> Tweet? {
        let request = NSFetchRequest<Tweet>(entityName: "Tweet")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)
        
        if let tweet = (try? context.fetch(request))?.first /*as? Tweet */{
            // found this tweet in the database, return it ...
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObject(forEntityName: "Tweet", into: context) as? Tweet {
            // created a new tweet in the database
            // load it up with information from the Twitter.Tweet ...
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.created = twitterInfo.created as NSDate?
            tweet.tweeter = TwitterUser.twitterUserWithTwitterInfo(twitterInfo.user, inManagedObjectContext: context)
            return tweet
        }
        return nil
    }
    
}
