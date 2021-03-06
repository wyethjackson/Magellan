//
//  tripFeedViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/17/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class tripFeedViewController: UITableViewController, UISearchBarDelegate {
    struct Trip {
        var name: String
        var shareType: String
        var tripName: String
        var destinations: String
        var tripId: String
        var favoritedTrip: Bool
       
    }
    var fullName = String()
     var favoritedTrip = false
    var tripArray = [Trip]()
    var searchActive : Bool = false
    var searchController = UISearchController(searchResultsController:nil)
    var friends = [String]()
    var filteredFriends = [String]()
    var image1 = [UIImage(named: "big_ben.jpg")]
    var otherTripParticipants = [String]()
//        var otherTripParticipants = ["Wyeth Jackson, Michael Thal", "Pier Selenica, Kumar Bhattacharyya"]
//        , UIImage(named: "eiffel-tower.jpg"), UIImage(named: "empire_state_building.jpg")]
    var image2 = [UIImage(named: "bridge_fog.jpg")]
//        , UIImage(named: "skyscraper_alone.jpg"), UIImage(named: "hawaii_pic.jpg")]
    var image3 = [UIImage(named: "restaurant_seating.jpeg")]
//        , UIImage(named: "trip_events_skyscraper.jpeg"), UIImage(named: "statue-of-liberty.jpg")]
    var names = [String]()
    var tripName = [String]()
    var tripInfo = [String]()
    
//    var blogNames = ["Paris Louvre Visit"]
//    var blogDescriptions = ["The Mona Lisa was incredible to see in person!!"]
//    var imageTripNames = ["Trip to France"]
    
//    var kindOfPost = [["Trip", "Trip", "Trip", "", "", ""], ["", "", "", "Blog Post", "Blog Post", ""], ["", "", "", "", "", "Photos"]]
    
    var kindOfPost = [String]()
//    var blogComments = [["I love the louvre!", "Glad you are having fun!"]]
    @IBOutlet var searchBarButtonItem: UIBarButtonItem!
    @IBAction func searchButton(sender: AnyObject) {
//        searchBarButtonItem.enabled = false
//        var leftNavBarButton = UIBarButtonItem(customView: searchController.searchBar)
//        self.navigationItem.leftBarButtonItem = leftNavBarButton
//                searchController.searchBar.sizeToFit()
//        //        searchController.searchResultsUpdater = self
//                searchController.dimsBackgroundDuringPresentation = false
//                definesPresentationContext = true
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    @IBOutlet var tripFeedTableView: UITableView!
    
    var refresher: UIRefreshControl!
    
    func refresh() {
        print("Refreshed")
        
        self.refresher.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userQuery = PFQuery(className: "user_followers")
        var specificUserQuery = userQuery.whereKey("followerId", equalTo: (PFUser.currentUser()?.objectId)!)
        specificUserQuery.limit = 1000
        specificUserQuery.findObjectsInBackgroundWithBlock { (objects, error) in
            if let userFollowers = objects {
                for object in userFollowers {
                    var tripQuery = PFQuery(className: "Trips")
                    var specificTripQuery = tripQuery.whereKey("userId", equalTo: object["userId"])
                    var shareSpecificTripQuery = specificTripQuery.whereKey("shareTrip", equalTo: true)
                    shareSpecificTripQuery.orderByAscending("createdAt")
                    shareSpecificTripQuery.findObjectsInBackgroundWithBlock({ (tripObjects, error) in
                        if let specificTrips = tripObjects {
                            for tripObject in specificTrips {
                                var tripDestinations = tripObject["destinations"].componentsJoinedByString("; ")
                                var tripName = tripObject["name"]
                                var tripId = tripObject.objectId!
                                self.fullName = ""
                                  self.favoritedTrip = false
                                var users : PFQuery = PFUser.query()!
                                users.whereKey("objectId", equalTo: tripObject["userId"])
                                users.findObjectsInBackgroundWithBlock({ (userObjects, error) in
                                    if let specificUsers = userObjects {
                                        
                                        for userObject in specificUsers {
                                            print(userObject["fullName"])
                                           self.fullName = userObject["fullName"] as! String
                                            
                                        }
                                      
                                        var userTripsQuery = PFQuery(className: "user_trips")
                                        userTripsQuery.whereKey("tripId", equalTo: tripId)
                                        userTripsQuery.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)
                                        userTripsQuery.findObjectsInBackgroundWithBlock({ (userTripsObjects, error) in
                                            if let userTripsObjects = userTripsObjects {
                                               
                                                for userTripsObject in userTripsObjects {
                                                    if userTripsObject["userId"] != nil {
                                                        self.favoritedTrip = true
                                                    } else {
                                                        self.favoritedTrip = false
                                                    }
                                                }
                                                var trip = Trip(name: self.fullName, shareType: "Trip", tripName: tripName as! String, destinations: tripDestinations, tripId: tripId, favoritedTrip: self.favoritedTrip)
                                               
                                                self.tripArray.append(trip)
                                               
                                                 self.tableView.reloadData()
                                            }
                                        })
                                    }
                                   
                                })
                            }
                        }
                        self.tableView.reloadData()
                    })
                }
            }
        }
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        refresh()
        
        
        
//       navigationItem.titleView = searchController.searchBar
       
//        searchController.searchBar.sizeToFit()
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
    
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        searchActive = false;
        searchBarButtonItem.enabled = false

    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tripArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
      return 5
        
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        searchBarButtonItem.enabled = false
       
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        searchBarButtonItem.enabled = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBarButtonItem.enabled = true
  
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

//    }
//    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blueColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
//        header.alpha = 0.5 //make the header transparent
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tripArray[section].name
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tripArray[indexPath.section].shareType != "Trip" && indexPath.row == 0 {
            return 0
           
        } else if tripArray[indexPath.section].shareType != "Trip" && indexPath.row == 1 {
           
                return 0
            
        } else if tripArray[indexPath.section].shareType != "Blog Post" && indexPath.row == 2 {
         
            return 0
            
            
        } else if tripArray[indexPath.section].shareType != "Blog Post" && indexPath.row == 3 {
            return 0
            
            
        } else if tripArray[indexPath.section].shareType != "Photos" && indexPath.row == 4 {
            
          return 0
        }
        
                if indexPath.row == 0 {
                    
                    return 75
                } else if indexPath.row == 1 {
                    return 47
                } else if indexPath.row == 2 {
                    return 150
                } else if indexPath.row == 3 {
                    return 100
                } else if indexPath.row == 4 {
                    return 150
        }
                    return 100
        
        

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: tripFeedCell!
      
        if indexPath.row == 0 {
              cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! tripFeedCell
//                     cell.userName.text = names[indexPath.section]
                    cell.tripInfo.text = "Destinations: \(tripArray[indexPath.section].destinations)"
            cell.tripInfo.numberOfLines = 3
  
        
                    cell.tripName.text = tripArray[indexPath.section].tripName
        }
        
        if indexPath.row == 1 {
             cell = tableView.dequeueReusableCellWithIdentifier("commentButtonsCell", forIndexPath: indexPath) as! tripFeedCell
            if tripArray[indexPath.section].favoritedTrip == true {
                cell.favoriteButtonOutlet.titleLabel?.text = "Following"
                cell.favoriteButtonOutlet.titleLabel?.textColor = UIColor.whiteColor()
                cell.favoriteButtonOutlet.backgroundColor = UIColor.blueColor()
            } else {
                cell.favoriteButtonOutlet.backgroundColor = UIColor.whiteColor()
                cell.favoriteButtonOutlet.titleLabel?.textColor = UIColor.blackColor()
                cell.favoriteButtonOutlet.titleLabel!.text = "Follow"
            }
            cell.favoriteButtonOutlet.tag = indexPath.section
            cell.favoriteButtonOutlet.addTarget(self, action: "followAction:", forControlEvents: .TouchUpInside)
        }
        
        
        
        if indexPath.row == 2 {
             cell = tableView.dequeueReusableCellWithIdentifier("blogPostCell", forIndexPath: indexPath) as! tripFeedCell
            
            cell.hidden = true
        } else if indexPath.row == 3 {
              cell = tableView.dequeueReusableCellWithIdentifier("blogCommentsCell", forIndexPath: indexPath) as! tripFeedCell
            cell.hidden = true
        } else if indexPath.row == 4 {
              cell = tableView.dequeueReusableCellWithIdentifier("photosCell", forIndexPath: indexPath) as! tripFeedCell
            cell.hidden = true
        }
//        var cell: tripFeedCell!
//        if indexPath.row == 0 && kindOfPost[indexPath.section] == "Trip" {
//             cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! tripFeedCell
//             cell.userName.text = names[indexPath.row]
//            cell.tripInfo.text = "Destinations: \(tripInfo[indexPath.row])"
//           
//            cell.tripName.text = tripName[indexPath.row]
//        } else if indexPath.row == 1 && kindOfPost[indexPath.section] == "Trip" {
//              cell = tableView.dequeueReusableCellWithIdentifier("commentButtonsCell", forIndexPath: indexPath) as! tripFeedCell
//          
//          
//        } else if indexPath.row == 2 && kindOfPost[indexPath.section] == "Trip" {
//             cell = tableView.dequeueReusableCellWithIdentifier("commentsCell", forIndexPath: indexPath) as! tripFeedCell
//          
//        } else if indexPath.row == 3 && kindOfPost[indexPath.section] == "Blog Post" {
//            cell = tableView.dequeueReusableCellWithIdentifier("blogPostCell", forIndexPath: indexPath) as! tripFeedCell
////                    cell.blogNameLabel.text = blogNames[0]
////                    cell.blogDescriptionLabel.text = blogDescriptions[0]
//
//            
//            
//            
//            
//        } else if indexPath.row == 4 && kindOfPost[indexPath.section] == "Blog Post" {
//             cell = tableView.dequeueReusableCellWithIdentifier("blogCommentsCell", forIndexPath: indexPath) as! tripFeedCell
//         
////                if blogComments.count > 0 {
////        
////                    cell.blogComment1.text = blogComments[0][0]
////                    
////                    cell.blogComment2.text = blogComments[0][1]
//// 
////                }
////                
//    
//           
//            
//        } else if indexPath.row == 5 && kindOfPost[indexPath.section] == "Photos" {
//            cell = tableView.dequeueReusableCellWithIdentifier("photosCell", forIndexPath: indexPath) as! tripFeedCell
//    
////                    cell.imageTripNameLabel.text = imageTripNames[0]
////                    cell.postedImage1.image = image1[0]
////                    cell.postedImage2.image = image2[0]
////                    cell.postedImage3.image = image3[0]
//
//        }


        return cell
        
    }
    
    @IBAction func followAction(sender: UIButton) {
        if tripArray[sender.tag].favoritedTrip == true {
            var userTripsQuery = PFQuery(className: "user_trips")
            userTripsQuery.whereKey("userId", equalTo: (PFUser.currentUser()?.objectId!)!)
            userTripsQuery.whereKey("tripId", equalTo: tripArray[sender.tag].tripId)
            userTripsQuery.findObjectsInBackgroundWithBlock({ (objects, error) in
                if let objects = objects {
                    for object in objects {
                        object.deleteInBackground()
                    }
                }
            })
        } else {
            var user_trips = PFObject(className:"user_trips")
            user_trips["userId"] = PFUser.currentUser()?.objectId!
            user_trips["tripId"] = tripArray[sender.tag].tripId
            
            user_trips.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
                if (success) {
                    self.tripArray[sender.tag].favoritedTrip = true
                    self.tableView.reloadData()
                } else {
                    
                }
            }
        }
      
    
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
    }
    
//    override func viewDidAppear(animated: Bool) {
//        tripFeedTableView.reloadData()
//    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
//        filteredFriends = friends.filter { friend in
//            return candy.name.lowercaseString.containsString(searchText.lowercaseString)
            
            filteredFriends = friends.filter({ (text) -> Bool in
                let tmp: NSString = text
                let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
            if(filteredFriends.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }

        }
        
    
    
    }

//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        filteredFriends = friends.filter({ (text) -> Bool in
//            let tmp: NSString = text
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        })
//        if(filteredFriends.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.tripFeedTableView.reloadData()
//    }
    


//
//extension tripFeedViewController: UISearchResultsUpdating {
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
//    }
//}