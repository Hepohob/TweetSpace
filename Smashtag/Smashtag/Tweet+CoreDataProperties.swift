//
//  Tweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Алексей Неронов on 25.12.16.
//  Copyright © 2016 Алексей Неронов. All rights reserved.
//

import Foundation
import CoreData


extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet");
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var tweeter: TwitterUser?

}
