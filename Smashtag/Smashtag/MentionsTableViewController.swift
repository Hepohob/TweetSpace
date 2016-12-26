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
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mention = mentionSections[indexPath.section].mentions[indexPath.row]
        switch mention {
        case .image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return mentionSections[section].type
    }
    

}
