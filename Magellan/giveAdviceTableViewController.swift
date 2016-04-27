//
//  giveAdviceTableViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 3/31/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class giveAdviceTableViewController: UITableViewController {
    
    var locationsVisited = [String]()
    var headers = ["Friends", "People going to places you've been"]
    
    var friends = ["John Kliewer", "Keenan Smith"]
    
    var friendDestinations = ["London", "Barcelona"]
    var friendTripEvents = [["None"], ["Running of the bull", "FC Barcelona basketball game"]]
    var randomPeople = ["Jack H.", "Larry M.", "Marissa K."]
    var randomPeopleLocations = ["Iceland", "Rome", "Paris"]
    
    var randomPeopleEvents = [["None"], ["None"], ["Louvre", "Eiffel Tower"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var users = PFUser.query()
        users?.whereKey("objectId", equalTo: (PFUser.currentUser()?.objectId)!)
        var specificUser = users?.findObjectsInBackgroundWithBlock({ (objects, error) in
            if let user = objects {
                for object in user {
                    if object["locationsVisited"] != nil {
                        self.locationsVisited = object["locationsVisited"] as! [String]
                    }
                }
            }
        })
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if locationsVisited.count == 0 {
            return 1
        } else {
        return headers.count
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if locationsVisited.count == 0 {
                return 1
            } else if friends.count == 0 {
                return 1
            } else {
                return friends.count
            }
        } else if section == 1 {
            return randomPeople.count
        }
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.5 //make the header transparent
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if locationsVisited.count == 0 {
            return "No Advice To Give"
        } else {
            return headers[section]
        }
    }
    
        override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            if locationsVisited.count == 0 {
                return 70
            }
            
            if indexPath.section == 0 {
                if friends.count == 0 {
                    return 70
                } else {
                    return 200
                }
            }
    
            return 100
        }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: giveAdviceTableViewCell
        
        cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! giveAdviceTableViewCell
        if locationsVisited.count == 0 {
            cell.textLabel!.text = "Go to the 'My Activity' tab to add places you have visited"
            cell.textLabel?.numberOfLines = 2
            cell.destinationLabel.hidden = true
            cell.nameLabel.hidden = true
            cell.eventsLabel.hidden = true
            cell.eventsPlannedLabel.hidden = true
            cell.adviceTextField.hidden = true
            cell.viewTripButtonOutlet.hidden = true
            cell.submitButtonOutlet.hidden = true
            cell.accessoryType =  UITableViewCellAccessoryType.DisclosureIndicator
        } else {
        
        if indexPath.section == 0 {
            if friends.count == 0 {
                cell.textLabel?.text = "No friends are going to places you have been"
                cell.destinationLabel.hidden = true
                cell.nameLabel.hidden = true
                cell.eventsLabel.hidden = true
                cell.eventsPlannedLabel.hidden = true
                cell.adviceTextField.hidden = true
                cell.viewTripButtonOutlet.hidden = true
                cell.submitButtonOutlet.hidden = true
            } else {
                cell.destinationLabel.hidden = false
                cell.nameLabel.hidden = false
                cell.eventsLabel.hidden = false
                cell.eventsPlannedLabel.hidden = false
                cell.adviceTextField.hidden = false
                cell.viewTripButtonOutlet.hidden = false
                cell.submitButtonOutlet.hidden = false
            cell.destinationLabel.text = friendDestinations[indexPath.row]
            cell.nameLabel.text = friends[indexPath.row]
            let events = friendTripEvents[indexPath.row].joinWithSeparator(", ")
            cell.eventsLabel.text = events
            cell.eventsPlannedLabel.text = "Events planned:"
            }
            
        } else if indexPath.section == 1 {
            cell.destinationLabel.hidden = false
            cell.nameLabel.hidden = false
            cell.eventsLabel.hidden = false
            cell.eventsPlannedLabel.hidden = false
            cell.adviceTextField.hidden = false
            cell.viewTripButtonOutlet.hidden = false
            cell.submitButtonOutlet.hidden = false
           cell.destinationLabel.text = randomPeopleLocations[indexPath.row]
            cell.nameLabel.text = randomPeople[indexPath.row]
            
            let events = randomPeopleEvents[indexPath.row].joinWithSeparator(", ")
            cell.eventsLabel.text = events
            cell.eventsPlannedLabel.text = "Events planned:"
        }
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    

    

}
