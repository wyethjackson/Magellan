//
//  travelAgentPlanTripViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/1/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
//import RealmSwift

class travelAgentPlanTripViewController: UIViewController, UITableViewDelegate {
    var theNavigationItem: UINavigationItem!
    var attributes = ["Season", "Climate", "Temp", "Vacation Type"]
 
    var travelAgentAttributes = [String]()
  
    @IBOutlet var tableView: UITableView!
 
    @IBOutlet var mySwitch: UISwitch!
    

    @IBOutlet var switchLabel: UILabel!
    
  
    @IBAction func switchAction(sender: AnyObject) {
        if mySwitch.on {
            switchLabel.text = "International Trip"
        } else {
             switchLabel.text = "Domestic Trip"
        }
       
    }
    
    @IBAction func getRecommendations(sender: AnyObject) {
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return travelAgentAttributes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "travelAgentCell")

        cell.textLabel?.text = travelAgentAttributes[indexPath.row]

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if attributes[indexPath.row] == "Season" {
            
            Manager.dataToPass = "Season"
           
          
        } else if attributes[indexPath.row] == "Climate"{

            Manager.dataToPass = "Climate"
           
            
            
        } else if attributes[indexPath.row] == "Temp" {

            Manager.dataToPass = "Temp"
          
            
        } else if attributes[indexPath.row] == "Vacation Type" {

            Manager.dataToPass = "Vacation Type"
          
            
        }
             Manager.travelAgentAttributes = travelAgentAttributes
          self.performSegueWithIdentifier("travelAgentToTypeSelectSegue", sender: self)
        
        
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       switchLabel.text = "International Trip"

        if Manager.travelAgentAttributes.count < 1 {
            self.travelAgentAttributes = ["Add The Season", "Add A Climate Type", "Add A Temperature", "Add A Vacation Type"]
        } else {
            self.travelAgentAttributes = Manager.travelAgentAttributes
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
}
