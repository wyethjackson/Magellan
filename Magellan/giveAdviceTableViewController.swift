//
//  giveAdviceTableViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 3/31/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class giveAdviceTableViewController: UITableViewController {
    
    struct Trip {
        var userName: String
        var tripDestination: String
    }
   
    struct numberOfRows {
        var nameOfRow: String
        var numOfRows: Int
    }
     var numRowArray = [numberOfRows]()
    var tripArray = [Trip]()
    var locationsVisited = [String]()
    var headers = [String]()
    var names = [[String]]()
    var events = [[String]]()
    var friends = ["John Kliewer", "Keenan Smith"]
    
    var friendDestinations = ["London", "Barcelona"]
    var friendTripEvents = [["None"], ["Running of the bull", "FC Barcelona basketball game"]]
    var randomPeople = ["Jack H.", "Larry M.", "Marissa K."]
    var randomPeopleLocations = ["Iceland", "Rome", "Paris"]
    
    var randomPeopleEvents = [["None"], ["None"], ["Louvre", "Eiffel Tower"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var users = PFUser.query()
        users?.whereKey("objectId", equalTo: (PFUser.currentUser()?.objectId)!)
        users?.findObjectsInBackgroundWithBlock({ (objects, error) in
            if let user = objects {
                for object in user {
                    if object["destinationsVisited"] != nil {
                        self.locationsVisited = object["destinationsVisited"] as! [String]
//                        print(self.locationsVisited)
                    }
                }
                var user_followers = PFQuery(className: "user_followers")
                user_followers.whereKey("followerId", equalTo: (PFUser.currentUser()?.objectId)!)
                user_followers.findObjectsInBackgroundWithBlock({ (objects, error) in
                    if let specificUsers = objects {
                        for object in specificUsers {
                            
                            for destination in self.locationsVisited {
//                                print(destination)
                                var destinationQuery = PFQuery(className: "Destinations")
                                destinationQuery.whereKey("userId", equalTo: object["userId"])
                                destinationQuery.whereKey("destinationName", equalTo: destination)
                                destinationQuery.orderByAscending("createdAt")
                                destinationQuery.limit = 100
                                destinationQuery.findObjectsInBackgroundWithBlock({ (destinationObjects, error) in
                                    if let destinationSpecificObjects = destinationObjects {
                                        for destinationObject in destinationSpecificObjects {
                                            
                                             self.headers.append(destinationObject["destinationName"] as! String)
                                            print("headers")
                                            print(self.headers)
                                                    
                                                    var users = PFUser.query()
                                                    users?.whereKey("objectId", equalTo: destinationObject["userId"])
                                                    users?.findObjectsInBackgroundWithBlock({ (userObjects, error) in
                                                        if let userObjects = userObjects {
                                                            for userObject in userObjects {
                                                                
                                                                for header in self.headers {
                                                                    if destination == header {
                                                                        print(userObject["fullName"])
                                                                      
                                                                        self.tripArray.append(Trip(userName: userObject["fullName"] as! String, tripDestination: destination))
                                                                        
                                                                        
                                                                    }
                                                                 
                                                                }
                                                                
                                                            }
                                                            self.tableView.reloadData()
                                                        }
                                                    })
                                                    
                                            
                                            
                                            
                                           
                                           
                                        }
                                    }
                                })
                            }
                        }
                    }
                })
                
            }
        })
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if locationsVisited.count == 0 {
            return 1
        } else {
        return headers.count
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
            if locationsVisited.count == 0 {
                return 1
            } else if tripArray.count == 0 {
                return 1
            } else {
                var count = 0
                for trip in tripArray {
                    if trip.tripDestination == headers[section] {
                        count += 1
                    }
                }
                return count
            }
        
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.5 //make the header transparent
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if locationsVisited.count == 0 {
            return "No Advice To Give"
        } else {
            return headers[section]
        }
    }
//    
//        override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//            if locationsVisited.count == 0 {
//                return 70
//            }
//            
//            if indexPath.section == 0 {
//                if friends.count == 0 {
//                    return 70
//                } else {
//                    return 200
//                }
//            }
//    
//            return 100
//        }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: giveAdviceTableViewCell
        
        cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! giveAdviceTableViewCell
        if locationsVisited.count == 0 {
            cell.textLabel?.hidden = false
            cell.textLabel!.text = "Go to the 'My Activity' tab to add destinations you have visited"
            cell.textLabel?.numberOfLines = 2
            cell.destinationLabel.hidden = true
        
          
        } else {
        
        
            if tripArray.count == 0 {
                cell.textLabel?.hidden = false
                cell.textLabel?.text = "No friends are going to places you have been"
                cell.textLabel?.numberOfLines = 2
                cell.destinationLabel.hidden = true
               
       
            } else {
                cell.destinationLabel.hidden = false
                for trip in tripArray {
                    if headers[indexPath.section] == trip.tripDestination {
                        cell.textLabel?.hidden = true
                        cell.destinationLabel.text = trip.userName
                    }
                }
              
              
               
              
             
                
            }
      
        
          
          
            
        
        
        }
        
        return cell
        
    }
    
 
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    

    

}
