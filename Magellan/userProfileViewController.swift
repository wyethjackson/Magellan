//
//  userProfileViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/18/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class userProfileViewController: UIViewController {
    var userId = String()
    var firstName = String()
    var lastName = String()
    var tripNames = [String]()
    var tripDestinations = [NSArray]()
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var numberUserIsFollowing: UILabel!
    var tripImage = [UIImage]()
    @IBOutlet var tripTableView: UITableView!
    @IBOutlet var numberOfFollowers: UILabel!
    var refresher: UIRefreshControl!
    @IBOutlet var nameLabel: UILabel!
    var following = false
    var headers = ["Trips"]
    
    struct Person {
        var name: String
    }
    
    var person = Person(name: "")
    
//    var userId = PFUser.currentUser()?.objectId
    
    @IBOutlet var followButton: UIButton!
    
    func refresh() {
        
        
        refresher.endRefreshing()
    }
    
    @IBAction func followUser(sender: AnyObject) {
    
        if following == false {
            var userFollows = PFObject(className: "user_followers")
            userFollows["userId"] = userId
            userFollows["followerId"] = PFUser.currentUser()?.objectId
            userFollows.saveInBackgroundWithBlock { (success, error) -> Void in
                if success == true {
                    print("Successful")
                } else {
                    print("Failed")
                    print(error)
                }
            }
            
           
           
            followButton.setImage(UIImage(named: "Checked_User_Color.png"), forState: .Normal)
            following = true
        } else {
            var userFollowsQuery = PFQuery(className: "user_followers")
            var userFollows = userFollowsQuery.whereKey("userId", equalTo: self.userId)
            var followerQuery = userFollows.whereKey("followerId", equalTo: (PFUser.currentUser()?.objectId)!)
            followerQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let userFollower = objects {
                    for object in userFollower {
                        object.deleteInBackground()
                    }
                }
            })
           
            followButton.setImage(UIImage(named: "Add User Filled-50.png"), forState: .Normal)
            following = false
        }
    }
   
    
//    override func viewDidAppear(animated: Bool) {
//       nameLabel.text = self.firstName + " " + self.lastName
//        if following == true {
//            followButton.backgroundColor = UIColor.greenColor()
//            followButton.setImage(UIImage(named: "Checked User Filled-50.png"), forState: .Normal)
//        } else {
//            followButton.backgroundColor = UIColor.lightGrayColor()
//            followButton.setImage(UIImage(named: "Add User Filled-50.png"), forState: .Normal)
//        }
//        self.tripTableView.reloadData()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
//        self.tableView.addSubview(refresher)
        self.userId = Manager.dataToPass
        
      var users : PFQuery = PFUser.query()!
        var userQuery = users.whereKey("objectId", equalTo: self.userId)
        userQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let user = objects {
                for object in user {
                    self.person.name = object["fullName"] as! String
                    
                    
                    
                    
                }
                
                self.navigationItem.title = self.person.name
            }
        }
        
        var userFollowsQuery = PFQuery(className: "user_followers")
        var userFollows = userFollowsQuery.whereKey("userId", equalTo: self.userId)
         var followerQuery = userFollows.whereKey("followerId", equalTo: (PFUser.currentUser()?.objectId)!)
        followerQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let userFollow = objects {
                for object in userFollow {
                    if object["userId"] != nil {
                        print(object["userId"])
                        self.following = true
                    } else {
                        self.following = false
                    }
                    
                    if self.following == true {
                        
                        self.followButton.setImage(UIImage(named: "Checked_User_Color.png"), forState: .Normal)
                        
                    } else {
                        
                        self.followButton.setImage(UIImage(named: "Add User Filled-50.png"), forState: .Normal)
                        
                    }
                }
            }
        }
        
        var tripQuery = PFQuery(className: "Trips")
        
        var tripsQuery = tripQuery.whereKey("userId", equalTo: self.userId)
        
        tripsQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let trip = objects {
                for object in trip {
                    self.tripNames.append(object["name"] as! String)
                    self.tripDestinations.append(object["destinations"] as! NSArray)
                    if object["tripImage"] == nil {
                        self.tripImage.append(UIImage(named: "photo-7.png")!)
                    }
                }
            }
        }
        
        
//        followButton.frame = CGRectMake(160, 100, 50, 50)
//        followButton.layer.cornerRadius = 0.5 * followButton.bounds.size.width
       
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.5 //make the header transparent
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tripNames.count > 0 {
            return tripNames.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        let cell:userProfileTripCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! userProfileTripCell
        //        print(userTripCount)
        //        print(tripNames)
        
//        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
//        let blurView = UIVisualEffectView(effect: blur)
        
//        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell.backgroundColor = UIColor.lightGrayColor()
//        cell.backgroundView = blurView
       
        
     
        
        
        if tripNames.count > 0 {
            var destinationsArray = [String]()
            var destinations = self.tripDestinations[indexPath.row]
            for destination in destinations {
                var capDestination = destination.capitalizedString
                destinationsArray.append(capDestination as! String)
                
            }
            
            var destinationString = destinationsArray.joinWithSeparator(", ")
            cell.tripNameLabel.text = tripNames[indexPath.row]
            cell.destinationsLabel.text = destinationString
            cell.tripImage.image = tripImage[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
         
        } else {
           
//            cell.textLabel?.text = "No trips have been planned!"
        }
        
        
        
        
        
        return cell
        
    }
    
    //    objectId = NSUserDefaults.standardUserDefaults().objectForKey("objectId") as [String]
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        //        let path = self.tableView.indexPathForSelectedRow!
//        //        segue.tripShowViewController.detail = self.detailForIndexPath(path)
//        //        print(tripIds[indexPath.row])
//        if tripNames.count > 0 {
//            dataToPass = tripIds[indexPath.row]
//            Manager.dataToPass = self.dataToPass
//            self.performSegueWithIdentifier("homeToTripShow", sender: tripIds[indexPath.row])
//        }
//        
//        
//        
//        
//    }
//    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
     
    }
}
