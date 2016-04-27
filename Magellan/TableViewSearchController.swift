//
//  TableViewSearchController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 1/22/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
//import GoogleMaps

class TableViewSearchController: UITableViewController, UISearchResultsUpdating {

    let appleProducts = ["Mac", "iPhone", "Apple Watch", "iPad"]
    
    var filteredAppleProducts = [String]()
    var resultSearchController = UISearchController()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return self.filteredAppleProducts.count
        } else {
            return self.appleProducts.count
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        
        if self.resultSearchController.active {
            cell!.textLabel?.text = self.filteredAppleProducts[indexPath.row]
            
        } else {
            cell!.textLabel?.text = self.appleProducts[indexPath.row]
        }
        
    return cell!
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        
        self.filteredAppleProducts.removeAll(keepCapacity:false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.appleProducts as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredAppleProducts = array as! [String]
        self.tableView.reloadData()
    }
    
}



