//
//  tripDatePickViewController.swift
//  Magellan Application
//
//  Created by Wyeth Jackson on 12/24/15.
//  Copyright © 2015 Wyeth Jackson. All rights reserved.
//


import UIKit
import Parse
//import RealmSwift

class tripDatePickViewController: UIViewController {
    
    
    @IBOutlet var lastDateLabel: UILabel!
    
    @IBOutlet var lastDateBlurEffect: UIVisualEffectView!
    var lastDateString = ""
    var destinationName = ""
    var tripId = ""
    var dataToReceive = ""
    var secondDataToReceive = ""
    var dataToPass = ""
    var secondDataToPass = ""
    var startDate = NSDate()
    var endDate = NSDate()
    var destinationDates = [NSDate]()
    var destinationId = String()
    @IBOutlet var destinationEndDate: UIDatePicker!
    @IBOutlet var destinationStartDate: UIDatePicker!
    @IBAction func dateSubmit(sender: AnyObject) {
        
        print(self.destinationStartDate.date)
        
        var destinationQuery = PFQuery(className: "Destinations")
        
        var date = self.destinationStartDate.date
        var endDate = self.destinationEndDate.date
        
        let calendar = NSCalendar.currentCalendar()
        while date != endDate {
            
            
            self.destinationDates.append(date)
            date = calendar.dateByAddingUnit(.Day, value: 1, toDate: date, options: [])!
            
            print(destinationDates)
            
            
            
        }
        self.destinationDates.append(endDate)
        
        destinationQuery.getObjectInBackgroundWithId(self.destinationId){ (destination: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let destination = destination {
                print(destination)
                destination["startDate"] = self.destinationStartDate.date
                destination["endDate"] = self.destinationEndDate.date
                destination["destinationDates"] = true
                destination["destinationDays"] = self.destinationDates
                destination.saveInBackground()
            }
        }

        
        for date in destinationDates {
            var days = PFObject(className: "Days")
            days["date"] = date
            days["destinationId"] = destinationId
            days["eventsPresent"] = false
            days.saveInBackgroundWithBlock { (success, error) -> Void in
                if success == true {
                    print("success")
                } else {
                    print("failed")
                    print(error)
                }
            }
           
        }
        
        
       
        
       

        Manager.dataToPass = self.destinationName
        Manager.secondDataToPass = self.tripId
        
        self.performSegueWithIdentifier("destinationDateUnwind", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lastDateString = Manager.lastDateString
        if self.lastDateString != "" {
            lastDateLabel.text = "Suggested Start Date: After \(self.lastDateString)"
            lastDateLabel.hidden = false
            lastDateBlurEffect.hidden = false
        } else {
            lastDateBlurEffect.hidden = true
            lastDateLabel.hidden = true
        }
        self.tripId = self.dataToReceive as! String
        self.destinationName = self.secondDataToReceive as! String
        self.destinationName = Manager.destinationName
        self.tripId = Manager.tripId
        self.destinationId = Manager.destinationId
        self.dataToReceive = Manager.dataToPass
        self.secondDataToReceive = Manager.secondDataToPass
   
       
        //
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}