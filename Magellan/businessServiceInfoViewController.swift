//
//  businessServiceInfoViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/9/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class businessServiceInfoViewController: UIViewController {
    var businessInfoCategory = String()
    var businessInfo = String()
    @IBOutlet var businessInfoTextField: UITextField!
    

    @IBAction func addButton(sender: AnyObject) {
       
       self.businessInfo = self.businessInfoTextField.text!
        performSegueWithIdentifier("businessInfoToAddService", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView?.backgroundColor = UIColor.clearColor()
        self.businessInfoCategory = Manager.dataToPass
        
        switch businessInfoCategory {
        case "Name":
            navigationItem.title = "Add Name"
            businessInfoTextField.placeholder = "Chicago Museum of Art"
        case "Address":
            navigationItem.title = "Add Address"
            businessInfoTextField.placeholder = "Address Goes Here"
        case "Description (Optional)":
            navigationItem.title = "Add Description"
            businessInfoTextField.placeholder = "Description"
        case "Hours":
            navigationItem.title = "Add Service Hours"
            businessInfoTextField.placeholder = "e.g. M-F 10am-5pm, Sat 11am-6pm, Sun 12pm-5pm"
        case "Phone":
            navigationItem.title = "Add a Service Number"
            businessInfoTextField.placeholder = "920-555-1847"
        case "Website":
            navigationItem.title = "Add a website URL"
            businessInfoTextField.placeholder = "e.g. www.google.com"
        default:
            print("COOL")
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
