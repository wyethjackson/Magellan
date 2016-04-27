//
//  manualAddEventController.swift
//  Magellan Application
//
//  Created by Wyeth Jackson on 1/19/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class manualAddEventController: UIViewController {
    var tripEvents = String()
    var dataToReceive = String()
    var date = NSDate()
    var dayId = String()
    var dataToPass = String()
    var dateToPass = NSDate()
    var tripId = String()
    
    @IBOutlet var tableView: UITableView!
    
    
    var eventDate = NSDate()
    var eventDatePresent = false
    var manualEventInfo = ["Event Name", "Event Address", "Event Description"]
    var eventInformation = ["Event Name", "Event Address", "Event Description"]
    @IBOutlet var eventName: UITextField!
    @IBOutlet var eventAddress: UITextField!
    
    @IBOutlet var eventDescription: UITextField!
    
    @IBAction func addEvent(sender: AnyObject) {
        var event = PFObject(className: "Events")
        event["name"] = eventName.text
        event["address"] = eventAddress.text
        event["description"] = eventDescription.text
        event["date"] = self.date
        event.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success == true {
                print("Successful")
                
            }else {
                print("Failed")
                print(error)
            }
            
        })
        Manager.dataToPass = self.dataToPass
        Manager.dateToPass = self.date
        Manager.secondDataToPass = "event added"
        Manager.tripId = tripId
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        var secondTab = self.tabBarController?.viewControllers![1] as! eventAddViewController
        //        secondTab = date
//        if Manager.eventInfoData != "" {
//            if Manager.secondDataToPass == "Event Date" {
//                eventDate = Manager.eventDateInfo
//                eventDatePresent = true
//            } else {
//                for var index = 0; index < eventInformation.count; index++ {
//                    if eventInformation[index] == Manager.secondDataToPass {
//                        manualEventInfo[index] = Manager.eventInfoData
//                    }
//                }
//            }
//        }
        self.tripEvents = Manager.dataToPass
        self.tripId = Manager.tripId
        if tripEvents == "Trip Events" {
            manualEventInfo.append("Event Date")
        }
        Manager.dataToPass = self.dataToReceive
        print("manager " + Manager.dataToPass)
        self.date = Manager.dateToPass
        var dayQuery = PFQuery(className: "Days")
        
        var specificDay = dayQuery.whereKey("objectId", equalTo: self.dataToReceive)
        
        specificDay.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let day = objects {
                for object in day {
                    object["date"] = self.date
                    object["date"] = self.dateToPass
                    object["destinationId"] = self.dataToPass
                    self.dayId = object.objectId!
                    print("Day ID " + self.dayId)
                    
                }
            }
            
            
        })
        
        
    }
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if segue.sourceViewController .isKindOfClass(manualAddEventFieldsViewController) {
            var viewData:manualAddEventFieldsViewController = segue.sourceViewController as! manualAddEventFieldsViewController
            
        
            
            if viewData != "" {
                if viewData.eventInfo == "Event Date" {
                    eventDate = viewData.eventDateInfo
                    eventDatePresent = true
                } else {
                    for var index = 0; index < eventInformation.count; index++ {
                        if eventInformation[index] == viewData.eventInfo {
                            manualEventInfo[index] = viewData.eventInfoData
                        }
                    }
                }
               
            }
             tableView.reloadData()
            
        }
        
       
        tableView.reloadData()
        //        self.businessCategoriesSelected = Manager.businessCategoriesSelected
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manualEventInfo.count
      
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        //        print(userTripCount)
        //        print(tripNames)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
          cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if eventDatePresent == true {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            cell.textLabel?.text = formatter.stringFromDate(self.eventDate as! NSDate)
           
        } else {
            cell.textLabel?.text = manualEventInfo[indexPath.row]
        }
    
        return cell
        
    }
    
    //    objectId = NSUserDefaults.standardUserDefaults().objectForKey("objectId") as [String]
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let path = self.tableView.indexPathForSelectedRow!
        //        segue.tripShowViewController.detail = self.detailForIndexPath(path)
        //        print(tripIds[indexPath.row])
      
            Manager.dataToPass = manualEventInfo[indexPath.row]
            Manager.tripId = self.tripId
        
            
        
        self.performSegueWithIdentifier("manualAddEventToSpecificFields", sender: self)
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
}
