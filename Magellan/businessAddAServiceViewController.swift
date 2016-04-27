//
//  businessAddAServiceViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/1/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
//import RealmSwift

class businessAddAServiceViewController: UIViewController, UINavigationControllerDelegate {
    var categoriesString = ""
    var serviceLatitude = Double()
    var serviceLongitude = Double()
   
    var businessInfoPassed = String()
    var businessInfoCategoryPassed = String()
    
    @IBOutlet var tableView: UITableView!

    var businessInfo = ["Name", "Address", "Description (Optional)", "Category", "Hours", "Phone", "Website"]
    var categories = ["Category"]
    override func viewDidLoad() {
        super.viewDidLoad()
        var titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Add A Service", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: "titlePressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        self.navigationItem.backBarButtonItem?.title = "Dashboard"
        self.categories = Manager.categoryArray
         categoriesString = categories.joinWithSeparator(", ")
    }
    
    
    
    @IBAction func addButton(sender: AnyObject) {
        let address = businessInfo[1]
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.serviceLongitude = coordinates.longitude
                self.serviceLatitude = coordinates.latitude
                
                var event = PFObject(className: "Events")
                
                event["name"] = self.businessInfo[0]
                event["address"] = self.businessInfo[1]
                event["description"] = self.businessInfo[2]
                event["hours"] = self.businessInfo[4]
                event["phone"] = self.businessInfo[5]
                event["category"] = self.categories
                event["website"] = self.businessInfo[6]
                event["companyId"] = PFUser.currentUser()!.objectId
                let geoPoint = PFGeoPoint(latitude: self.serviceLatitude, longitude: self.serviceLongitude)
                event["geoPoint"] = geoPoint
                
                event.saveInBackgroundWithBlock { (success, error) -> Void in
                    if success == true {
                        print("successful")
                        self.performSegueWithIdentifier("addServiceToBusinessHomeSegue", sender: self)
                    } else {
                        print("failed")
                        print(error)
                        let alertController = UIAlertController(title: "Entry Failed", message: "Failed to save your entry!", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }

                
                
                
                
            }
        })
        
    }
 
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        if segue.sourceViewController .isKindOfClass(businessServiceInfoViewController) {
            var view:businessServiceInfoViewController = segue.sourceViewController as! businessServiceInfoViewController
//            var businessInfoCategory:businessServiceInfoViewController = segue.sourceViewController as! businessServiceInfoViewController
            
            self.businessInfoPassed = view.businessInfo
            self.businessInfoCategoryPassed = view.businessInfoCategory
            if businessInfoPassed != "" {
                switch businessInfoCategoryPassed {
                case "Name":
                   businessInfo[0] = businessInfoPassed
                case "Address":
                    businessInfo[1] = businessInfoPassed
                case "Description (Optional)":
                    businessInfo[2] = businessInfoPassed
                case "Hours":
                     businessInfo[4] = businessInfoPassed
                case "Phone":
                     businessInfo[5] = businessInfoPassed
                case "Website":
                    businessInfo[6] = businessInfoPassed
                default:
                    businessInfo[0] = "HEEEELLOOO"
                }
                 print(businessInfo)
            }
            tableView.reloadData()
           
        }
        
        if segue.sourceViewController .isKindOfClass(addBusinessCategoryViewController) {
            var view:addBusinessCategoryViewController = segue.sourceViewController as! addBusinessCategoryViewController
            if view.businessCategoriesSelected.count > 0 {
                self.categories = view.businessCategoriesSelected
                self.categoriesString = categories.joinWithSeparator(", ")
            }
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businessInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "businessInfoCell")
        
        
        
        
        //        if tripNames.count > 0 {
        if indexPath.row == 3 {
           
            print(categoriesString)
             cell.textLabel?.text = categoriesString
            
        } else {
            cell.textLabel?.text = businessInfo[indexPath.row]
        }
        //        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        Manager.dataToPass = businessInfo[indexPath.row]
            if indexPath.row == 3 {
                self.performSegueWithIdentifier("addBusinessCategorySegue", sender: self)
            } else {
                self.performSegueWithIdentifier("addBusinessInfoSegue", sender: self)
            }
        
        
    }

    
    
//    
//    @IBAction fun titlePressed(sender: UIButton) {
//        print("Vea Software!")
//    }
//    
}
