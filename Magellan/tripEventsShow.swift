//
//  tripEventsShow.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/16/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class tripEventsShow: UITableViewController {
    var tripId = String()
    var tripEvents = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tripId = Manager.tripId
        
    }
    
    
    @IBAction func addEventButton(sender: AnyObject) {
        Manager.dataToPass = "Trip Events"
        Manager.tripId = self.tripId
        
        self.performSegueWithIdentifier("eventsShowToAddEvent", sender: self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripEvents.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
         cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
        cell!.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell!.backgroundColor = UIColor.clearColor()
        cell!.backgroundView = blurView
        
        cell!.textLabel?.text = self.tripEvents[indexPath.row]
      
        
        
        return cell!
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }

}
