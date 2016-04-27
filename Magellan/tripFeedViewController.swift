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
    var searchActive : Bool = false
    var searchController = UISearchController(searchResultsController:nil)
    var friends = [String]()
    var filteredFriends = [String]()
    var image1 = [UIImage(named: "big_ben.jpg")]
        var otherTripParticipants = ["Wyeth Jackson, Michael Thal", "Pier Selenica, Kumar Bhattacharyya"]
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
                                self.kindOfPost.append("Trip")
                                self.tripName.append(tripObject["name"] as! String)
                                let destinations = tripObject["destinations"].componentsJoinedByString("; ")
                                self.tripInfo.append(destinations)
                                print("trip name")
                                print(self.tripName)
                                var users : PFQuery = PFUser.query()!
                                users.whereKey("objectId", equalTo: tripObject["userId"])
                                users.findObjectsInBackgroundWithBlock({ (userObjects, error) in
                                    if let specificUsers = userObjects {
                                        for userObject in specificUsers {
                                            self.names.append(userObject["fullName"] as! String)
                                            print(self.names)
                                        }
                                    }
                                    self.tableView.reloadData()
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
        return names.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
      return 6
        
        
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
        header.contentView.backgroundColor = UIColor.blackColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.5 //make the header transparent
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.names[section]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if kindOfPost[indexPath.section] != "Trip" && indexPath.row == 0 {
            print("row")
            print(indexPath.row)
            print(indexPath.section)
            print("not trip")
            return 0
           
        } else if kindOfPost[indexPath.section] != "Trip" && indexPath.row == 1 {
           
                return 0
        } else if kindOfPost[indexPath.section] != "Trip" && indexPath.row == 2 {
           return 0
            
        } else if kindOfPost[indexPath.section] != "Blog Post" && indexPath.row == 3 {
            print("not blog post")
            return 0
            
            
        } else if kindOfPost[indexPath.section] != "Blog Post" && indexPath.row == 4 {
            return 0
            
            
        } else if kindOfPost[indexPath.section] != "Photos" && indexPath.row == 5 {
            print("not photos")
          return 0
        }
        
                if indexPath.row == 0 {
                    return 95
                } else if indexPath.row == 1 {
                    return 47
                } else if indexPath.row == 2 {
                    return 47
                } else if indexPath.row == 3 {
                    return 150
                } else if indexPath.row == 4 {
                    return 100
                } else if indexPath.row == 5 {
                    return 150
        }
                    return 100
        
        

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: tripFeedCell!
      
        if indexPath.row == 0 {
              cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! tripFeedCell
//                     cell.userName.text = names[indexPath.section]
                    cell.tripInfo.text = "Destinations: \(tripInfo[indexPath.section])"
            cell.tripInfo.numberOfLines = 3
            cell.participantsLabel.numberOfLines = 2
            cell.participantsLabel.text = "Other Participants:\n" + otherTripParticipants[indexPath.section]
        
                    cell.tripName.text = tripName[indexPath.section]
        }
        
        if indexPath.row == 1 {
             cell = tableView.dequeueReusableCellWithIdentifier("commentButtonsCell", forIndexPath: indexPath) as! tripFeedCell
        } else if indexPath.row == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("commentsCell", forIndexPath: indexPath) as! tripFeedCell
        }
        
        
        
        if indexPath.row == 3 {
             cell = tableView.dequeueReusableCellWithIdentifier("blogPostCell", forIndexPath: indexPath) as! tripFeedCell
            
            cell.hidden = true
        } else if indexPath.row == 4 {
              cell = tableView.dequeueReusableCellWithIdentifier("blogCommentsCell", forIndexPath: indexPath) as! tripFeedCell
            cell.hidden = true
        } else if indexPath.row == 5 {
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            self.performSegueWithIdentifier("tripFeedToAdviceSegue", sender: self)
        } else if indexPath.row == 2 {
            self.performSegueWithIdentifier("tripFeedToShowEventsSegue", sender: self)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tripFeedTableView.reloadData()
    }
    
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