//
//  businessCategoryShowViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/2/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
//import RealmSwift

class businessCategoryShowViewController: UITableViewController {
    var businessCategoriesSelected = [String]()
    var businessCategoriesList = ["Restaurants", "Nightlife", "Shopping", "Food", "Beauty & Spas", "Arts & Entertainment", "Active Vacation", "Hotels & Travel", "Currency Exchange"]
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.businessCategoriesSelected = Manager.businessCategoriesSelected
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessCategoriesList.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCategoryCell", forIndexPath: indexPath) as UITableViewCell?
        
      
            cell!.textLabel?.text = self.businessCategoriesList[indexPath.row]
        
        if businessCategoriesList[indexPath.row] != "Currency Exchange" {
                 cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        
        return cell!
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if businessCategoriesList[indexPath.row] == "Currency Exchange" {
            businessCategoriesSelected.append("Currency Exchange")

            Manager.businessCategoriesSelected = businessCategoriesSelected
            func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                Manager.businessCategoriesSelected = businessCategoriesSelected
            }
            
            self.performSegueWithIdentifier("categoryShowBackToAddCategory", sender: self)

            
        } else {
            Manager.dataToPass = businessCategoriesList[indexPath.row]
            self.performSegueWithIdentifier("businessCategoriesToSpecificCategoriesSegue", sender: self)

        }
            
        
        
        
        
        
    }
    

}
