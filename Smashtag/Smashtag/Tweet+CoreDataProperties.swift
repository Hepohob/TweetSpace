//
//  Tweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Aleksei Neronov on 05.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import Foundation
import CoreData


extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet");
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var unique: String?
    @NSManaged public var text: String?
    @NSManaged public var tweeter: TwitterUser?

}
