//
//  businessCategoriesSpecificShowViewController.swift
//  Magellan
//
//  Created by Wyeth Jackson on 2/2/16.
//  Copyright © 2016 Wyeth Jackson. All rights reserved.
//

import UIKit
import Parse
//import RealmSwift

class businessCategoriesSpecificShowViewController: UITableViewController {
    var businessCategoriesSelected = [String]()
    var businessCategory = String()
    var businessSpecificCategories = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.businessCategoriesSelected = Manager.businessCategoriesSelected
        self.businessCategory = Manager.dataToPass
        
        switch self.businessCategory {
            case "Restaurants":
                self.businessSpecificCategories = ["Restaurants (General)","Afghan","African","American","Arabian","Argentine","Armenian","Asian Fusion","Australian","Austrian","Bangladeshi","Barbecue","Basque","Belgian","Brasseries","Brazilian","Breakfast & Brunch","British","Buffets","Burgers","Burmese","Cafes","Cafeteria","Cajun/Creole","Cambodian","Caribbean","Catalan","Cheesesteaks","Chicken Shop","Chicken Wings","Chinese","Comfort Food","Creperies","Cuban","Czech","Delis","Diners","Ethiopian","Fast Food","Filipino","Fish & Chips","Fondue","Food Court","Food Stands","French","Gastropubs","German","Gluten-Free","Greek","Halal","Hawaiian","Himalayan/Nepalese","Hot Dogs","Hot Pot","Hungarian","Iberian","Indian","Indonesian","Irish","Italian","Japanese","Korean","Kosher","Laotian","Latin American","Live/Raw Food","Malaysian","Mediterranean","Mexican","Middle Eastern","Modern European","Mongolian","Moroccan","Pakistani","Persian/Iranian","Peruvian","Pizza","Polish","Portuguese","Poutineries","Russian","Salad","Sandwiches","Scandinavian","Scottish","Seafood","Singaporean","Slovakian","Soul Food","Soup","Southern","Spanish","Sri Lankan","Steakhouses","Supper Clubs","Sushi Bars","Taiwanese","Tapas Bars","Tapas/Small Plates","Tex-Mex","Thai","Turkish","Ukrainian","Uzbek","Vegan","Vegetarian","Vietnamese"]
            case "Nightlife":
                self.businessSpecificCategories = ["Nightlife (General)","Adult Entertainment","Bars","Beer Gardens","Comedy Clubs","Country Dance Halls","Dance Clubs","Jazz and Blues","Karaoke","Music Venues","Piano Bars","Pool Halls"]
            case "Shopping":
                self.businessSpecificCategories = ["Shopping (General)","Fashion","Flea Markets","Jewelry","Outlet Stores","Personal Shopping","Shopping Centers","Souvenir Shops","Thrift Stores","Tobacco Shops"]
            case "Food":
                self.businessSpecificCategories = ["Food (General)","Bagels","Bakeries","Beer","Breweries","Bubble Tea","Butcher","CSA","Coffee & Tea","Convenience Stores","Cupcakes","Desserts","Distilleries","Do-It-Yourself Food","Donuts","Ethnic Grocery","Farmers Market","Food Delivery Services","Food Trucks","Gelato","Grocery","Ice Cream & Frozen Yogurt","Internet Cafes","Juice Bars & Smoothies","Organic Stores","Pretzels","Shaved Ice","Specialty Food","Street Vendors","Tea Rooms","Wineries"]
            case "Beauty & Spas":
                self.businessSpecificCategories = ["Beauty and Spas (General)","Day Spas","Hair Salons"," Wine","Tattoo","Massage"]
            case "Arts & Entertainment":
                self.businessSpecificCategories = ["Arts and Entertainment (General)", "Amusement Parks", "Arcades","Art Galleries"," & Spirits","Botanical Gardens","Cabaret","Casinos","Cinema","Country Clubs","Cultural Center","Festivals","Jazz & Blues","LAN Centers","Museums","Music Venues","Observatories","Opera and Ballet","Paint and Sip","Performing Arts","Planetarium","Professional Sports Teams","Psychics & Astrologers","Race Tracks","Social Clubs","Stadiums & Arenas","Ticket Sales","Wineries"]
            case "Active Vacation":
                self.businessSpecificCategories = ["Active Vacation (General)","ATV Rentals/Tours","Amateur Sports Teams","Aquariums","Archery","Badminton","Basketball Courts","Batting Cages","Beaches","Bike Rentals","Boating","Bowling","Campgrounds","Challenge Courses","Climbing","Cycling Classes","Day Camps","Disc Golf","Diving","Fencing Clubs","Fishing","Fitness & Instruction","Flyboarding","Go Karts","Golf","Gun/Rifle Ranges","Gymnastics","Hang Gliding","Hiking","Horseback Riding","Hot Air Balloons","Jet Skis","Kids Activities","Kiteboarding","Lakes","Laser Tag","Leisure Centers","Mini Golf","Mountain Biking","Paddle boarding","Paintball","Parks","Playgrounds","Piercing", "Races & Competitions","Rafting/Kayaking","Recreation Centers","Rock Climbing","Skating Rinks","Skydiving","Sledding","Soccer","Sports Clubs","Squash","Summer Camps","Surfing","Swimming Pools","Tennis","Trampoline Parks","Tubing","Wildlife Hunting Ranges","Zoos"]
            case "Hotels & Travel":
                self.businessSpecificCategories = ["Hotels and Travel (General)","Airports","Bed & Breakfast","Bingo Halls","Car Rental","Guest Houses","Health Retreats","Hostels","Hotels","Motorcycle Rental","RV Parks","RV Rental","Resorts","Ski Resorts", "Tours","Train Stations","Transportation","Travel Services","Vacation Rental Agents","Vacation Rentals"]
            default:
                self.businessSpecificCategories = []
            
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessSpecificCategories.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("businessSpecificCategoryCell", forIndexPath: indexPath) as UITableViewCell?
        
        
        cell!.textLabel?.text = self.businessSpecificCategories[indexPath.row]
        
//        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        return cell!
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            self.businessCategoriesSelected.append(businessSpecificCategories[indexPath.row])
        
            Manager.businessCategoriesSelected = businessCategoriesSelected
            self.performSegueWithIdentifier("businessSpecificCategoryUnwind", sender: self)
            
    
    }

}
