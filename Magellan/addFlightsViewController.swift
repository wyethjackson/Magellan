//
//  addFlightsViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/5/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit

class addFlightsViewController: UIViewController {
    
       @IBInspectable var feedURL: String!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSURLRequest(URL: NSURL(string: "http://www.stackoverflow.com")!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            if error != nil {
                print("ERROR!!")
                print(error)
            }
            if let jsonData = data,
                feed = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)) as? NSDictionary {
//                title = feed.valueForKeyPath("feed.entry.im:name.label") as? String,
//                artist = feed.valueForKeyPath("feed.entry.im:artist.label") as? String {
                   
                    print(jsonData)
                     print(feed)
//                imageURLs = feed.valueForKeyPath("feed.entry.im:image") as? [NSDictionary] {
//                    if let imageURL = imageURLs.last,
//                        imageURLString = imageURL.valueForKeyPath("label") as? String {
//                            self.loadImageFromURL(NSURL(string:imageURLString)!)
//                    }
//                    self.titleLabel.text = title
//                    self.titleLabel.hidden = false
//                    self.artistLabel.text = artist
//                    self.artistLabel.hidden = false
//              var jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                    
            }
        }
//        print(feedParser)
//        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: "http://www.cleartrip.com/alerts/rss?from=DCAto=MSNwhen=201603")!)
        
//            RSSParser.parseFeedForRequest(request, callback: { (feed, error) -> Void in
//            NSLog("Feed for : \(feed.title)")
//            NSLog("contains : \(feed.items)")
//            })
//        

//        let feedParser = MWFeedParser(feedURL: URL);
//        feedParser.delegate = self
//        feedParser.parse()

        
    
      
        // Do any additional setup after loading the view.
    }
    
//    func loadImageFromURL(URL: NSURL) {
//        let request = NSURLRequest(URL: URL)
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
//            if let imageData = data {
////                self.imageView.image = UIImage(data: imageData)
//            }
//        }
//    }

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
