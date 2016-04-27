//
//  tripFeedCell.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/18/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class tripFeedCell: UITableViewCell {
    var favoritedTrip = false
    @IBAction func morePhotosButton(sender: AnyObject) {
        
    }
    
    
    @IBOutlet var blogNameLabel: UILabel!
    
    
    @IBOutlet var blogDescriptionLabel: UILabel!
    
    
    @IBOutlet var blogComment1: UILabel!
    
    @IBOutlet var blogComment2: UILabel!
    
    @IBOutlet var viewCommentsLabel: UILabel!
    
    @IBAction func commentButton(sender: AnyObject) {
        
        
    }
    
    
    @IBOutlet var participantsLabel: UILabel!
    
    
    @IBOutlet var imageTripNameLabel: UILabel!
    
    @IBOutlet var favoriteButtonOutlet: UIButton!
    @IBAction func favoriteButton(sender: AnyObject) {
        if favoritedTrip == false {
        favoriteButtonOutlet.setTitle("Favorited", forState: UIControlState.Normal)
            favoriteButtonOutlet.layer.cornerRadius = 3
            favoriteButtonOutlet.backgroundColor = UIColor.yellowColor()
            favoritedTrip = true
        } else {
            favoriteButtonOutlet.setTitle("Favorite", forState: UIControlState.Normal)
            favoriteButtonOutlet.backgroundColor = UIColor.whiteColor()
            favoritedTrip = false
            
        }
        
        
    }
    
    
    @IBOutlet var postedImage1: UIImageView!
    
    
    @IBOutlet var postedImage2: UIImageView!
    
    
    @IBOutlet var postedImage3: UIImageView!
    
  
    @IBOutlet var tripName: UILabel!
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var tripInfo: UILabel!
    
}
