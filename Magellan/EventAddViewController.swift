//
//  eventAddViewController.swift
//  Magellan Application
//
//  Created by Wyeth Jackson on 1/19/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
//import RealmSwift

class eventAddViewController: UIViewController, UITableViewDelegate {
    var dataToReceive = String()
    var date = NSDate()
    var destinationName = String()
    var destinationId = String()
    @IBOutlet var searchBar: UISearchBar!
    var tripId = String()
    var geoPoint = PFGeoPoint()
    var companyId = [String]()
    var companyNames = [String]()
    var eventNames = [String]()
    var destinationCity = String()
    var destinationCountry = String()
    var eventAddresses = [String]()
    var eventIds = [String]()
    var dayId = String()
    
    @IBOutlet var eventTableView: UITableView!
    @IBOutlet var eventNavigationItem: UINavigationItem!
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("event Names return 1")
        print(eventNames.count)
        if eventNames.count == 0 {
            return 1
        } else {
            return eventNames.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! topEventsCell
        print("eventNames tableView")
        print(eventNames)
        if eventNames.count == 0 {
            cell.eventNameLabel.hidden = true
            cell.companyNameLabel.hidden = true
            cell.eventAddressLabel.hidden = true
            cell.textLabel!.text = "No Top Events Are Near You!"
            cell.textLabel?.textAlignment = .Center
  
        } else {
            var counter = 1
           cell.textLabel!.text = ""
            cell.eventNameLabel.hidden = false
//            cell.companyNameLabel.hidden = false
            cell.eventAddressLabel.hidden = false
            cell.eventNameLabel.text = eventNames[indexPath.row]
            //            cell.companyNameLabel.text = companyNames[indexPath.row]
            cell.eventAddressLabel.text = eventAddresses[indexPath.row]
           
        }
      
        //        print(userTripCount)
        //        print(tripNames)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        

        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
       cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
       
        
        
        
        
        return cell
        
    }
    
    //    objectId = NSUserDefaults.standardUserDefaults().objectForKey("objectId") as [String]
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let path = self.tableView.indexPathForSelectedRow!
        //        segue.tripShowViewController.detail = self.detailForIndexPath(path)
        //        print(tripIds[indexPath.row])
//        if tripNames.count > 0 {
//            dataToPass = tripIds[indexPath.row]
//            Manager.dataToPass = self.dataToPass
//            self.performSegueWithIdentifier("homeToTripShow", sender: tripIds[indexPath.row])
//        }
        
        if eventIds.count > 0 {
            Manager.eventId = eventIds[indexPath.row]
            Manager.companyId = companyId[indexPath.row]
            Manager.dayId = dayId
        self.performSegueWithIdentifier("eventAddToEventShowSegue", sender: self)
        }
        
        
        
        
    }

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.destinationId = Manager.destinationId
        print(self.destinationId)
        self.tripId = Manager.tripId
        self.date = Manager.dateToPass
        self.dayId = Manager.dayId
        var destinationQuery = PFQuery(className: "Destinations")
        var specificDestinationQuery = destinationQuery.whereKey("objectId", equalTo: self.destinationId)
        
        specificDestinationQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let destinations = objects {
                for object in destinations {
                    self.geoPoint = object["geoPoint"] as! PFGeoPoint
                    self.destinationName = object["destinationName"] as! String
                    
                    let geoCoder = CLGeocoder()
                    
                    print("latitude")
                    print(self.geoPoint.latitude)
                    let location = CLLocation(latitude: self.geoPoint.latitude, longitude: self.geoPoint.longitude)
                    
                    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                       
                        // Place details
                        var placeMark: CLPlacemark!
                        
                        placeMark = placemarks?[0]
                        
                        
                        
                        
                        
                        
                        
                        // City
                        if let city = placeMark.addressDictionary!["City"] as? NSString {
                            print(city)
                            self.destinationCity = city as String
                        }
                        
                        
                        // Country
                        if let country = placeMark.addressDictionary!["Country"] as? NSString {
                            print(country)
                            self.destinationCountry = country as String
                        }
                        self.eventTableView.reloadData()
                         self.eventNavigationItem.title = "Top Events in \(self.destinationCity), \(self.destinationCountry)"
                    })
                    
                    
                    
                    
                    
                   
                    
                    var eventQuery = PFQuery(className: "Events")
//                    var eventDateQuery = eventQuery.whereKey("date", equalTo: self.date)
                    var specificEvents = eventQuery.whereKey("geoPoint", nearGeoPoint: self.geoPoint, withinMiles: 100)
                    
                    specificEvents.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                        if let eventObjects = objects {
                            for object in eventObjects {
                                // ******** defining event info variables goes here *************
                                self.companyId.append(object["companyId"] as! String)
                                self.eventNames.append(object["name"] as! String)
                                self.eventAddresses.append(object["address"] as! String)
                                self.eventIds.append(object.objectId!)
                            }
                            
                            
                            for company in self.companyId {
                                var companyQuery = PFUser.query()
                                print("company")
                                print(company)
                                companyQuery?.whereKey("companyId", equalTo: company)
                                var specificCompanyQuery = companyQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                    if let businesses = objects {
                                        for companyObjects in businesses {
                                            self.companyNames.append(companyObjects["companyName"] as! String)
                                           
                                            print(self.companyNames)
                                            print(self.eventNames)
                                        }
                                    }
                                    self.eventTableView.reloadData()
                                })
                                self.eventTableView.reloadData()
                            }
                            
                            
                            
                        }
                    }
                    
                
                    
                    
                    
                }
            }
        }
        
    
      self.eventTableView.reloadData()
//        Manager.dataToPass = self.dataToReceive
//        
//        var dayQuery = PFQuery(className: "Days")
//        
//        var specificDay = dayQuery.whereKey("objectId", equalTo: self.dataToReceive)
//        
//        specificDay.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
//            if let day = objects {
//                for object in day {
//                    object["date"] = self.date
//                    object["destinationId"] = self.destinationId
//                    
//                }
//            }
//            
//            
//        })
//        
//        var destinationQuery = PFQuery(className: "Destinations")
//        
//        var specificDestination = destinationQuery.whereKey("objectId", equalTo: self.destinationId)
//        
//        
//        destinationQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//            if let destination = objects {
//                for object in destination {
//                    object["name"] = self.destinationName
//                }
//            }
//        }
//        print("yooooo")
//        
//        let url = NSURL(string: "http://www.eventful.com")!
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
//            
//            if let urlContent = data {
//                
//                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
//                
//                print("hey")
//                print(webContent)
//                
//                
//            } else {
//                print(error)
//                //show error message
//            }
//            // Will happen when task completes
//        }
//        
//        task.resume()
        
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
}