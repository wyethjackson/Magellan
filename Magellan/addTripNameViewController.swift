//
//  addTripNameViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/11/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation
import GoogleMaps

class addTripNameViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate {
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController!
    var resultView: UITextView?

    var tripName = ""
    var destinationCity = String()
    var destinationCountry = String()
    var destinationState = String()
    var whichInfo = String()
    @IBOutlet var destinationLabelVisualBlur: UIVisualEffectView!
    
    @IBOutlet var destinationLabel: UILabel!
    var destination = String()
    
    @IBOutlet var tripNameTextField: UITextField!
    var destinationLatitudes = [Double]()
    var destinationLongitudes = [Double]()
    var destinationSearchLatitude = Double()
    var destinationSearchLongitude = Double()
    var searchBarText = String()
//    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
//    @IBAction func showSearchBar(sender: AnyObject) {
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.hidesNavigationBarDuringPresentation = false
//        self.searchController.searchBar.delegate = self
//        presentViewController(searchController, animated: true, completion: nil)
//    }
//    
    
    @IBOutlet var mapView: MKMapView!
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
//        self.destinationNameLabel.text = searchController.searchBar.text
        //1
        self.searchBarText = searchController!.searchBar.text!
//        destinationLabel.text = searchController.searchBar.text!
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            self.destinationSearchLatitude = self.pointAnnotation.coordinate.latitude
            self.destinationSearchLongitude = self.pointAnnotation.coordinate.longitude
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: self.destinationSearchLatitude, longitude: self.destinationSearchLongitude)
            
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
                self.destination = "\(self.destinationCity), \(self.destinationCountry)"
                self.destinationLabel.hidden = false
                self.destinationLabelVisualBlur.hidden = false
                self.destinationLabel.text = self.destination
//                self.eventNavigationItem.title = "Top Events in \(self.destinationCity), \(self.destinationCountry)"
            })
            
            

            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    
    
    @IBAction func addDestinationButton(sender: AnyObject) {
        self.performSegueWithIdentifier("tripNameToPlanTrip", sender: self)
    }
    
    
    @IBOutlet var addTripButtonVisualBlur: UIVisualEffectView!
    @IBOutlet var addTripNameButtonOutlet: UIButton!
    
    @IBOutlet var searchBarButtonOutlet: UIBarButtonItem!
    
    @IBOutlet var addDestinationButtonOutlet: UIButton!

    @IBOutlet var addDestinationVisualBlur: UIVisualEffectView!
    
    @IBAction func addTripNameButton(sender: AnyObject) {
        tripName = tripNameTextField.text!
        
        self.performSegueWithIdentifier("tripNameToPlanTrip", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.whichInfo = Manager.dataToPass
        print(self.whichInfo)
        if self.whichInfo == "name" {
            navigationItem.title = "Add a trip name"
            self.addTripButtonVisualBlur.hidden = false
            self.addTripNameButtonOutlet.hidden = false
            self.tripNameTextField.hidden = false
            self.mapView.hidden = true
            self.destinationLabel.hidden = true
            self.destinationLabelVisualBlur.hidden = true
            self.addDestinationVisualBlur.hidden = true
            self.addDestinationButtonOutlet.hidden = true
          //  self.searchBarButtonOutlet.enabled = false
        } else if self.whichInfo == "destination" {
            resultsViewController = GMSAutocompleteResultsViewController()
            resultsViewController?.delegate = self
//             self.searchController.loadViewIfNeeded()
            searchController = UISearchController(searchResultsController: resultsViewController)
            searchController?.searchResultsUpdater = resultsViewController
            
            // Put the search bar in the navigation bar.
            searchController?.searchBar.sizeToFit()
//            searchController.searchResultsUpdater = self
            self.navigationItem.titleView = searchController?.searchBar
            
            // When UISearchController presents the results view, present it in
            // this view controller, not one further up the chain.
            self.definesPresentationContext = true
            
            // Prevent the navigation bar from being hidden when searching.
            searchController?.hidesNavigationBarDuringPresentation = false
            navigationItem.title = "Search a Destination"
            self.mapView.hidden = false
            self.destinationLabelVisualBlur.hidden = true
            self.addTripButtonVisualBlur.hidden = true
            self.addTripNameButtonOutlet.hidden = true
            self.addDestinationButtonOutlet.hidden = false
            self.addDestinationVisualBlur.hidden = false
         
            self.destinationLabel.hidden = false
            self.mapView.hidden = false
            self.destinationLabel.hidden = false
            
            self.addDestinationVisualBlur.hidden = false
            self.destinationLabel.hidden = true
          //  self.searchBarButtonOutlet.enabled = true
            self.tripNameTextField.hidden = true
      
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension addTripNameViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(resultsController: GMSAutocompleteResultsViewController!,
                           didAutocompleteWithPlace place: GMSPlace!) {
        searchController?.active = false
        // Do something with the selected place.
        
        self.searchBarText = searchController!.searchBar.text!
        //        destinationLabel.text = searchController.searchBar.text!
//        searchBar.resignFirstResponder()
        
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = place.formattedAddress
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = place.formattedAddress
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            self.destinationSearchLatitude = self.pointAnnotation.coordinate.latitude
            self.destinationSearchLongitude = self.pointAnnotation.coordinate.longitude
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: self.destinationSearchLatitude, longitude: self.destinationSearchLongitude)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                
                placeMark = placemarks?[0]
                
                
                // City
                if let city = placeMark.addressDictionary!["City"] as? NSString {
                    print(city)
                    self.destinationCity = city as String
                }
                
                if let state = placeMark.addressDictionary!["State"] as? NSString {
                    self.destinationState = state as String
                }
                
                
                // Country
                if let country = placeMark.addressDictionary!["Country"] as? NSString {
                    print(country)
                    self.destinationCountry = country as String
                }
                if self.destinationCountry == "United States" {
                    self.destination = "\(self.destinationCity), \(self.destinationState), \(self.destinationCountry)"
                } else {
                     self.destination = "\(self.destinationCity), \(self.destinationCountry)"
                }
                self.destinationLabel.hidden = false
                self.destinationLabelVisualBlur.hidden = false
                self.destinationLabel.text = self.destination
                //                self.eventNavigationItem.title = "Top Events in \(self.destinationCity), \(self.destinationCountry)"
                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            })
            
            
            
            
        
        }

        
        
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController!,
                           didFailAutocompleteWithError error: NSError!){
        
        // TODO: handle the error.
//        dismissViewControllerAnimated(true, completion: nil)
        print("Error: ", error.description)
    }
//    func wasCancelled(viewController: GMSAutocompleteViewController) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}


