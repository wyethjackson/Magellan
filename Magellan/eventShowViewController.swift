//
//  eventShowViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 3/1/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class eventShowViewController: UIViewController {
    var companyId = String()
    var eventId = String()
    var eventAddress = String()
    var eventDate = NSDate()
    var dayId = String()
    var eventDescription = String()
    var eventName = String()
    
    @IBOutlet var eventNameLabel: UILabel!
    
    @IBOutlet var eventDateLabel: UILabel!
    
    @IBOutlet var eventAddressLabel: UILabel!
    
    @IBOutlet var eventDescriptionLabel: UILabel!
    
    
    @IBOutlet var addEventLabel: UIButton!
    
    
    @IBAction func addEventButton(sender: AnyObject) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companyId = Manager.companyId
        self.eventId = Manager.eventId
        self.dayId = Manager.dayId
        var eventQuery = PFQuery(className: "Events")
        
        var specificEventQuery = eventQuery.whereKey("objectId", equalTo: self.eventId)

        specificEventQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let eventInfo = objects {
                for object in eventInfo {
                    self.eventAddress = object["address"] as! String
                    self.eventDate = object["date"] as! NSDate
                    self.eventDescription = object["description"] as! String
                    self.eventName = object["name"] as! String
                    self.eventNameLabel.text = self.eventName
                    self.eventAddressLabel.text = self.eventAddress
                    let formatter = NSDateFormatter()
                    formatter.dateStyle = NSDateFormatterStyle.MediumStyle
                    self.eventDateLabel.text = formatter.stringFromDate(self.eventDate)
                   
                    
                }
            }
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
}
