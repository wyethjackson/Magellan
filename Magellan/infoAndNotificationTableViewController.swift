//
//  infoAndNotificationTableViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 3/31/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class infoAndNotificationTableViewController: UITableViewController {
    
    var headers = ["Help Us Recommend Destinations!", "Notifications"]
    
    var notificationHeaders = [String]()
    var notificationBody = [String]()
    
    var addLocation = "Add Locations You Have Visited"
    
    var numberOfLocations = 0
    
    
    var locations = [String]()
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        if(segue.sourceViewController .isKindOfClass(addPlaceYouveBeenTableViewController)) {
            var view2:addPlaceYouveBeenTableViewController = segue.sourceViewController as! addPlaceYouveBeenTableViewController
           locations = view2.totalLocations
            numberOfLocations = locations.count
            tableView.reloadData()
          
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var users : PFQuery = PFUser.query()!
        users.whereKey("objectId", equalTo: (PFUser.currentUser()?.objectId!)!)
        users.findObjectsInBackgroundWithBlock { (objects, error) in
            if let userQuery = objects {
                for object in userQuery {
                    if object["destinationsVisited"] != nil {
                        self.locations = object["destinationsVisited"] as! [String]
                        self.numberOfLocations = self.locations.count
                    }
                }
                self.tableView.reloadData()
            }
        }
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        } else if section == 1 {
            if notificationHeaders.count > 0 {
                return notificationHeaders.count
            } else {
                return 1
            }
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
        return headers[section]
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: infoAndNotificationTableViewCell!
        
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! infoAndNotificationTableViewCell
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.mainLabel.hidden = true
                cell.headerLabel.text = addLocation
            } else {
                
                cell.mainLabel.hidden = false
                var locationNum = String(numberOfLocations)
                cell.headerLabel.text = "Destinations visited: " + locationNum
                if locations.count == 0 {
                    cell.mainLabel.hidden = true
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    cell.mainLabel.hidden = false
                    var locationString = locations.joinWithSeparator(", ")
                    cell.mainLabel.text = locationString
                }
            }
            
            
            
        } else if indexPath.section == 1 {
            if notificationHeaders.count == 0 {
                cell.mainLabel.hidden = true
                cell.headerLabel.text = "You currently have no notifications"
            } else {
                cell.mainLabel.hidden = false
                cell.headerLabel.text = notificationHeaders[indexPath.row]
                cell.mainLabel.text = notificationBody[indexPath.row]
            }
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            self.performSegueWithIdentifier("myActivityToAddPlaceSegue", sender: self)
        }
        
    }

    
    
    

}
