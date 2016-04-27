//
//  TripShowViewController.swift
//  Magellan Application
//
//  Created by Wyeth Jackson on 12/10/15.
//  Copyright © 2015 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
//import RealmSwift

class TripShowViewController: UIViewController, UITableViewDelegate {
    var unwindSegue = false
    var dataEntered = false
    var destinationObjects = [Destination]()
    var initialDate = NSDate()
    var dayObjects = [Day]()
    var dataLoaded = false
    class Day {
        var date: NSDate
        init(date: NSDate) {
            self.date = date
        }
        var eventNames: [String] = []
        var eventAddress: [String] = []
        var eventDescription: [String] = []
        var eventsPresent: Bool = false
        
    }
    
    var dateStrings = [String]()
    class Destination {
        var name: String = ""
        var dates: [NSDate] = []
        var datesPresent: Bool = false
        
    }
    var destinationId = String()
    var headers = [String]()
    var addDateHeaders = ["Destinations"]
    var tableRows = [[String]]()
    var destinations = [String]()
    var destinationIds = [String]()
    var dayId = String()
    var dates = [[NSDate]]()
    var dataToPass = ""
    var secondDataToPass = ""
    var tripId = ""
    @IBOutlet var navigationBar: UINavigationItem!
    var tripName = ""
    var dataToReceive = "fsgfd"
    // query to retrieve parse data
    
    @IBOutlet var tableView: UITableView!
    var query = PFQuery(className: "Trips")
    
    //    query.getObjectInBackgroundWithId(trip.objectId, block: { (object, error) -> Void in
    //    if error != nil {
    //        print(error)
    //    } else {
    //        print(object)
    //    }
    //
    //
    //    })
    //
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        if headers.count > 0 {
          
          
            return headers.count
        } else {
            
            return 0
        }
      
      
        
     
        
    }
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        if segue.sourceViewController .isKindOfClass(tripDatePickViewController) {
            var view: tripDatePickViewController = segue.sourceViewController as! tripDatePickViewController
            
            unwindSegue = true
            
//            var destinationClass = Destination()
//            destinationClass.name = view.destinationName
            
//            destinationClass.dates = view.destinationDates
//            destinationObjects.append(destinationClass)
            var count = 0
            for name in self.headers {
                if name == view.destinationName {
                    dates.append(view.destinationDates)
                    var dateToString = [String]()
                    let formatter = NSDateFormatter()
                    formatter.dateStyle = NSDateFormatterStyle.FullStyle
                    for date in view.destinationDates {
                           dateToString.append(formatter.stringFromDate(date))
                    }
                  
                 
                    self.tableRows[count] = dateToString
                }
                count += 1
            }
            self.tableView.reloadData()

//
            
            
        }
      
    }
    

    
    override func viewDidAppear(animated: Bool) {
//        headers = []
//        tableRows = [[String]]()
//        if dataLoaded == true {
//       
//            
//            var counter = 1
//        
//            if unwindSegue == false {
//                for object in self.destinationObjects {
//                    
//                       
//                        self.headers.append(object.name)
//                        counter += 1
//                    
//                }
//            
//            
//            for object in self.destinationObjects {
//                var counter = 0
//                if object.datesPresent == true {
//                    dateStrings = []
//                    for date in object.dates {
//                        let formatter = NSDateFormatter()
//                        formatter.dateStyle = NSDateFormatterStyle.FullStyle
//                        self.dateStrings.append(formatter.stringFromDate(date))
//                    }
//                    
//                    self.tableRows.append(dateStrings)
//                    
//                } else {
//                    self.tableRows.append(["Add Dates"])
//                }
//            }
//            
//            }
//           
//        }
//        
//        self.dataEntered = true
//        self.tableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if dataLoaded == true {
//            
//            
//            var counter = 1
//            
//            if unwindSegue == false {
//                for object in self.destinationObjects {
//                    
//                    
//                    self.headers.append(object.name)
//                    counter += 1
//                    
//                }
//                
//                
//                for object in self.destinationObjects {
//                    var counter = 0
//                    if object.datesPresent == true {
//                        dateStrings = []
//                        for date in object.dates {
//                            let formatter = NSDateFormatter()
//                            formatter.dateStyle = NSDateFormatterStyle.FullStyle
//                            self.dateStrings.append(formatter.stringFromDate(date))
//                        }
//                        
//                        self.tableRows.append(dateStrings)
//                        
//                    } else {
//                        self.tableRows.append(["Add Dates"])
//                    }
//                }
//                
//            }
//            
//        }
//        
//        self.dataEntered = true
//        self.tableView.reloadData()

        if tableRows.count > 0  {
        
            return self.tableRows[section].count
        } else {
            return 0
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
             let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! tripShowTableViewCell
        let disclosureImage = UIImage(named: "disclosure_indicator.png")
        let disclosureView = UIImageView(image: disclosureImage)
        
        cell.accessoryView = disclosureView
         cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
       
        //        if tripNames.count > 0 {
        
            cell.dateLabel.text = tableRows[indexPath.section][indexPath.row]
            if tableRows[indexPath.section][indexPath.row] == "Add Dates" {
                cell.eventsLabel.hidden = true
            } else {
                cell.eventsLabel.hidden = false
                cell.eventsLabel.text = "Events: None Planned"
            }
        
        //        }
        
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
//        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if tableRows[indexPath.section][indexPath.row] == "Add Dates" {
            Manager.tripId = self.tripId
            Manager.destinationId = self.destinationIds[indexPath.section]
            Manager.destinationName = headers[indexPath.section]
            if indexPath.section > 0 {
                if tableRows[indexPath.section][indexPath.row] != "Add Dates" {
                    Manager.lastDateString = tableRows[indexPath.section - 1].last!
                }
            }
            
            performSegueWithIdentifier("tripShowToDatePickSegue", sender: self)
        
        } else {
            Manager.destinationId = self.destinationIds[indexPath.section]
            Manager.tripId = self.tripId
            Manager.dataToPass = self.dataToPass
            Manager.dateToPass = self.dates[indexPath.section][indexPath.row]
            
        self.performSegueWithIdentifier("tripShowToDayShowSegue", sender: self)
        }
        
        
        
        
        
        
        
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     
            return headers[section]
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataToReceive = Manager.dataToPass
        Manager.tripId = self.dataToReceive
        var tripQuery = PFQuery(className: "Trips")
        
        var userTrip = tripQuery.whereKey("objectId", equalTo: self.dataToReceive)
        var counter = 1
        userTrip.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let trip = objects {
                for object in trip {
            
                    if object["destinations"] is NSArray {
                        for var index = 0; index < object["destinations"].count; index++ {
                            self.destinations.append(object["destinations"][index] as! String)
//                            self.addDateHeaders.append(object["destinations"] as! String)
                        }
                    }
                    
                    
                    
                    self.tripName = object["name"] as! String
                    self.tripId = object.objectId!
                    if self.tripName != "" {
                    self.navigationItem.title = self.tripName
                    
                    var destinationQuery = PFQuery(className: "Destinations")
                      var specificDestinationQuery = destinationQuery.whereKey("tripId", equalTo: self.tripId)
                    specificDestinationQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if let destinationQueries = objects {
                            for object in destinationQueries {
                                self.destinationIds.append(object.objectId!)
                                var destination = Destination()
                                self.destinationId = object.objectId!
                                self.headers = self.destinations
                                destination.name = object["destinationName"] as! String
                                 destination.datesPresent = object["destinationDates"] as! Bool
                                if destination.datesPresent == true {
                                    self.dates.append(object["destinationDays"] as! [NSDate])
                                     destination.dates = object["destinationDays"] as! [NSDate]
                                     var dateToString = [String]()
                                    for date in object["destinationDays"] as! NSArray {
                                       
                                        let formatter = NSDateFormatter()
                                        formatter.dateStyle = NSDateFormatterStyle.FullStyle
                                        
                                        dateToString.append(formatter.stringFromDate(date as! NSDate))
                                        
                                    }
                                    
                                    self.tableRows.append(dateToString)
                                    
                                } else {
                                    self.tableRows.append(["Add Dates"])
                                }
                                
                               self.destinationObjects.append(destination)
                               
                                
                                var dayQuery = PFQuery(className: "Days")
                                var specificDayQuery = dayQuery.whereKey("destinationId", equalTo: self.destinationId)
                                specificDayQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                    if let specificDays = objects {
                                        for object in specificDays {
                                            var day = Day(date: object["date"] as! NSDate)
                                            day.eventsPresent = object["eventsPresent"] as! Bool
                                            self.dayId = object.objectId!
                                            
                                            var eventQuery = PFQuery(className: "Events")
                                            var specificEventQuery = eventQuery.whereKey("dayId", equalTo: self.dayId)
                                            
                                            specificEventQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                                if let specificEvents = objects {
                                                    for object in specificEvents {
                                                        day.eventNames.append(object["name"] as! String)
                                                        day.eventAddress.append(object["address"] as! String)
                                                        day.eventDescription.append(object["description"] as! String)
                                                         self.dayObjects.append(day)
                                                        
                                                    }
                                                }
                                                
                                                
                                           
                                                
                                               
                                                
                                                self.dataLoaded = true
                                                
                                                self.tableView.reloadData()
                                            })
                                          
                                            
                                        }
                                    }
                                    
                                    self.dataLoaded = true
                                    
                                    self.tableView.reloadData()
                                  
                                })
                                
                                
                                
                            }
                        }
                    })
                        
                    
                        
                    }
                  
                }
                
                self.tableView.reloadData()
            }
            
        })
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addEventButton(sender: AnyObject) {
        
        Manager.tripId = self.tripId
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
}