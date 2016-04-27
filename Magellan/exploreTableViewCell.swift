//
//  exploreTableViewCell.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/19/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class exploreTableViewCell: UITableViewCell {

   var follow = false
    
    @IBOutlet var cellLabel: UILabel!
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var followUserButton: UIButton!
    @IBAction func followButton(sender: AnyObject) {
        
        if follow == false {
            followUserButton.backgroundColor = UIColor.lightGrayColor()
            followUserButton.setImage(UIImage(named: "Add User Filled-50.png"), forState: .Normal)
        } else {
            followUserButton.backgroundColor = UIColor.greenColor()
            followUserButton.setImage(UIImage(named: "Checked User Filled-50.png"), forState: .Normal)
            
        }
        
    }
    
}
