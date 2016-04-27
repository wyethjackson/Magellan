//
//  addHotelViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 4/8/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

class addHotelViewController: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var destinationId = String()
    var destinationName = String()
    @IBOutlet var hotelNameTextField: UITextField!
    
    @IBOutlet var hotelAddressLabel: UILabel!
    
    @IBOutlet var destinationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.destinationLabel.text = ""
        self.hotelAddressLabel.text = ""
        self.destinationId = Manager.destinationId
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController?.searchBar
        searchController?.searchBar.placeholder = "Search Address"
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        var destinationQuery = PFQuery(className: "Destinations")
        var specificDestinationQuery = destinationQuery.whereKey("objectId", equalTo: self.destinationId)
        specificDestinationQuery.findObjectsInBackgroundWithBlock { (objects, error) in
            if let specificDestinations = objects {
                for object in specificDestinations {
                    self.destinationName = object["destinationName"] as! String
                    self.destinationLabel.text = self.destinationName
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
extension addHotelViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(resultsController: GMSAutocompleteResultsViewController!,
                           didAutocompleteWithPlace place: GMSPlace!) {
        searchController?.active = false
        // Do something with the selected place.
        let address = place.formattedAddress?.componentsSeparatedByString(",")
        self.hotelAddressLabel.text = address![0]
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