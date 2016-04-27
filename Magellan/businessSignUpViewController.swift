//
//  businessSignUpViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 1/27/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
import CoreData
//import RealmSwift

class businessSignUpViewController: UIViewController {
    
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var companyNameTextField: UITextField!
    @IBOutlet var companyEmailTextField: UITextField!
    @IBOutlet var pointOfContactTextField: UITextField!
    @IBOutlet var companyPhoneNumberTextField: UITextField!
    
    @IBOutlet var companyPasswordTextField: UITextField!
    @IBOutlet var businessCategoryPicker: UIPickerView!
    
    @IBOutlet var otherCategoryTextField: UITextField!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signUpButton(sender: AnyObject) {
        print("YOOOOOOOOOO")
        if companyEmailTextField.text == "" || companyPasswordTextField == "" || pointOfContactTextField == "" || companyPhoneNumberTextField == "" {
            displayAlert("Error in form", message: "Please fill out all the fields")
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
        var user = PFUser()
        user.username = companyEmailTextField.text
        user.password = companyPasswordTextField.text
        user.email = companyEmailTextField.text
        user["name"] = pointOfContactTextField.text
        user["companyName"] = companyNameTextField.text
        user["phoneNumber"] = companyPhoneNumberTextField.text
//        user["businessCategory"] = businessCategoryPicker.description
//        user["otherCategory"] = otherCategoryTextField.text
        user["business"] = "true"
        var errorMessage = "Please try again later"
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            if error == nil {
                print("successful")
                var alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                self.performSegueWithIdentifier("businessSignUpToBusinessHome", sender: self)
                
            } else {
                if let errorString = error!.userInfo["error"] as? String {
                    errorMessage = errorString
                    
                
                }
                
                self.displayAlert("Failed Signup", message: errorMessage)
            }
        }
        
    }
    
}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.font = UIFont (name: "AmericanTypewriter", size: 22)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
