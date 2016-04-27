//
//  searchParticipantsInAddGroupTrip.swift
//  Magellan
//
//  Created by Wyeth Jackson on 3/29/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class searchParticipantsInAddGroupTrip: UITableViewController {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var friends = [String]()
    var filteredFriends = [String]()
    var filteredPeople = [String]()
    var participants = [String]()
    var participantIds = [String]()
    var peopleIds = [String]()
    var headers = ["Followers", "Others"]
    
//    override func viewDidAppear(animated: Bool) {
//        tableView.tableHeaderView = searchController.searchBar
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        var userFollowQuery = PFQuery(className: "user_followers")
        var userFollows = userFollowQuery.whereKey("followerId", equalTo: (PFUser.currentUser()?.objectId)!)
        userFollows.findObjectsInBackgroundWithBlock { (objects, error) in
            if let userFollowers = objects {
                for object in userFollowers {
                    print(object["userId"])
                    var users : PFQuery = PFUser.query()!
                    var userQuery = users.whereKey("objectId", equalTo: object["userId"])
                    
                    userQuery.findObjectsInBackgroundWithBlock { (userObjects, error) in
                        if let user = userObjects {
                            for userObject in user {
                                print(userObject["fullName"])
                                self.friends.append(userObject["fullName"] as! (String))
                                self.tableView.reloadData()
                            }
                            self.tableView.reloadData()
                        }
                         self.tableView.reloadData()
                    }
                     self.tableView.reloadData()
                }
                 self.tableView.reloadData()
            }
             self.tableView.reloadData()
        }
        
        

    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.5 //make the header transparent
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
    
        filteredFriends = friends.filter({( location) -> Bool in
            let categoryMatch = (scope == "All") || (location == scope)
            return categoryMatch && location.lowercaseString.containsString(searchText.lowercaseString)
        })
        
        if filteredFriends.count == 0 {
            filteredPeople = []
            var users : PFQuery = PFUser.query()!
            var userQuery = users.whereKey("fullName", hasPrefix: searchText)
            userQuery.limit = 25
            userQuery.findObjectsInBackgroundWithBlock({ (objects, error) in
                if let user = objects {
                    for object in user {
                        self.filteredPeople.append(object["fullName"] as! (String))
                    }
                }
                self.tableView.reloadData()
            })
            
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
      
            return headers.count
    
       
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        return headers[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            if searchController.active && searchController.searchBar.text != "" {
                if section == 0 {
                    if filteredFriends.count == 0 {
                        return 1
                    } else {
                        return filteredFriends.count
                    }
                } else {
                    return filteredPeople.count
                }
            } else {
                return friends.count
            }
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = compSearchTableViewCell()
        var cell = UITableViewCell()
       
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
//                as! compSearchTableViewCell
            
            //            cell.typeOfCompRoomLabel.text = comps[indexPath.row].roomType
            if searchController.active && searchController.searchBar.text != "" {
                if indexPath.section == 0 {
                    if filteredFriends.count == 0 {
                        cell.textLabel!.text = "No Followers match that name"
                    }else {
                        cell.textLabel!.text = filteredFriends[indexPath.row]
                    }
                } else {
                    cell.textLabel!.text = filteredPeople[indexPath.row]
                }
            } else {
                cell.textLabel!.text = friends[indexPath.row]
            }
        
            return cell
            
      
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType != .Checkmark {
            self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
            self.tableView.reloadData()
        } else {
            self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
            self.tableView.reloadData()
        }
        
        
        
        
        
    }
}



extension searchParticipantsInAddGroupTrip: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
  

    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
         filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        
      
       
    }
}

extension searchParticipantsInAddGroupTrip: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        //        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
