//
//  businessAddEventDateTimeViewController.swift
//  
//
//  Created by Wyeth Jackson on 2/11/16.
//
//

import UIKit
import Parse

class businessAddEventDateTimeViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    var eventDate = NSDate()
    var eventDateCreated = false
   
    @IBAction func addDateButton(sender: AnyObject) {
        eventDate = datePicker.date
        eventDateCreated = true
        self.performSegueWithIdentifier("eventDateUnwind", sender: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
