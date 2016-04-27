//
//  businessAddEventTitleDescriptionViewController.swift
//  
//
//  Created by Wyeth Jackson on 1/28/16.
//
//

import UIKit
import Parse
import MapKit
import CoreLocation
//import RealmSwift

class businessAddEventTitleDescriptionViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    var eventDate = NSDate()
    var eventDateCreated = false
    var eventName = String()
    var eventDescription = String()
    var eventAddress = String()
    var addEventInfo = ["Name", "Description", "Address", "Date & Time"]
    @IBOutlet var tableView: UITableView!
    var searchBarText = String()
    var eventLongitude = Double()
    var eventLatitude = Double()
//    var annotation:MKAnnotation!
//    var localSearchRequest:MKLocalSearchRequest!
//    var localSearch:MKLocalSearch!
//    var localSearchResponse:MKLocalSearchResponse!
   
    var eventInfo = String()
    var eventInfoCategory = String()

//    @IBOutlet var tableView: UITableView!
   
    
    @IBAction func addEventButton(sender: AnyObject) {
//        event["address"] = searchBarText
//        event["description"] = eventDescriptionTextField.text
//        event["name"] = eventTitleTextField.text
          var event = PFObject(className: "Events")
        let address = addEventInfo[2]
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                print("yOOOOOOOO")
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("coordinates")
                print(coordinates)
                self.eventLongitude = coordinates.longitude
                self.eventLatitude = coordinates.latitude
                print(self.eventLongitude)
                print(self.eventLatitude)
                event["name"] = self.addEventInfo[0]
                event["description"] = self.addEventInfo[1]
                event["address"] = self.addEventInfo[2]
                event["companyId"] = PFUser.currentUser()!.objectId!
                event["date"] = self.eventDate
                let geoPoint = PFGeoPoint(latitude: self.eventLatitude, longitude: self.eventLongitude)
                event["geoPoint"] = geoPoint
                
                event.saveInBackgroundWithBlock { (success, error) -> Void in
                    if success == true {
                        print("successful")
                        self.performSegueWithIdentifier("businessAddEventToBusinessHomeSegue", sender: self)
                    } else {
                        print("Failed")
                        print(error)
                        let alertController = UIAlertController(title: "Entry Failed", message: "Failed to save your entry!", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        })
        

       
        
        
      
        
       
        
    }
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        if segue.sourceViewController .isKindOfClass(businessAddEventFrequencyViewController) {
            var view1:businessAddEventFrequencyViewController = segue.sourceViewController as! businessAddEventFrequencyViewController
            eventInfoCategory = view1.addEventInfo
            eventInfo = view1.eventText
            if eventInfo != "" {
                switch eventInfoCategory {
                    case "Name":
                        addEventInfo[0] = eventInfo
                    case "Description":
                        addEventInfo[1] = eventInfo
                    case "Address":
                        addEventInfo[2] = eventInfo
                    default:
                        eventName = ""
                }
            }
            
        }
        if segue.sourceViewController .isKindOfClass(businessAddEventDateTimeViewController) {
            
            var view2:businessAddEventDateTimeViewController = segue.sourceViewController as! businessAddEventDateTimeViewController
            if view2.eventDateCreated == true {
                eventDate = view2.eventDate
                eventDateCreated = true
            }
            
            
            
            
        }
        tableView.reloadData()
    }
    
    
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return addEventInfo.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            if indexPath.row == 3 {
                if eventDateCreated == true {
                    
                    let formatter = NSDateFormatter()
                    formatter.dateStyle = NSDateFormatterStyle.LongStyle
                    formatter.timeStyle = .ShortStyle
                    cell.textLabel?.text = formatter.stringFromDate(eventDate as! NSDate)
                   
                } else {
                 cell.textLabel!.text = addEventInfo[indexPath.row]
                }
            } else {
                cell.textLabel!.text = addEventInfo[indexPath.row]
            }
            
            let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurView = UIVisualEffectView(effect: blur)
            
            //        cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            //         cell.accessoryType = UITableViewCellAccessoryType.DetailButton
            
            cell.backgroundColor = UIColor.clearColor()
            cell.backgroundView = blurView
           
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let path = self.tableView.indexPathForSelectedRow!
        //        segue.tripShowViewController.detail = self.detailForIndexPath(path)
        //        print(tripIds[indexPath.row])
       
        
            Manager.dataToPass = addEventInfo[indexPath.row]
        if addEventInfo[indexPath.row] == "Date & Time" {
            self.performSegueWithIdentifier("addEventToDateTime", sender: self)
        } else {
             self.performSegueWithIdentifier("addEventToEventInfo", sender: self)
        }
        
        
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
      
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
