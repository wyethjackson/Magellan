//
//  destinationShowViewController.swift
//  Magellan Application
//
//  Created by Wyeth Jackson on 1/12/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
//import RealmSwift

class destinationShowViewController: UIViewController, UITableViewDelegate {
    var datesPresent = Bool()
    var dataToReceive = ""
    var secondDataToReceive = ""
    var destinationName = ""
    var dataToPass = ""
    var secondDataToPass = ""
    var dayIds = [String]()
    
    @IBOutlet var selectDatesLabelVisualBlur: UIVisualEffectView!
    
    
    var tripId = ""
    var destinationId = ""
    @IBOutlet var destinationsTableView: UITableView!
    var dateId = ""
    var dateToPass = NSDate()
    var destinationStartDate = NSDate()
    var destinationEndDate = NSDate()
    var destinationDates = [NSDate]()
   
    @IBOutlet var selectDatesButton: UIButton!
    
    @IBOutlet var selectDatesLabel: UILabel!
    
    @IBOutlet var startDateLabel: UILabel!
    
    @IBOutlet var selectDatesTableView: UITableView!
    
    @IBOutlet var endDateLabel: UILabel!
    
    
    @IBAction func addDates(sender: AnyObject) {
       
    }
    @IBOutlet var navigationBar: UINavigationBar!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectDatesTableView {
            return 1
        } else {
             return self.destinationDates.count
        }
       
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if tableView == selectDatesTableView {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "selectDatesCell")
            cell.textLabel?.text = "Select dates for your destination!"
             cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
           
        } else {
        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "dayCell")
            if self.destinationDates.count > 0 {
                let formatter = NSDateFormatter()
                formatter.dateStyle = NSDateFormatterStyle.MediumStyle
                cell.textLabel?.text = formatter.stringFromDate(self.destinationDates[indexPath.row] as! NSDate)
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
            }
    
            
          
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
    
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        
        if tableView == selectDatesTableView {
            dataToPass = self.tripId
            secondDataToPass = self.destinationName
            Manager.dataToPass = self.dataToPass
            Manager.secondDataToPass = self.secondDataToPass
            Manager.destinationId = self.destinationId
            self.performSegueWithIdentifier("destinationShowToDatePicker", sender: self)
        } else {
            
            Manager.dateToPass = self.destinationDates[indexPath.row]
            Manager.destinationId = self.destinationId
            Manager.dateToPass = self.dateToPass
            Manager.dataToPass = self.dataToPass
            Manager.tripId = tripId
            Manager.dayId = dayIds[indexPath.row]
            self.performSegueWithIdentifier("destinationToDayShow", sender: self.destinationDates[indexPath.row])
        }
        
        
        
    }
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        if segue.sourceViewController .isKindOfClass(tripDatePickViewController) {
            
         
            
            var view:tripDatePickViewController = segue.sourceViewController as! tripDatePickViewController
            tripId = view.tripId
            destinationName = view.destinationName
            var destinationQuery = PFQuery(className: "Destinations")
            
            var userDestinations = destinationQuery.whereKey("tripId", equalTo: tripId)
            
            var specificDestination = userDestinations.whereKey("destinationName", equalTo: destinationName)
            
            specificDestination.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if let destination = objects {
                    for object in destination {
                        
                        self.destinationId = object.objectId!
                        
                        if object["destinationDates"] as! Bool == true {
                            
                            //                            self.destinationsTableView.hidden = false
                            self.selectDatesLabel.hidden = true
                            self.selectDatesTableView.hidden = true
                               self.selectDatesLabelVisualBlur.hidden = true
                            self.destinationDates = object["destinationDays"] as! [NSDate]
                            self.datesPresent = object["destinationDates"] as! Bool
                            
                            var dayQuery = PFQuery(className: "Days")
                            var specificDayQuery = dayQuery.whereKey("destinationId", equalTo: self.destinationId)
                            
                            specificDayQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                                if let days = objects {
                                    self.destinationDates = []
                                    for object in days {
                                        self.destinationDates.append(object["date"] as! NSDate)
                                        self.dayIds.append(object.objectId!)
                                      
                                    }
                                    self.destinationDates.sortInPlace { (a, b) -> Bool in
                                        a.earlierDate(b) == a
                                    }
                                    
                                }
                                self.destinationsTableView.reloadData()
                            }

                            
                        }
                        
                        self.destinationsTableView.reloadData()
                        
                        
                    }
                    
                    self.destinationsTableView.reloadData()
                }
                
            })
            
            
         
            
            
            
            
            
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.dateId = Manager.thirdDataToPass
        self.dataToReceive = Manager.dataToPass
        self.secondDataToReceive = Manager.secondDataToPass
        self.destinationName = self.dataToReceive as! String
        self.tripId = self.secondDataToReceive as! String
//        print(self.destinationName)
//        print(self.tripId)
        self.navigationItem.title = self.destinationName
        
        
        var destinationQuery = PFQuery(className: "Destinations")
        
        var userDestinations = destinationQuery.whereKey("tripId", equalTo: self.secondDataToReceive)
        
        var specificDestination = userDestinations.whereKey("destinationName", equalTo: self.dataToReceive)
        
        specificDestination.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let destination = objects {
                for object in destination {
                    
                    self.destinationId = object.objectId!
                    print(object.objectId!)
                        if object["destinationDates"] as! Bool == true {
                            
//                            self.destinationsTableView.hidden = false
                            self.selectDatesLabel.hidden = true
                            self.selectDatesTableView.hidden = true
                            self.selectDatesLabelVisualBlur.hidden = true
//                           self.destinationDates = object["destinationDays"] as! [NSDate]
                            self.datesPresent = object["destinationDates"] as! Bool
                          
                            var dayQuery = PFQuery(className: "Days")
                            var specificDayQuery = dayQuery.whereKey("destinationId", equalTo: self.destinationId)
                            
                            specificDayQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                                if let days = objects {
                                    
                                    for object in days {
                                        self.destinationDates.append(object["date"] as! NSDate)
                                        self.dayIds.append(object.objectId!)
                                       
                                    }
                                    
                                    self.destinationDates.sortInPlace { (a, b) -> Bool in
                                        a.earlierDate(b) == a
                                    }
                                }
                                self.destinationsTableView.reloadData()
                            }
                            self.destinationsTableView.reloadData()
                            //        }
                            print(self.dayIds)

                            
                            

                            
                            
                           
                        }

                        self.destinationsTableView.reloadData()
                        
                 
                                   }
                
                self.destinationsTableView.reloadData()
            }
            
        })
        
      print(self.destinationDates)
//        if self.datesPresent == true {
            print("heyyyyyyy")
            print(self.destinationId)
               }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
}