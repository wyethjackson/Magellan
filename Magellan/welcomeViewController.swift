//
//  welcomeViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/8/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit
import FBSDKCoreKit


class welcomeViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
  
    
    @IBOutlet var signInLabel: UIButton!
    
    @IBOutlet var signUpLabel: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        let url = NSURL(string: "https://twitter.com/search?q=%23travel%20near%3A%22New%20York%2C%20NY%22%20within%3A15mi&src=typd")
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//        }
//        
//        task.resume()
        
//        
//        if PFUser.currentUser() != nil {
////            self.performSegueWithIdentifier("initialScreenToHome", sender: self)
//        }
//            titleLabel.font = UIFont (name: "AmericanTypewriter", size: 22)
//            signUpLabel.layer.cornerRadius = 2
//            signInLabel.layer.cornerRadius = 2
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
           
        }
        
  
    }
  
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("public_profile")
            {
                // Do work
                print("*********result*********")
               print(result)
                print("********granted permissions**********")
                print(result.grantedPermissions)
                
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
