//
//  businessHomeViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 1/27/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
//import RealmSwift

class businessHomeViewController: UIViewController {
    var companyName = String()
    var services = [String]()
   
    @IBOutlet var navigationDashboard: UINavigationItem!

    @IBOutlet var serviceTableView: UITableView!
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
//        if segue.sourceViewController .isKindOfClass(addBusinessCategoryViewController) {
//            
//        }
        
        serviceTableView.reloadData()
        
        
    }
    
    
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
      
        return true
    }
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var eventLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)

        navigationDashboard.titleView?.backgroundColor = UIColor.clearColor()
        navigationDashboard.titleView?.addSubview(blurView)
//        eventLabel.text = self.companyName + " events"
//        navigationBar.topItem?.title = self.companyName + " Dashboard"
//        var userQuery = PFQuery(className: "User")
//        
//        var userSpecific = userQuery.whereKey("objectId", equalTo: PFUser.currentUser()!)
//            userSpecific.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//                if let user = objects {
//                    for object in user {
//                        self.companyName = object["name"] as! String
//                    }
//                }
//        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if services.count == 0 {
            return 1
        } else {
            return services.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
      
        
        if services.count == 0 {
            cell.textLabel!.text = "No Business Services Have Been Added Yet"
        } else {
            cell.textLabel!.text = services[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
     
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
        return cell
        
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
