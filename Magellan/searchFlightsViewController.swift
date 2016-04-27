//
//  searchFlightsViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 1/26/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//
import UIKit
//import GoogleMaps
//UISearchResultsUpdating
class searchFlightsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
//    let appleProducts = ["Mac", "iPhone", "Apple Watch", "iPad"]
//    
//    var filteredAppleProducts = [String]()
//    var resultSearchController = UISearchController!()
//    
//    
//    @IBOutlet var tableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.resultSearchController = UISearchController(searchResultsController: nil)
//        self.resultSearchController.searchResultsUpdater = self
//        self.resultSearchController.dimsBackgroundDuringPresentation = false
//        self.resultSearchController.searchBar.sizeToFit()
//        self.tableView.tableHeaderView = self.resultSearchController.searchBar
//        self.tableView.reloadData()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
////    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
////        return 1
////    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.resultSearchController.active {
//            return self.filteredAppleProducts.count
//        } else {
//            return 0
////             self.appleProducts.count
//        }
//        
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
////        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
//         let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
//        
//        if self.resultSearchController.active {
//            cell.textLabel?.text = self.filteredAppleProducts[indexPath.row]
//            
//        }
////        else {
////            cell.textLabel?.text = self.appleProducts[indexPath.row]
////        }
//        
//        return cell        
//    }
//    
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        
//        
//        self.filteredAppleProducts.removeAll(keepCapacity:false)
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
//        let array = (self.appleProducts as NSArray).filteredArrayUsingPredicate(searchPredicate)
//        self.filteredAppleProducts = array as! [String]
//        self.tableView.reloadData()
//    }
    @IBOutlet weak var textField: UITextField!
    
    
    var pastUrls = ["Men", "Women", "Cats", "Dogs", "Children"]
    var autocompleteUrls = [String]()
    
    @IBOutlet var autocompleteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
        textField.delegate = self
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        autocompleteTableView.hidden = false
        let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        searchAutocompleteEntriesWithSubstring(substring)
        return true     // not sure about this - could be false
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autocompleteUrls.removeAll(keepCapacity: false)
        
        for curString in pastUrls
        {
            let myString:NSString! = curString as NSString
            
            let substringRange :NSRange! = myString.rangeOfString(substring)
            
            if (substringRange.location  == 0)
            {
                autocompleteUrls.append(curString)
            }
        }
        
        autocompleteTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteUrls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
//        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(autoCompleteRowIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        let index = indexPath.row as Int
        
        cell.textLabel!.text = autocompleteUrls[index]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        textField.text = selectedCell.textLabel!.text        
    }
    
   }





