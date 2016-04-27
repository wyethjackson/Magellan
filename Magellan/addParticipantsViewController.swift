//
//  addParticipantsViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 3/25/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class addParticipantsViewController: UIViewController, UITableViewDelegate {
    
    var headers = ["Trip Participants", "Hotel or Airbnb"]
    var destinations = [String]()
    var destinationHotels = [String]()
    var tripId = String()
    var hotelAddress = [String]()
    var hotelAddressBool = [Bool]()
    var participants = ["Wyeth Jackson (You)", "John Kliewer"]
    var profileImages = [UIImage(named: "blank_man.jpg"), UIImage(named: "blank_man.jpg")]
    var destinationIds = [String]()
    
    @IBOutlet var tableView: UITableView!
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return headers[section]
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return headers.count
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
             return participants.count
        } else if section == 1 {
            return destinations.count
        }
       return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "homeCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! addParticipantsTableViewCell
        
        //        print(userTripCount)
        //        print(tripNames)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
        //        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
        
        
        
//        cell.profileImage.image = profileImages[indexPath.row]
        if indexPath.section == 0 {
            cell.participantName.hidden = true
            cell.destinationLabel.hidden = true
            cell.addressLabel.text = participants[indexPath.row]
        } else if indexPath.section == 1 {
            if hotelAddressBool[indexPath.row] == true {
                cell.participantName.hidden = false
                cell.destinationLabel.hidden = false
                cell.addressLabel.text = hotelAddress[indexPath.row]
                cell.participantName.text = destinationHotels[indexPath.row]
                cell.destinationLabel.text = destinations[indexPath.row]
            } else {
               cell.destinationLabel.text = "We'll recommend events near you!"
                cell.participantName.hidden = false
                cell.participantName.text = destinationHotels[indexPath.row]
                cell.addressLabel.text = destinations[indexPath.row]
            }
            
            
            
            
        }
        
        
            let disclosureImage = UIImage(named: "disclosure_indicator.png")
            let disclosureView = UIImageView(image: disclosureImage)
            
            cell.accessoryView = disclosureView
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            //            upcomingTripsBlurView.hidden = false
        
       
            
            //            upcomingTripsLabel.hidden = false
     
        
        
        
        
        
        
        return cell
        
    }
    
    //    objectId = NSUserDefaults.standardUserDefaults().objectForKey("objectId") as [String]
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
        self.performSegueWithIdentifier("addNameInfoSegue", sender: self)
        } else if indexPath.section == 1 {
            Manager.destinationId = destinationIds[indexPath.row]
            self.performSegueWithIdentifier("addHotelInfoSegue", sender: self)
        }
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Manager.dataToPass)
        var tripQuery = PFQuery(className: "Trips")
        var specificTripQuery = tripQuery.whereKey("objectId", equalTo: Manager.dataToPass)
        specificTripQuery.findObjectsInBackgroundWithBlock { (objects, error) in
            if let trips = objects {
                for object in trips {
//                    self.destinations = object["destinations"] as! [String]
                    self.tripId = object.objectId!
                    
                    var destinationQuery = PFQuery(className: "Destinations")
                    
                    var specificDestinationQuery = destinationQuery.whereKey("tripId", equalTo: self.tripId)
                    specificDestinationQuery.findObjectsInBackgroundWithBlock({ (objects, error) in
                        if let specificDestinations = objects {
                            for object in specificDestinations {
                                self.destinations.append(object["destinationName"] as! String)
                                self.destinationIds.append(object.objectId!)
                                if object["hotelAddress"] == nil {
                                    self.destinationHotels.append("Add address of place you are staying")
                                    self.hotelAddressBool.append(false)
                                } else {
                                    self.destinationHotels.append(object["hotelName"] as! (String))
                                    self.hotelAddress.append(object["hotelAddress"] as! String)
                                    self.hotelAddressBool.append(true)
                                }
                            }
                            self.tableView.reloadData()
                        }
                    })
                    
                    
                    
                }
                
                
                
             
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.5 //make the header transparent
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
