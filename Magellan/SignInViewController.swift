//
//  SignInViewController.swift
//  Magellan Application
//
//  Created by Wyeth Jackson on 12/15/15.
//  Copyright © 2015 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
//import RealmSwift


class SignInViewController: UIViewController {
    
    
    @IBOutlet var welcomeLabel: UILabel!
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func logInButton(sender: AnyObject) {
        
        if email.text == "" || password.text == "" {
            displayAlert("Error in form", message: "Please enter an email and password")
            
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"
            
            PFUser.logInWithUsernameInBackground(email.text!, password: password.text!, block: {(user, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if user != nil {
                    //Logged In!
                    if user!["business"] as! String == "false" {
                        self.performSegueWithIdentifier("signInToHome", sender: self)
                        print("logged in!!!")
                    } else {
                        self.performSegueWithIdentifier("signInToBusinessHome", sender: self)
                    }
                    
                } else {
                    
                    if let errorString = error!.userInfo["error"] as? String {
                        
                        errorMessage = errorString
                        
                    }
                    
                    self.displayAlert("Failed Log In", message: errorMessage)
                    
                }
            })
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.font = UIFont(name: "AmericanTypewriter", size: 22)
//        if PFUser.currentUser() != nil {
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as! UIViewController
//                self.presentViewController(viewController, animated: true, completion: nil)
//            })
//        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}