//
//  addPlaceYouveBeenTableViewController.swift
//  
//
//  Created by Wyeth Jackson on 4/11/16.
//
//

import GoogleMaps
import UIKit
import Parse
import MapKit
import CoreLocation

class addPlaceYouveBeenTableViewController: UITableViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
     var annotation:MKAnnotation!
    var error:NSError!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var pointAnnotation:MKPointAnnotation!
    var locations = [String]()
    var totalLocations = [String]()
    
    
    @IBAction func addDestinations(sender: AnyObject) {
       self.performSegueWithIdentifier("addPlaceToMyActivitySegue", sender: self)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController?.searchBar
       
        searchController?.searchBar.placeholder = "Search Destination"
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        var users : PFQuery = PFUser.query()!
        users.whereKey("objectId", equalTo: (PFUser.currentUser()?.objectId!)!)
        users.findObjectsInBackgroundWithBlock { (objects, error) in
            if let userQuery = objects {
                for object in userQuery {
                    if object["destinationsVisited"] != nil {
                        self.totalLocations = object["destinationsVisited"] as! [String]
                    }
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
       
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if totalLocations.count > 0 {
            return totalLocations.count
        } else {
            return 1
        }
        
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.5 //make the header transparent
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Destinations Visited"
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//       
//        
//        
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! addPlaceTableViewCell
        if totalLocations.count > 0 {
        
        cell.locationLabel.text = totalLocations[indexPath.row]
        } else {
            cell.locationLabel.text = "No locations have been added"
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
    }


    
}


extension addPlaceYouveBeenTableViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(resultsController: GMSAutocompleteResultsViewController!,
                           didAutocompleteWithPlace place: GMSPlace!) {
        searchController?.active = false
        // Do something with the selected place.
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = place.formattedAddress
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
        
        self.pointAnnotation = MKPointAnnotation()
        
        self.pointAnnotation.title = place.formattedAddress
        self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
        let destinationSearchLatitude = self.pointAnnotation.coordinate.latitude
        let destinationSearchLongitude = self.pointAnnotation.coordinate.longitude
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: destinationSearchLatitude, longitude:destinationSearchLongitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            
            placeMark = placemarks?[0]
            
            var specificLocation = [String]()
            var noStateLocations = [String]()
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
                specificLocation.append(city as String)
                noStateLocations.append(city as String)
            }
            
            if let state = placeMark.addressDictionary!["State"] as? NSString {
                specificLocation.append(state as String)
            }
            
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
                specificLocation.append(country as String)
                noStateLocations.append(country as String)
            }
            
            if specificLocation[2] == "United States" {
            
            self.locations.append(specificLocation.joinWithSeparator(", "))
                self.totalLocations.append(specificLocation.joinWithSeparator(", "))
            } else {
                self.locations.append(noStateLocations.joinWithSeparator(", "))
                self.totalLocations.append(noStateLocations.joinWithSeparator(", "))
            }
            
            self.tableView.reloadData()
            var users : PFQuery = PFUser.query()!
            users.getObjectInBackgroundWithId((PFUser.currentUser()?.objectId)!) { (user: PFObject?, error: NSError?) in
                if error != nil {
                    print(error)
                } else if let user = user {
                    user["destinationsVisited"] = self.totalLocations
                    user.saveInBackground()
                }
            }
//            self.destination = "\(self.destinationCity), \(self.destinationCountry)"
//            self.destinationLabel.hidden = false
//            self.destinationLabelVisualBlur.hidden = false
//            self.destinationLabel.text = self.destination
            //                self.eventNavigationItem.title = "Top Events in \(self.destinationCity), \(self.destinationCountry)"
        })
        
    }

        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
    }
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController!,
                           didFailAutocompleteWithError error: NSError!){
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}