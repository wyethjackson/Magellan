//
//  businessEventsShowViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 1/27/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
//import RealmSwift

class businessEventsShowViewController: UIViewController {
    var nameOfEvents = [String]()
    var locationOfEvents = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var eventsQuery = PFQuery(className: "Events")
        var specificUserEvents = eventsQuery.whereKey("userId", equalTo: (PFUser.currentUser()?.objectId)!)
        
        specificUserEvents.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let userEvents = objects {
                for object in userEvents {
                    self.nameOfEvents.append(object["name"] as! String)
                    self.locationOfEvents.append(object["location"] as! String)
                }
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if nameOfEvents.count > 0 {
            return nameOfEvents.count
        } else {
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // This will be the case for programmatically loaded cells (see viewDidLoad to switch approaches)
       let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "eventsCell")
            // Configure the cell for this indexPath
            
//            let modelItem = model.dataArray[indexPath.row]
//            cell.titleLabel.text = modelItem.title
//            cell.bodyLabel.text = modelItem.body
        if nameOfEvents.count > 0 {
            cell.textLabel?.text = self.nameOfEvents[indexPath.row] + " - " + self.locationOfEvents[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            cell.textLabel!.text = "No events have been created"
        }
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
        
            // Make sure the constraints have been added to this cell, since it may have just been created from scratch
//            cell.setNeedsUpdateConstraints()
//            cell.updateConstraintsIfNeeded()
            
            return cell
        }
    
    
}
