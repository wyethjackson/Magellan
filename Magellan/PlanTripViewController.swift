//
//  PlanTripViewController.swift
//  Magellan Single View
//
//  Created by Wyeth Jackson on 12/8/15.
//  Copyright © 2015 Wyeth Jackson. All rights reserved.
//

import UIKit
import MapKit
import Parse
//import RealmSwift
//import GoogleMaps
//import GooglePlacesAutocomplete



var count = 0
class Trip {}
class PlanTripViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate {
    var firstSectionRows = ["Add a Trip Name", "Add a Destination"]
    var destinations = [String]()
    var destinationLatitudes = [Double]()
    var destinationLongitudes = [Double]()
    var destinationSearchLatitude = Double()
    var destinationSearchLongitude = Double()
     var tripName = ""
        @IBOutlet var tripNameTableView: UITableView!
    
    @IBOutlet var destinationNameLabel: UILabel!
    
    @IBOutlet var destinationTableView: UITableView!
    
    var tableViewHeaders = ["Add Trip Info", "Destinations"]
    
   var tripId = String()
    
    
    
//    let gpaViewController = GooglePlacesAutocomplete(
//        apiKey: "AIzaSyD1xM1wShndemdkX1FT3fE1W4uTL1oZ-hU",
//        placeType: .Address
//    )
//    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var destinationSearchBar: UISearchBar!
    


    
    var currentUser = PFUser.currentUser()
    var newTrip = Trip()
    var trip = PFObject(className: "Trips")
//    var tripName = ""
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    

    
    @IBOutlet var tripNameLabel: UILabel!
    @IBOutlet var planTripNavBar: UINavigationBar!
    
    @IBOutlet var tripNameTextField: UITextField!
//    @IBOutlet var destinationTableView: UITableView!
    
    @IBAction func addTripButton(sender: AnyObject) {
        print(destinations)
        var tripId = String()
        if destinations != [] && tripName != "" {
         

            trip["name"] = tripName
            trip["destinations"] = destinations
            trip["shareTrip"] = shareTrip
            var userId = currentUser!.objectId!
            print(userId)
            trip["userId"] = userId

            
            
            trip.saveInBackgroundWithBlock( { (success, error) -> Void in
                
                if success == true {
                    print("Successful")
         
                } else {
                    print("Failed")
                    print(error)
                }
                
            })
            
          
            var alertController:UIAlertController?
            
                    alertController = UIAlertController(title: "Trip Name", message: "Please Enter A Trip Name", preferredStyle: .Alert)
            
                    alertController!.addTextFieldWithConfigurationHandler(
                        {(textField: UITextField!) in
                            textField.placeholder = "e.g. Family Euro Trip"
                    })
                    let action = UIAlertAction(title: "Submit",
                        style: UIAlertActionStyle.Default,
                        handler: {[weak self]
                            (paramAction:UIAlertAction!) in
                            if let textFields = alertController?.textFields{
                                let theTextFields = textFields as [UITextField]
                                let enteredText = theTextFields[0].text
                                self!.tripName = enteredText!
            
            
                            }
                        })

           
          self.performSegueWithIdentifier("manualPlanTripToHome", sender: self)
        } else {
            self.displayAlert("oops!", message: "You Must Enter A Trip Name and A Destination!")
        }
    }

    var destinationCities = [String]()
    var destinationCountries = [String]()
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        if segue.sourceViewController .isKindOfClass(addTripNameViewController) {
            var tripNameView:addTripNameViewController = segue.sourceViewController as! addTripNameViewController
            if tripNameView.whichInfo == "name" {
                tripName = tripNameView.tripName
                
            } else if tripNameView.whichInfo == "destination" {
                destinations.append(tripNameView.destination)
                trip["destinations"] = destinations
                trip.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success == true {
                        var destination = PFObject(className: "Destinations")
                        destination["userId"] = PFUser.currentUser()?.objectId
                        destination["tripId"] = self.trip.objectId
                        self.tripId = self.trip.objectId!
                        destination["destinationCity"] = tripNameView.destinationCity
                        destination["destinationCountry"] = tripNameView.destinationCountry
                        destination["destinationName"] = tripNameView.destination
                        destination["destinationDates"] = false
                        let geoPoint = PFGeoPoint(latitude: tripNameView.destinationSearchLatitude, longitude: tripNameView.destinationSearchLongitude)
                        destination["geoPoint"] = geoPoint
                        
                        destination.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if success == true {
                                print("Successful")
                                
                            } else {
                                print("Failed")
                                print(error)
                            }
                        })
                        

                    } else {
                        print("failed")
                        print(error)
                    }
                })
                
                destinationLatitudes.append(tripNameView.destinationSearchLatitude)
                destinationLongitudes.append(tripNameView.destinationSearchLongitude)
                destinationCities.append(tripNameView.destinationCity)
                destinationCountries.append(tripNameView.destinationCountry)
                
            }
            tripNameTableView.reloadData()
        }
    }
    
    var shareTrip = true
    
    
    @IBOutlet var shareTripSwitch: UISwitch!
    
    @IBAction func shareTripButtonAction(sender: AnyObject) {
        
        if shareTripSwitch.on {
            shareTrip = false
        } else {
             shareTrip = true
        }
        
        

        
    }
    
    
    @IBAction func cancelTripButton(sender: AnyObject) {
        var tripQuery = PFQuery(className: "Trips")
        var specificTripQuery = tripQuery.whereKey("objectId", equalTo: self.tripId)
        specificTripQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let tripQueries = objects {
                for object in tripQueries {
                    
                      var destinationQuery = PFQuery(className: "Destinations")
                    
                    var specificDestinationQueries = destinationQuery.whereKey("tripId", equalTo: self.tripId)
                    specificDestinationQueries.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if let destinationQueries = objects {
                            for destinationObjects in destinationQueries {
                                destinationObjects.deleteInBackground()
                            }
                        }
                        object.deleteInBackground()
                        
                    })
                    
                    
                }
            }
        }
      
        self.performSegueWithIdentifier("manualPlanTripToHome", sender: self)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tripNameTableView.reloadData()
    }
    
//    @IBAction func addDestination(sender: AnyObject) {
//        self.destinationLatitudes.append(destinationSearchLatitude)
//        self.destinationLongitudes.append(destinationSearchLongitude)
//        destinations.append(self.searchBarText)
//        trip["destinations"] = destinations
//        trip.saveInBackgroundWithBlock { (success, error) -> Void in
//            if success == true {
//                print("Successful")
//            } else {
//                print("Failed")
//                print(error)
//            }
//        }
//      searchController.searchBar.text = ""
//        destinationTableView.reloadData()
//        
//    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                Manager.dataToPass = "name"
            } else if indexPath.row == 1 {
                Manager.dataToPass = "destination"
            }
            
            self.performSegueWithIdentifier("planTripAddNameSegue", sender: self)
        }
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripNameTableView.reloadData()
    }
    
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return tableViewHeaders[section]
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            if destinations.count > 0 {
            return destinations.count
            } else {
                return 1
            }
        }
        
          return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
          let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "tripNameCell")
        if indexPath.section == 0 {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            if indexPath.row == 0 {
                if tripName != "" {
                    cell.textLabel!.text = tripName
                    
                } else {
                    cell.textLabel!.text = firstSectionRows[indexPath.row]
//                    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                }
            } else if indexPath.row == 1 {
                cell.textLabel!.text = firstSectionRows[indexPath.row]
            }
        } else if indexPath.section == 1 {
            if destinations.count > 0 {
                cell.textLabel!.text = destinations[indexPath.row]
            } else {
                cell.textLabel!.text = "No destinations added yet"
            }
        }
       
        
            
            let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurView = UIVisualEffectView(effect: blur)
            
//            cell.textLabel?.textAlignment = NSTextAlignment.Center
        
            cell.backgroundColor = UIColor.clearColor()
            cell.backgroundView = blurView
            
            cell.tintColor = UIColor.blackColor()
          
        
             return cell
        }
    
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    
    }
    
    

    





    




