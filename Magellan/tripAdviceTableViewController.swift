//
//  tripAdviceTableViewController.swift
//  
//
//  Created by Wyeth Jackson on 5/3/16.
//
//

import UIKit
import Parse

class tripAdviceTableViewController: UITableViewController {
    struct Advice {
        var name: String
        var content: String
        var destination: String
    }
       var tripId = String()
    var headers = [String]()
    var adviceArray = [Advice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.tripId = Manager.tripId
       
        var destinationQuery = PFQuery(className: "Destinations")
        destinationQuery.whereKey("tripId", equalTo: self.tripId)
        destinationQuery.findObjectsInBackgroundWithBlock({ (destinationObjects, error) in
            if let destinationObjects = destinationObjects {
                for destinationObject in destinationObjects {
                    var destinationName = destinationObject["destinationName"]
                    self.headers.append(destinationObject["destinationName"] as! String)
                    var adviceQuery = PFQuery(className: "Advice")
                    adviceQuery.whereKey("destinationId", equalTo: destinationObject.objectId!)
                    adviceQuery.findObjectsInBackgroundWithBlock({ (adviceObjects, error) in
                        if let adviceObjects = adviceObjects {
                            for adviceObject in adviceObjects {
                                self.adviceArray.append(Advice(name: adviceObject["name"] as! String, content: adviceObject["adviceContent"] as! String, destination: destinationName as! String))
                            }
                            print(self.adviceArray)
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        })
        
    

        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        count = 0
        for advice in adviceArray {
            if headers[section] == advice.destination {
                count += 1
            }
        }
        if count != 0 {
            return count
        } else {
            return 1
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blueColor() //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.5 //make the header transparent
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//      
//        return 100
//        
//        
//        
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: tripAdviceTableViewCell
     
        cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! tripAdviceTableViewCell
      count = 0
        for advice in adviceArray {
            if headers[indexPath.section] == advice.destination {
                cell.nameLabel.text = advice.name
                cell.adviceLabel.text = advice.content
            }
        }
        
      
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
    }
    

    
    
    


}
