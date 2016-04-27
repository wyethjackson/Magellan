 //
 //  dayShowViewController.swift
 //  Magellan Application
 //
 //  Created by Wyeth Jackson on 1/14/16.
 //  Copyright © 2016 Wyeth Jackson. All rights reserved.
 //
 
 import UIKit
 import Parse
// import RealmSwift
 
 class dayShowViewController: UIViewController, UITableViewDelegate {
    
    var dataToReceive = String()
    var dateToReceive = NSDate()
    var dateToPass = NSDate()
    var dayId = String()
    var date = NSDate()
    var stringDate = String()
    @IBOutlet var navigationBar: UINavigationBar!
    var events = [String]()
    var destinationDates = [NSDate]()
    var destinationId = String()
    var tripId = String()
    @IBOutlet var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.events.count > 0 {
            return events.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "eventCell")
        //        print(userTripCount)
        //        print(tripNames)
        
        
        if events.count > 0 {
            cell.textLabel?.text = events[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            cell.textLabel?.text = "No events have been planned for today"
        }
        
        
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
        //        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        //         cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
        
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        
        
        return cell
        
    }
    
    //    objectId = NSUserDefaults.standardUserDefaults().objectForKey("objectId") as [String]
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        //        let path = self.tableView.indexPathForSelectedRow!
    //        //        segue.tripShowViewController.detail = self.detailForIndexPath(path)
    //        //        print(tripIds[indexPath.row])
    //        dateToPass = self.destinationDates[indexPath.row]
    //        dataToPass = self.destinationId
    //        Manager.dateToPass = self.dateToPass
    //        Manager.dataToPass = self.dataToPass
    //        self.performSegueWithIdentifier("destinationToDayShow", sender: self.destinationDates[indexPath.row])
    //
    //
    //
    //    }
    
    
    @IBAction func addEvent(sender: AnyObject) {
        self.dateToPass = self.date
        Manager.dateToPass = self.dateToPass
        Manager.tripId = self.tripId
        Manager.destinationId = self.destinationId
        Manager.dayId = self.dayId
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tripId = Manager.tripId
        self.destinationId = Manager.destinationId
        self.dataToReceive = Manager.dataToPass
        self.dateToReceive = Manager.dateToPass
        self.dayId = Manager.dayId
        self.date = self.dateToReceive
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        self.stringDate = formatter.stringFromDate(self.date)
        
        navigationItem.title = self.stringDate
        
        var dayQuery = PFQuery(className: "Days")
        var specificDayQuery = dayQuery.whereKey("objectId", equalTo: self.dayId)
        specificDayQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let days = objects {
                for object in days {
                    self.date = object["date"] as! NSDate
                    
                }
            }
        }
  
//        self.events.append("Whatuppppp")
//        var destinationQuery = PFQuery(className: "Destinations")
//        
//        var userDestination = destinationQuery.whereKey("objectId", equalTo: self.dataToReceive)
//        
////        var specificDay = userDays.whereKey("date", equalTo: self.dateToReceive)
//        
//            userDestination.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
//            if let destination = objects {
//                for object in destination {
//                    self.destinationDates = object["destinationDays"]  as! [NSDate]
//                }
//            }
//            
//            
//        })
//        
//        for dates in self.destinationDates {
//            if dateToReceive == dates {
//                self.date = dates
//            }
//        }
        
        if Manager.secondDataToPass == "event added" {
            let btnName = UIButton()
            btnName.setImage(UIImage(named: "home.png"), forState: .Normal)
            btnName.frame = CGRectMake(0, 0, 30, 30)
            btnName.addTarget(self, action: Selector("action"), forControlEvents: .TouchUpInside)
            
            //.... Set Right/Left Bar Button item
            let leftBarButton = UIBarButtonItem()
           leftBarButton.customView = btnName
            self.navigationItem.rightBarButtonItem = leftBarButton
            
        }
        
        var eventQuery = PFQuery(className: "Events")
        var userEvents = eventQuery.whereKey("date", equalTo: self.date)
        userEvents.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            print(objects)
            if let event = objects {
                print(event)
                for object in event {
                    print(object["name"])
                    self.events.append(object["name"] as! String)
                    print(self.events)
                }
            }
            self.tableView.reloadData()
        })
        print("yoooooo")
        print(self.events)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
 }