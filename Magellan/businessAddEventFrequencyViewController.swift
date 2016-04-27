//
//  businessAddEventFrequencyViewController.swift
//  Pods
//
//  Created by Wyeth Jackson on 1/28/16.
//
//

import UIKit
import Parse
//import RealmSwift

class businessAddEventFrequencyViewController: UIViewController {
    @IBOutlet var eventFrequencySlider: UISlider!
    var daysClosed = [String]()
    @IBOutlet var dayPickerLabel: UILabel!
    var pickerData = [String]()
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dayPickerView: UIPickerView!
    @IBOutlet var eventFrequencyLabel: UILabel!
    var sliderValues = ["once", "daily", "weekly", "yearly"]
    var sliderValue = String()
    var pickerValue = ""
    var eventId = String()
    var onceDate = NSDate()
    var eventFrequency = String()
    var addEventInfo = String()
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var textDescriptionField: UITextField!
    
    var eventText = String()

    
    @IBAction func addEventInfoButton(sender: AnyObject) {
        if addEventInfo == "Description" {
                eventText = textDescriptionField.text!
        } else {
            eventText = textField.text!
        }
        
        self.performSegueWithIdentifier("eventInfoUnwind", sender: self)
    }
 
    
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addEventInfo = Manager.dataToPass
        if self.addEventInfo == "Description" {
            textField.hidden = true
            textDescriptionField.placeholder = "Event Description"
            navigationItem.title = "Add Description"
        } else if self.addEventInfo == "Name" {
            textDescriptionField.hidden = true
            textField.placeholder = "Event Name Here"
            navigationItem.title = "Add Name of Event"
        } else if self.addEventInfo == "Address" {
            textField.placeholder = "Address Here"
            textDescriptionField.hidden = true
            navigationItem.title = "Add Address"
        }
       
        
        
       
    }
    
    


 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    
    
  

}
