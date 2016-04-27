//
//  tripPhotosCollectionViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/12/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse

class tripPhotosCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var tripId = String()
    var myImage = UIImage(named: "sail-boat-pic.jpg")
    var defaultImages = [UIImage(named: "sail-boat-pic.jpg"), UIImage(named: "eiffel_tower_pic_from_bog.jpg"), UIImage(named: "bridge_fog.jpg"), UIImage(named: "statue-of-liberty.jpg") ]
    var photos = [UIImage]()
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 1
        // Return the number of sections
        return 1
    }
    

    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 2
        // Return the number of items in the section
        if photos.count > 0 {
            return photos.count
        } else {
            return defaultImages.count
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 3
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        
        // Configure the cell
        
        if photos.count > 0 {
            
            cell.imageView.image = photos[indexPath.row]
        } else {
            
            cell.imageView.image = defaultImages[indexPath.row]
        }
        
        return cell
    }
    
    
    @IBAction func addPhoto(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        photos.append(image)
        
        var photoQuery = PFQuery(className: "Trips")
        photoQuery.getObjectInBackgroundWithId(tripId) {
            (trip: PFObject?, error: NSError?) -> Void in
            
            if error != nil {
                print(error)
            } else if let trip = trip {
                trip["photos"] = image
                trip.saveInBackground()
            }
        }
        collectionView?.reloadData()
//        var query
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tripId = Manager.tripId
       
        
        var tripQuery = PFQuery(className: "Trips")
        
        var userTrip = tripQuery.whereKey("objectId", equalTo: self.tripId)
        
        userTrip.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let trip = objects {
                for object in trip {
                    if object["photos"] is NSArray {
                        for var index = 0; index < object["photos"].count; index++ {
                            self.photos.append(object["photos"][index] as! UIImage)
                        }
                    }
                }
            }
        }
        collectionView?.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tripId = Manager.tripId
        
        var tripQuery = PFQuery(className: "Trips")
        
        var userTrip = tripQuery.whereKey("objectId", equalTo: self.tripId)
        
        userTrip.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let trip = objects {
                for object in trip {
                    if object["photos"] is NSArray {
                        for var index = 0; index < object["photos"].count; index++ {
                        self.photos.append(object["photos"][index] as! UIImage)
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
