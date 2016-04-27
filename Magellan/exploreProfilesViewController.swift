//
//  exploreProfilesViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/19/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class exploreProfilesViewController: UITableViewController {
    
    var firstName = [String]()
    var lastName = [String]()
    var userId = [String]()
    var follow = [Bool]()
    var userImage = [UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentUser = PFUser.currentUser()
        var currentUserId = currentUser?.objectId
        print(currentUserId)
        
//        var userFollowsQuery = PFQuery(className: "user_followers")
//        var userFollows = userFollowsQuery.whereKey("userId", equalTo: object.objectId!)
//        var followerQuery = userFollows.whereKey("followerId", equalTo: PFUser.currentUser()!.objectId!)
//        followerQuery.findObjectsInBackgroundWithBlock({ (objects, error) in
//            if let userFollow = objects {
//                for object in userFollow {
//                    if object["userId"] != nil {
//                        self.follow.append(true)
//                    } else {
//                        self.follow.append(false)
//                    }
//                }
//            }
//        })
        var users : PFQuery = PFUser.query()!
      users.whereKey("homeCountry", equalTo: "United States")
        
        users.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error != nil {
                print(error)
            }
            if let user = objects {
                for object in user {
//                    if object.objectId != currentUserId {
                    print(object)
                    if object.objectId != PFUser.currentUser()?.objectId {
                         self.firstName.append(object["firstName"] as! String)
                        self.lastName.append(object["lastName"] as! String)
                        self.userId.append(object.objectId!)
                
                    
//                    if object["profileImage"] == nil {
                        self.userImage.append(UIImage(named: "blank_man.jpg")!)
//                    } else {
//                        self.userImage.append(UIImage(named: object["profileImage"] as! String)!)
//                    }
                   
//                    }
                       
                    }
                }
                
                
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstName.count
    }
  
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("exploreCell", forIndexPath: indexPath) as! exploreTableViewCell
        
        
        
        
        
//        cell.postedImage.image = images[indexPath.row]
        
        cell.cellLabel.text = "\(firstName[indexPath.row]) \(lastName[indexPath.row])"
       
//        cell.cellImage.image = userImage[indexPath.row]
//        cell.cellImage.contentMode = UIViewContentMode.ScaleAspectFit
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
      
        return cell
        
    }
  
//    func buttonClicked(button : UIButton) {
//         let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: button.tag, inSection:0)
////        let cell = tableView.dequeueReusableCellWithIdentifier("exploreCell", forIndexPath: indexPath) as! exploreTableViewCell
//        cell.followUserButton.backgroundColor = UIColor.greenColor()
//        cell.followUserButton.setImage(UIImage(named: "Checked User Filled-50.png"), forState: .Normal)
//    }
//    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            Manager.dataToPass = userId[indexPath.row]
       
            self.performSegueWithIdentifier("exploreToProfileSegue", sender: self)
        
        
        
        
        
    }

    
    
    
}
