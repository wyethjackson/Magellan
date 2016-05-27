//
//  searchForTravelEnthusiastsTableViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 4/29/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class searchForTravelEnthusiastsTableViewController: UITableViewController {
     let searchController = UISearchController(searchResultsController: nil)
    struct Person {
        var name: String
        var userId: String
    }
    var filteredPeople = [Person]()
    var people = [Person]()
    
    var headers = ["Top Results", "Invite people to join"]
    var join = ["Email invite", "Facebook invite", "tweet at someone"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
//        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        tableView.tableHeaderView = searchController.searchBar
        
        var users : PFQuery = PFUser.query()!
        users.whereKey("homeCountry", equalTo: "United States")
        users.findObjectsInBackgroundWithBlock { (userObjects, error) in
            if let userObjects = userObjects {
                for userObject in userObjects {
                    if userObject.objectId != PFUser.currentUser()?.objectId {
                        self.people.append(Person(name: userObject["fullName"] as! String, userId: userObject.objectId!))
                    }
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var userQuery = PFUser.query()
        userQuery?.whereKey("fullName", hasPrefix: searchController.searchBar.text)
        
        userQuery?.findObjectsInBackgroundWithBlock({ (objects, error) in
            if let users = objects {
                if self.filteredPeople[0].name == "No matches for that name" {
                    self.filteredPeople.removeAtIndex(0)
                }
                for object in users {
                    self.filteredPeople.append(Person(name: object["fullName"] as! String, userId: object.objectId!))
                }
            }
            if self.filteredPeople.count == 0 {
                self.filteredPeople.append(Person(name: "No matches for that name", userId: ""))
            }
            self.tableView.reloadData()
        })
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if searchController.active && searchController.searchBar.text != "" {
                return filteredPeople.count
            }
            return people.count
            
        } else if section == 1 {
            return join.count
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if indexPath.section == 0 {
            var name = String()
            if searchController.active && searchController.searchBar.text != "" {
               
                name = filteredPeople[indexPath.row].name
                
            } else {
                name = people[indexPath.row].name
            }
            cell.textLabel!.text = name
        } else {
            cell.textLabel!.text = join[indexPath.row]
        }
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String) {
//        filteredCandies = candies.filter({( candy : Candy) -> Bool in
//            let categoryMatch = (scope == "All") || (candy.category == scope)
//            return categoryMatch && candy.name.lowercaseString.containsString(searchText.lowercaseString)
//        })
        
        var userQuery = PFUser.query()
        userQuery?.whereKey("fullName", hasPrefix: searchController.searchBar.text)
        
        userQuery?.findObjectsInBackgroundWithBlock({ (objects, error) in
            if let users = objects {
                self.filteredPeople = []
//                if self.filteredPeople.count > 0 {
//                    if self.filteredPeople[0].name == "No matches for that name" {
//                        self.filteredPeople.removeAtIndex(0)
//                    }
//                }
                for object in users {
                    if object.objectId != PFUser.currentUser()?.objectId {
                        self.filteredPeople.append(Person(name: object["fullName"] as! String, userId: object.objectId!))
                    }
                }
            }
            var secondUserQuery = PFUser.query()
            secondUserQuery?.whereKey("lastName", hasPrefix: self.searchController.searchBar.text)
            
            userQuery?.findObjectsInBackgroundWithBlock({ (secondObjects, error) in
                if let secondUsers = secondObjects {
                    for secondObject in secondUsers {
                        var nameInUse = false
                        for user in self.filteredPeople {
                            if user.name == secondObject["fullName"] as! String {
                                nameInUse = true
                                
                            }
                        }
                        if nameInUse == false {
                            if secondObject.objectId != PFUser.currentUser()?.objectId! {
                                self.filteredPeople.append(Person(name: secondObject["fullName"] as! String, userId: secondObject.objectId!))
                            }
                        }
                    }
                }
                if self.filteredPeople.count == 0 {
                    self.filteredPeople.append(Person(name: "No matches for that name", userId: ""))
                }
                self.tableView.reloadData()
            })
                
            
        })
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if searchController.active && searchController.searchBar.text != "" {
                Manager.dataToPass = filteredPeople[indexPath.row].userId
            } else {
                Manager.dataToPass = people[indexPath.row].userId
            }
                self.performSegueWithIdentifier("searchPeopleToProfileSegue", sender: self)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension searchForTravelEnthusiastsTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension searchForTravelEnthusiastsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
//        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
