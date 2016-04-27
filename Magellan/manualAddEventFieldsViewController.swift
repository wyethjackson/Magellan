//
//  manualAddEventFieldsViewController.swift
//  
//
//  Created by Wyeth Jackson on 2/16/16.
//
//

import UIKit
import Parse

class manualAddEventFieldsViewController: UIViewController {
    var tripId = String()
    var eventInfo = String()
    var eventDateInfo = NSDate()
    var eventInfoData = String()
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var textField: UITextField!
    
    
    @IBOutlet var textBox: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tripId = Manager.tripId
        
        self.eventInfo = Manager.dataToPass
        
        
        if self.eventInfo == "Event Name" {
            textField.placeholder = "Name"
            datePicker.hidden = true
            textBox.hidden = true
        } else if self.eventInfo == "Event Address"{
            datePicker.hidden = true
            textBox.hidden = true
            textField.placeholder = "Event Address"
        
        } else if self.eventInfo == "Event Description" {
            
            datePicker.hidden = true
            textField.hidden = true
            
        } else if self.eventInfo == "Event Date" {
            
            textField.hidden = true
            textBox.hidden = true
        }
        
        
    }
    
    @IBAction func addEventButton(sender: AnyObject) {
        
      Manager.tripId = self.tripId
        
        
        
        if self.eventInfo == "Event Name" {
            
            Manager.secondDataToPass = "Event Name"
            eventInfoData = textField.text!
            
            
        } else if self.eventInfo == "Event Address" {
            
            Manager.secondDataToPass = "Event Address"
            eventInfoData = textField.text!
        
    } else if self.eventInfo == "Event Description" {
            
            Manager.secondDataToPass = "Event Description"
           eventInfoData = textBox.text!
            
            
        } else if self.eventInfo == "Event Date" {
            
            Manager.secondDataToPass = "Event Date"
            eventDateInfo = datePicker.date
        }
        
        self.performSegueWithIdentifier("manualEventInfoUnwind", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
