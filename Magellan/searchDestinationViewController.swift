//
//  searchDestinationViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 1/22/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
//import GoogleMaps

class searchDestinationViewController: UIViewController, UISearchBarDelegate {
    var searchResultController:SearchResultsController!
    var resultsArray = [String]()
//    var googleMapsView:GMSMapView!
    
    @IBOutlet var mapViewContainer: UIView!
    
    @IBAction func showSearchController(sender: AnyObject) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        self.googleMapsView =  GMSMapView(frame: self.mapViewContainer.frame)
//        self.view.addSubview(self.googleMapsView)
        searchResultController = SearchResultsController()
//        searchResultController.delegate = self
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
//        
//        dispatch_async(dispatch_get_main_queue()) { () -> Void in
//            let position = CLLocationCoordinate2DMake(lat, lon)
//            let marker = GMSMarker(position: position)
//            
//            let camera  = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 10)
//            self.googleMapsView.camera = camera
//            
//            marker.title = title
//            marker.map = self.googleMapsView
//        }
//    }
    
//    func searchBar(searchBar: UISearchBar,
//        textDidChange searchText: String){
//            
//            let placesClient = GMSPlacesClient()
//            placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error:NSError?) -> Void in
//                self.resultsArray.removeAll()
//                if results == nil {
//                    return
//                }
//                for result in results!{
//                    if let result = result as? GMSAutocompletePrediction{
//                        self.resultsArray.append(result.attributedFullText.string)
//                    }
//                }
//                self.searchResultController.reloadDataWithArray(self.resultsArray)
//            }
//    }
    
    
    
    
}
