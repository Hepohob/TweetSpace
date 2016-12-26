//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Алексей Неронов on 26.12.16.
//  Copyright © 2016 Алексей Неронов. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {

    // MARK: - Public API

    var tweet: Twitter.Tweet? {
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media, media.count > 0 {
                mentionSections.append(MentionSection(type: "Images",
                                                      mentions: media.map { MentionItem.image($0.url, $0.aspectRatio) }))
            }
            if let urls = tweet?.urls, urls.count > 0 {
                mentionSections.append(MentionSection(type: "URLs",
                                                      mentions: urls.map { MentionItem.keyword($0.keyword) }))
            }
            if let hashtags = tweet?.hashtags, hashtags.count > 0 {
                mentionSections.append(MentionSection(type: "Hashtags",
                                                      mentions: hashtags.map { MentionItem.keyword($0.keyword) }))
            }
            if let users = tweet?.userMentions, users.count > 0 {
                mentionSections.append(MentionSection(type: "Users",
                                                      mentions: users.map { MentionItem.keyword($0.keyword) }))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Inner Model
    
    private struct Storyboard {
        static let ImageCellIdentifier = "ImageCell"
        static let TextCellIdentifier = "TextCell"
    }
    
    private var mentionSections: [MentionSection] = []

    private struct MentionSection: CustomStringConvertible
    {
        var type: String
        var mentions: [MentionItem]
        var description: String { return "\(type): \(mentions)" }
    }

    private enum MentionItem: CustomStringConvertible
    {
        case keyword(String)
        case image(URL, Double)
        
        var description: String {
            switch self {
            case .keyword(let keyword): return keyword
            case .image(let url, _): return url.path
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentionSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionSections[section].mentions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mention = mentionSections[indexPath.section].mentions[indexPath.row]
        
        switch mention {
        case .keyword(let keyword):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TextCellIdentifier, for: indexPath)
            cell.textLabel?.text = keyword
            return cell

        case .image(let url, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.ImageCellIdentifier, for: indexPath)
            if let imgCell = cell as? ImageTableViewCell {
                imgCell.urlImage = url
            }
            return cell

        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
