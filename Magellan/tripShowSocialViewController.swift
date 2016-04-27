//
//  tripShowSocialViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/8/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class tripShowSocialViewController: UIViewController, UITableViewDelegate {
  
    @IBOutlet var postingTableView: UITableView!
    var sections = ["Blog Entry", "Blog Posts", "Comments"]
    var sectionContent = [["Share a story from your trip!"], ["No Stories Have Been Posted"], ["No One Has Commented On Your Trip"]]
    var blogPosts = [String]()
    var blogComments = [String]()
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContent[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
     let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
       cell.textLabel!.text = sectionContent[indexPath.section][indexPath.row]
        if indexPath.section == 0 {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        //        print(userTripCount)
        //        print(tripNames)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        
//        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = blurView
        

        
        return cell
        
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Share Your Stories"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
