//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var usernameTextLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            refreshData()
        }
    }
    func refreshData()
    {
        if(tweet.favorited == true)
        {
            favButton.setImage(UIImage(named: "favor-icon-red.png"), for:[])
        }
        else
        {
            favButton.setImage(UIImage(named: "favor-icon.png"), for:[])
        }
        if(tweet.retweeted == true)
        {
            retweetButton.setImage(UIImage(named: "retweet-icon-green.png"), for:[])
        }
        else
        {
            retweetButton.setImage(UIImage(named: "retweet-icon.png"), for:[])
        }
        let url = URL(string: tweet.user.profileURL)!
        pictureImageView.af_setImage(withURL: url)
        tweetTextLabel.text = tweet.text
        nameTextLabel.text = tweet.user.name
        usernameTextLabel.text = ("@" + tweet.user.screenName!) as String?
        dateLabel.text = tweet.createdAtString
        retweetLabel.text = String(tweet.retweetCount)
        favLabel.text = String(describing: tweet.favoriteCount)
        if(tweet.favoriteCount != nil)
        {
            let c = tweet.favoriteCount!
            favLabel.text = String(c)
        }
        else
        {
            favLabel.text = "N/A"
        }
        
    }
    @IBAction func didTapFavorite(_ sender: Any) {
        if(tweet.favorited == false){
            tweet.favorited = true
            tweet.favoriteCount! += 1
            favButton.setImage(UIImage(named: "favor-icon-red.png"), for:[])
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
                
            }
            self.refreshData()
        }
        else
        {
            tweet.favorited = false
            tweet.favoriteCount! -= 1
            favButton.setImage(UIImage(named: "favor-icon.png"), for:[])
            APIManager.shared.unFavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unFavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unFavorited the following Tweet: \n\(tweet.text)")
                }
            }
            self.refreshData()
        }
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        if(tweet.retweeted == false)
        {
            tweet.retweeted = true
            tweet.retweetCount += 1
            retweetButton.setImage(UIImage(named: "retweet-icon-green.png"), for:[])
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                }
            }
            self.refreshData()
        }
        else
        {
            tweet.retweeted = false
            tweet.retweetCount -= 1
            retweetButton.setImage(UIImage(named: "retweet-icon.png"), for:[])
            APIManager.shared.unRetweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unRetweeted the following Tweet: \n\(tweet.text)")
                }
            }
            self.refreshData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
