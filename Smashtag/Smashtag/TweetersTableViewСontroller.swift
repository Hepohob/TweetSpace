//
//  TweetersTableViewСontroller.swift
//  Smashtag
//
//  Created by Aleksei Neronov on 27.12.16.
//  Copyright © 2016 Aleksei Neronov. All rights reserved.
//

import UIKit

class TweetersTableViewController: UITableViewController {
    
//    var fetchedResultController:NSFetchedResultController {
//        
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)


        return cell
    }

}
