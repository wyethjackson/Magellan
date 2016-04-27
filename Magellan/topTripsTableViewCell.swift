//
//  topTripsTableViewCell.swift
//  
//
//  Created by Wyeth Jackson on 3/7/16.
//
//

import UIKit
import Parse

class topTripsTableViewCell: UITableViewCell {
    @IBOutlet var tripNameLabel: UILabel!
    var voted = false
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var budgetLabel: UILabel!
    
    @IBAction func upVoteButton(sender: AnyObject) {
        if voted == false {
            upVoteButtonOutlet.setImage(UIImage(named: "down_vote.png") , forState: .Normal)
        } else if voted == true {
            upVoteButtonOutlet.setImage(UIImage(named: "up_vote.png") , forState: .Normal)
        }
        
    }
    
    @IBAction func peopleGoingButton(sender: AnyObject) {
        
        
    }
    
    @IBOutlet var peopleGoingNamesLabel: UILabel!
    
    
    @IBAction func giveAdviceButton(sender: AnyObject) {
    }
    
    @IBOutlet var upVoteLabel: UILabel!
    
    @IBOutlet var upVoteButtonOutlet: UIButton!
    
}
