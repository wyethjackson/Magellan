//
//  SignInViewController.swift
//  Magellan Application
//
//  Created by Wyeth Jackson on 12/14/15.
//  Copyright © 2015 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
import CoreData
//import RealmSwift
//import SQLite



class SignUpViewController: UIViewController {
    var business = String()
    @IBOutlet var firstName: UITextField!
//    var databasePath = NSString()
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var lastName: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var homeCountryTextField: UITextField!
    
    //    var managedObjectContext = AppDelegate.managedObjectContext
    //    var managedObjectContext: NSManagedObjectContext?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
//    func setData(email, password, firstName, lastName, homeCountry) {
//        do {
//            let newUser = try UserDataHelper.insert(
//                User(
//                    
//                )
//            )
//        }
//    }
//    
    
    
    
    @IBAction func signUp(sender: AnyObject) {
        
//        let db = SQLiteDB.sharedInstance()
        
        
        
//        let filemgr = NSFileManager.defaultManager()
//        let dirPaths =
//            NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
//                                                .UserDomainMask, true)
//        
//        let docsDir = dirPaths[0] as! NSURL
//        
//        var databasePath = NSURL(fileURLWithPath: docsDir).URLByAppendingPathComponent(
//            "users.db")
//        
//        if !filemgr.fileExistsAtPath(databasePath as String) {
//            
//            let contactDB = FMDatabase(path: databasePath as String)
//            
//            if contactDB == nil {
//                println("Error: \(contactDB.lastErrorMessage())")
//            }
//            
//            if contactDB.open() {
//                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
//                if !contactDB.executeStatements(sql_stmt) {
//                    println("Error: \(contactDB.lastErrorMessage())")
//                }
//                contactDB.close()
//            } else {
//                println("Error: \(contactDB.lastErrorMessage())")
//            }
//        }
//
//        
        
        
        
        
        
        if emailTextField.text == "" || passwordTextField.text == "" || firstName.text == "" || lastName.text == "" {
            //            shouldPerformSegueWithIdentifier("signUpToProfileSegue", sender: AnyObject!) {
            //                return false
            //            }
            
            
            displayAlert("Error in form", message: "Please enter a username and password")
            
        } else {
            
            
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            
            var user = PFUser()
            
            user.username = emailTextField.text
            user.password = passwordTextField.text
            user.email = emailTextField.text
            user["firstName"] = firstName.text
            user["lastName"] = lastName.text
            user["business"] = "false"
            user["homeCountry"] = homeCountryTextField.text
            
            user["fullName"] = firstName.text! + " " + lastName.text!
            
            
            var errorMessage = "Please try again later"
            
            user.signUpInBackgroundWithBlock({(success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                if error == nil {
                    //Signup successful
                    var alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                   self.performSegueWithIdentifier("signUpToHome", sender: self)
                    print("Success")
                } else {
                    if let errorString = error!.userInfo["error"] as? String {
                        
                        
                        errorMessage = errorString
                        
                    }
                    
                    //                   func shouldPerformSegueWithIdentifier(identifier: "signUpToProfileSegue", sender: AnyObject!) -> Bool {
                    //
                    //                        return false
                    //
                    //                    }
                    
                    
                    
                    self.displayAlert("Failed Signup", message: errorMessage)
                    
                    
                }
            })
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       welcomeLabel.font = UIFont(name: "AmericanTypewriter", size: 22)
//        if PFUser.currentUser() != nil {
//            var userQuery = PFQuery(className: "User")
//            userQuery.whereKey("objectId", equalTo: PFUser.currentUser()!)
//            userQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
//                if let user = objects {
//                    for object in user {
//                        self.business = object["business"] as! String
//                       
//                    }
//                }
//            })
//            
//            
//            
//            
//        }
//        
//        //        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.managedObjectContext!) as! User?
//        
//        //        newUser.firstName = "John"
//        //        newUser.lastName = "Smith"
//        //        newUser.email = "johnsmith@gmail.com"
//        //        newUser.setValue("John", forKey: "first")
//        if PFUser.currentUser() != nil {
//            if self.business == "false" {
//                self.performSegueWithIdentifier("signUpToHome", sender: self)
//            } else {
////                self.performSegueWithIdentifier("signUpToBusinessHome", sender: self)
//            }
//        }
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
    
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