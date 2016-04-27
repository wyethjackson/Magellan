//
//  addGroupTripViewController.swift
//  
//
//  Created by Wyeth Jackson on 2/17/16.
//
//

import UIKit
import Parse

class addGroupTripViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    var participants = [String]()
  
    let searchController = UISearchController(searchResultsController: nil)
  
    var doubleAdd = false
    var headers = ["Add Participants", "Trip Participants"]
    
    @IBOutlet var tableView: UITableView!
  
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
//        searchResultsTableView.dataSource = self
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.5 //make the header transparent
    }
    
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if participants.count > 0 {
        return 2
    } else {
        return 1
    }
    
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if participants.count > 0 {
            return headers[section]
        } else {
            return "Add Participants"
        }
        
    }
    

    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return participants.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
//        if tableView == self.participantTableView {
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "participantsCell")
//            if participants.count > 0 {
//                cell.textLabel?.text = participants[indexPath.row]
//            } else {
//                cell.textLabel?.text = "No friends or family added yet"
//            }
//        } else {
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "searchCell")
//            
//            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//            if searchActive {
//                cell.textLabel?.text = filtered[indexPath.row]
//            } else {
//                cell.textLabel?.text = friendsSearchData[indexPath.row]
//            }
//        }
        //        print(userTripCount)
        //        print(tripNames)
        
        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        if indexPath.section == 0 {
            cell.textLabel!.text = "Add People to Trip"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else if indexPath.section == 1 {
            cell.textLabel!.text = participants[indexPath.row]
        }
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
//        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
//        cell.backgroundColor = UIColor.clearColor()
//        cell.backgroundView = blurView
        
     
       
        
        
        
        
        
        return cell
        
    }
    
    //    objectId = NSUserDefaults.standardUserDefaults().objectForKey("objectId") as [String]
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let path = self.tableView.indexPathForSelectedRow!
        //        segue.tripShowViewController.detail = self.detailForIndexPath(path)
        //        print(tripIds[indexPath.row])
//        if tableView == self.searchResultsTableView {
//            for participant in participants {
//                if friendsSearchData[indexPath.row] == participant {
//                    doubleAdd = true
//                }
//            }
//            if filtered.count == 0 {
//                if doubleAdd == false {
//                    participants.append(friendsSearchData[indexPath.row])
//                }
//            } else {
//                if doubleAdd == false {
//                    participants.append(filtered[indexPath.row])
//                }
//            }
//            
//            searchActive = false
//            participantTableView.reloadData()
//            searchResultsTableView.reloadData()
//           doubleAdd = false
//        }
        if indexPath.section == 0 {
            self.performSegueWithIdentifier("addPeopleToGroupTripSegue", sender: self)
        }
        
    }

    
}

extension addGroupTripViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
    }
}
