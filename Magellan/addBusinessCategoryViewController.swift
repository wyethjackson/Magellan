//
//  addBusinessCategoryViewController.swift
//  
//
//  Created by Wyeth Jackson on 2/2/16.
//
//

import UIKit
import Parse
//import RealmSwift

class addBusinessCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var businessCategory = String()
    var businessCategoriesSelected = [String]()
    var businessInfoCategory = String()
    @IBOutlet var tableView1: UITableView!
    
    @IBOutlet var tableView2: UITableView!
    
    
    @IBAction func addCategoryButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("addCategoryToAddServiceSegue", sender: self)
        
    }
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if segue.sourceViewController .isKindOfClass(businessCategoryShowViewController) {
            var viewData:businessCategoryShowViewController = segue.sourceViewController as! businessCategoryShowViewController
            
            businessCategoriesSelected = viewData.businessCategoriesSelected
           
        } else if segue.sourceViewController .isKindOfClass(businessCategoriesSpecificShowViewController) {
            var viewData:businessCategoriesSpecificShowViewController = segue.sourceViewController as! businessCategoriesSpecificShowViewController
            businessCategoriesSelected = viewData.businessCategoriesSelected
        }
         tableView2.reloadData()
//        self.businessCategoriesSelected = Manager.businessCategoriesSelected
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        self.businessCategoriesSelected = Manager.businessCategoriesSelected
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.businessCategoriesSelected = Manager.businessCategoriesSelected
    }
    
    @IBAction func submitCategories(sender: AnyObject) {
       
        Manager.categoryArray = businessCategoriesSelected
        self.performSegueWithIdentifier("addCategoriesToBusinessSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.businessInfoCategory = Manager.dataToPass
        self.businessCategoriesSelected = Manager.businessCategoriesSelected
        
//        if self.businessCategoriesSelected.count < 1 {
//            self.tableView2.hidden = true
//        }
        print(businessCategoriesSelected)
        print("yoooo")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView1 {
             return 1
        } else {
            return businessCategoriesSelected.count
        }
       
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if tableView == self.tableView1 {
             cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "businessAddCategoryCell")
             cell.textLabel?.text = "Add Category"
                 cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        } else {
             cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "categoriesAddedCell")
             cell.textLabel?.text = businessCategoriesSelected[indexPath.row]
//               cell.accessoryType = UITableViewCellAccessoryType.
            
        }
        return cell
        
    }
    
   func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
        if tableView == self.tableView2 {
        businessCategoriesSelected.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    }
  
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if tableView == self.tableView1 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == self.tableView1 {
            
            Manager.businessCategoriesSelected = self.businessCategoriesSelected
            self.performSegueWithIdentifier("addBusinessCategorySegue", sender: self)
        }
     
        
        
        
    }
}
