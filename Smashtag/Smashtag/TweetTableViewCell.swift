//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Алексей Неронов on 23.12.16.
//  Copyright © 2016 Алексей Неронов. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!

    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }

    struct Palette {
        static let hashtagColor = UIColor.brown
        static let urlColor = UIColor.blue
        static let userColor = UIColor.purple
    }

    private func updateUI() {
        tweetTextLabel.attributedText = nil
        tweetScreenNameLabel.text = nil
        tweetCreatedLabel.text = nil
        tweetProfileImageView.image = nil
        
        if let tweet = self.tweet {
            tweetScreenNameLabel?.text = "\(tweet.user)"
            tweetTextLabel?.attributedText = setString(by: tweet)

            
            if let profileImageURL = tweet.user.profileImageURL {
                DispatchQueue.global(qos: .userInitiated).async {
                    if let imageData = NSData(contentsOf: profileImageURL) {
                        DispatchQueue.main.async {
                            if profileImageURL == tweet.user.profileImageURL {
                                self.tweetProfileImageView?.image = UIImage(data: imageData as Data)
                            }
                        }
                    }
                }
            }
            let formatter = DateFormatter()
            if Date().timeIntervalSince(tweet.created) > 60*60*24 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created)
        }
    }
    
    private func setString(by tweet:Twitter.Tweet) -> NSMutableAttributedString {
        let result = NSMutableAttributedString(string: tweet.text)
        for _ in tweet.media {
            result.append(NSMutableAttributedString(string:" 📷"))
        }
        result.setColorForMentions(mentions: tweet.hashtags, color: Palette.hashtagColor)
        result.setColorForMentions(mentions: tweet.urls, color: Palette.urlColor)
        result.setColorForMentions(mentions: tweet.userMentions, color: Palette.userColor)
        return result
    }
    
}

//MARK: NSMutableAttributedString extension

private extension NSMutableAttributedString{
    func setColorForMentions(mentions:[Mention], color:UIColor) {
        for mention in mentions {
            addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
        }
    }
}
