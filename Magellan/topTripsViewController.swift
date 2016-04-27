//
//  topTripsViewController.swift
//  
//
//  Created by Wyeth Jackson on 3/7/16.
//
//

import UIKit
import Parse

class topTripsViewController: UITableViewController {
  
    var refresher: UIRefreshControl!
    var headers = ["Miami Beach, Florida", "Trip to Bahamas", "Hotel Riu Palace Las Americas", "Coachella Festival 2016", "Ultra Music Festical 2016"]
    
    var tripNameLabels = [["Miami, Florida"], ["Cancun, Mexico"], ["Bahamas"], ["Cancun Mexico"], ["Indio, California"], ["Miami, Florida"]]
    var dateLabels = [["Expires April 20, 2016"], ["Expires April 20, 2016"], ["Expires April 20, 2016"], ["Deal Ends June 15, 2016"], ["May 16, 2016 - May 25, 2016"], ["July 20, 2016 - July 28, 2016"]]
    var budgetLabel = [["$500 per person"], ["$650 per person"], ["$425 per person"], ["$1000 per person"], ["$750 per person"], ["$1250 per person"]]
    
    
    func refresh() {
        print("refreshed")
        
        
        self.refresher.endRefreshing()
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = NSURL(string: "https://www.google.com/#safe=off&q=europe+destinations")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.5 //make the header transparent
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripNameLabels[section].count
        
        
    }
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var returnedView = UIView()
//        returnedView.backgroundColor = UIColor.darkGrayColor()
//        
//        var label = UILabel()
//        label.text = headers[section]
//        label.textColor = UIColor.whiteColor()
//        returnedView.addSubview(label)
//        
//        return returnedView
//    }
    

    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 174
//        } else if indexPath.row == 1 {
//            return 47
//        } else if indexPath.row == 2 {
//            return 47
//        }
//        return 100
//        
//    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
       return headers[section]
    }
////
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = topTripsTableViewCell()
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! topTripsTableViewCell
            cell.tripNameLabel.text = tripNameLabels[indexPath.section][indexPath.row]
            cell.dateLabel.text = dateLabels[indexPath.section][indexPath.row]
            cell.budgetLabel.text = budgetLabel[indexPath.section][indexPath.row]
            
            
        } else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("socialCell", forIndexPath: indexPath) as! topTripsTableViewCell
           
        } else if indexPath.row == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("additionalInfoCell", forIndexPath: indexPath) as! topTripsTableViewCell
           
        }
        
        
        
      return cell
    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.row == 1 {
//            self.performSegueWithIdentifier("tripFeedToAdviceSegue", sender: self)
//        } else if indexPath.row == 2 {
//            self.performSegueWithIdentifier("tripFeedToShowEventsSegue", sender: self)
//        }
//    }

}
