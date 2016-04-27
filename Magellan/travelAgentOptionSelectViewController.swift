//
//  travelAgentOptionSelectViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/2/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
//import RealmSwift

class travelAgentOptionSelectViewController: UIViewController, UITableViewDelegate {
    var selectionType = ""
    var seasonValues = ["Summer", "Fall", "Winter", "Spring"]
    var climateValues = ["Tropical", "Dry", "Snow-covered", "Moderate", "Polar"]
    var tempValues = [ "Hot", "Warm", "Cool", "Cold"]
    
    var vacationTypes = ["Relaxing", "Adventurous", "A Mix of Both"]
  
    var travelAgentAttributes = [String]()

    @IBOutlet var selectionLabel: UILabel!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectionType {
            case "Season":
                return seasonValues.count
            case "Climate":
                return climateValues.count
            case "Temp":
                return tempValues.count
            case "Vacation Type":
                return vacationTypes.count
            default:
                return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch selectionType {
            case "Season":
               cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "selectionCell")
                cell.textLabel?.text = self.seasonValues[indexPath.row]
            
            case "Climate":
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "selectionCell")
                cell.textLabel?.text = self.climateValues[indexPath.row]
            
            case "Temp":
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "selectionCell")
                cell.textLabel?.text = self.tempValues[indexPath.row]
            
            case "Vacation Type":
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "selectionCell")
                cell.textLabel?.text = self.vacationTypes[indexPath.row]
            
            default:
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "selectionCell")
                cell.textLabel?.text = "Test"
            
        }
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
//        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//         cell.accessoryType = UITableViewCellAccessoryType.DetailButton
       
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
        return cell
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch selectionType {
        case "Season":
            

            travelAgentAttributes[0] = seasonValues[indexPath.row]
          
        case "Climate":
            
            travelAgentAttributes[1] = climateValues[indexPath.row]
            
        case "Temp":
            
            travelAgentAttributes[2] = tempValues[indexPath.row]
          
        case "Vacation Type":
          
            travelAgentAttributes[3] = vacationTypes[indexPath.row]
      
        
        default:
            Manager.secondDataToPass = "Season"
           
        }
        
        Manager.travelAgentAttributes = travelAgentAttributes
         self.performSegueWithIdentifier("selectionBackToTravelAgent", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectionType = Manager.dataToPass
        self.travelAgentAttributes = Manager.travelAgentAttributes
        
        
      
        if self.selectionType == "Season" {
                navigationItem.title = "Add the Season you intend to travel"
            
        } else if self.selectionType == "Climate" {
            
            navigationItem.title = "Add the ideal climate of your trip"
            
        } else if self.selectionType == "Temp" {
            
           navigationItem.title = "Add the ideal temperature type of your trip"
            
        } else if self.selectionType == "Vacation Type" {
            navigationItem.title = "Add the type of vacation you wish to have"
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
