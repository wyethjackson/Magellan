//
//  ViewController.swift
//  Magellan Application
//
//  Created by Wyeth Jackson on 12/9/15.
//  Copyright © 2015 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps
//import RealmSwift
class ViewController: UIViewController, UITableViewDelegate {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet var magellanImageView: UIImageView!
    
    
    
    var noDestination = [String]()
    
    @IBOutlet var tableView: UITableView!
    var dataToPass = ""

    @IBOutlet var upcomingTripsLabel: UILabel!
    
    @IBOutlet var upcomingTripsBlurView: UIVisualEffectView!
    var headers = ["Upcoming Trips", "Connect"]
    var explorePeople = "Add other travel enthusiasts to your network!"
//    @IBAction func signOutButton(sender: AnyObject) {
//        
//        PFUser.logOut()
//        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("signIn") as! UIViewController
//            self.presentViewController(viewController, animated: true, completion: nil)
//        })
//        
//    }
    var userTripCount = 0
   var destinationStrings = [String]()
    var tripNames = [String]()
    var tripIds = [String]()
    var firstDestinations = [String]()
    var destinations = [[String]]()
    
    //    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return userTripCount
    //    }
    //
    //    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
    //        cell.textLabel?.text = tripNames[indexPath.item]
    //        return cell
    //    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return headers[section]
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return headers.count
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if destinationStrings.count > 0 {
            return destinationStrings.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "homeCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("homeCell", forIndexPath: indexPath) as! viewControllerCell

        //        print(userTripCount)
        //        print(tripNames)
      
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
//        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
        
        
        if destinationStrings.count > 0 {
            cell.tripNameLabel.text = tripNames[indexPath.row]
           print(destinationStrings)
            cell.destinationsLabel.text = destinationStrings[indexPath.row]
            let disclosureImage = UIImage(named: "disclosure_indicator.png")
            let disclosureView = UIImageView(image: disclosureImage)
          
            cell.accessoryView = disclosureView
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
//            upcomingTripsBlurView.hidden = false
            cell.tripNameLabel.hidden = false
            cell.destinationsLabel.hidden = false
            cell.textLabel!.text = ""
            
//            upcomingTripsLabel.hidden = false
        } else if noDestination.count > 0 {
//            upcomingTripsBlurView.hidden = true
//            upcomingTripsLabel.hidden = true
            cell.tripNameLabel.hidden = true
            cell.destinationsLabel.hidden = true
            
            cell.textLabel?.text = noDestination[0]
        }
        
        if indexPath.section == 1 {
            cell.tripNameLabel.hidden = true
            cell.destinationsLabel.hidden = true
            cell.textLabel!.text = explorePeople
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
       
        
        return cell
        
    }
    
    //    objectId = NSUserDefaults.standardUserDefaults().objectForKey("objectId") as [String]
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let path = self.tableView.indexPathForSelectedRow!
        //        segue.tripShowViewController.detail = self.detailForIndexPath(path)
        //        print(tripIds[indexPath.row])
        if indexPath.section == 0 {
            if tripNames.count > 0 {
                dataToPass = tripIds[indexPath.row]
                Manager.dataToPass = self.dataToPass
                self.performSegueWithIdentifier("homeToPlanATrip", sender: tripIds[indexPath.row])
            }
        }
        
        if indexPath.section == 1 {
            self.performSegueWithIdentifier("mainToExploreOtherPeopleSegue", sender: self)
        }
        
        
        
        
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.sharedClient().lookUpPhotosForPlaceID(placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.description)")
            } else {
                print(photos?.results)
                if let firstPhoto = photos?.results.first {
                    print("YOOOOOOOOOO")
                    print(firstPhoto)
                    self.loadImageForMetadata(firstPhoto)
                    
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.sharedClient()
            .loadPlacePhoto(photoMetadata, constrainedToSize: magellanImageView.bounds.size,
                            scale: self.magellanImageView.window!.screen.scale) { (photo, error) -> Void in
                                if let error = error {
                                    // TODO: handle the error.
                                    print("Error: \(error.description)")
                                } else {
                                    print("whatuuuuuuup")
                                    self.magellanImageView.image = photo;
//                                    self.attributionTextView.attributedText = photoMetadata.attributions;
                                }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadFirstPhotoForPlace("ChIJ72FRK-msB4gRY8DqvqZG6mw")
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
//        navigationItem.titleView?.backgroundColor = UIColor.clearColor()
        var plannedTripsQuery = PFQuery(className: "Trips")
        
        var userTrips = plannedTripsQuery.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)
        
        userTrips.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let trips = objects {
                //                print(trips)
                self.userTripCount = trips.count
                var count = 0
                var tripsArray = []
                var counter = 0
                
                for object in trips {
                    //                    print(object["destinations"] as? NSArray)
                    //tripsArray[count] = object["destinations"][count]
                    self.tripNames.append(object["name"] as! String)
                    self.tripIds.append(object.objectId! as String)
                    //                   print(self.tripIds)
                    var numOfDestinations = []
                    
                    //playground **
                    
                    self.destinations.append(object["destinations"] as! [String])
                  

                    
                    count += 1
                    
                    var destinationQuery = PFQuery(className: "Destinations")
                    var specificDestinationQuery = destinationQuery.whereKey("tripId", equalTo: object.objectId! as String)
                    specificDestinationQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if let destinationQueries = objects {
                            self.destinationCities = []
                            for destinationObject in destinationQueries {
                                self.destinationCities.append(destinationObject["destinationCity"] as! String)
                            }
                            self.destinationStrings.append(self.destinationCities.joinWithSeparator(", "))
                        }
                        
                        counter += 1
                        print(self.destinationCities)
                        self.tableView.reloadData()
                        
                    })
                    
                   self.tableView.reloadData()
                }
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.noDestination.append("Click the airplane to plan a trip!")
            }
            self.tableView.reloadData()
           
            
        })
        
        
        
    }
    
    var destinationCities = [String]()
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.5 //make the header transparent
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        //        print(tripNames)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
        //        override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        //            if (segue.identifier == "homeToTripShow") {
        //                var svc = segue!.destinationViewController as secondViewController;
        //                
        //                svc.toPass = textField.text
        //                
        //            }
        //        }
        
        // Dispose of any resources that can be recreated.
    }
    
    
}

