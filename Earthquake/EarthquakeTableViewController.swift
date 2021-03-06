//
//  EarthquakeTableViewController.swift
//  Earthquake
//
//  Created by Humberto Morales on 3/11/15.
//  Copyright (c) 2015 Humberto Morales. All rights reserved.
//

import UIKit
import Foundation


class EarthquakeTableViewController: UITableViewController {
    
    var data = [Earthquake]()
    
    let reachability = Reachability.reachabilityForInternetConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "onRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.refreshControl?.beginRefreshing()
        self.onRefresh(self.refreshControl)
        
        reachability.startNotifier()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return data.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as EQTableViewCell
        
        // Configure the cell...
        
        let eartqPin : Earthquake = self.data[indexPath.row] as Earthquake

        cell.labelMag?.text = eartqPin.magnitude.description
        cell.labelPlace?.text = "Place: "+eartqPin.place
        cell.labelTime?.text = eartqPin.time
        
        let color : Double = eartqPin.magnitude
        weak var textColor = UIColor ()
        
        switch color {
        case 0.1...0.9:
            textColor = UIColor.greenColor()
        case 9.1...9.9:
            textColor = UIColor.redColor()
        default:
            textColor = UIColor.blackColor()
        }
        
        cell.labelMag.textColor = textColor
        cell.labelPlace.textColor = textColor

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sb = self.storyboard?.instantiateViewControllerWithIdentifier("DetailView") as DetailEQTableViewController;
        sb.eq = self.data[indexPath.row]
        sb.color = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.textColor
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    // MARK: - Call DataManager
    
    func getEarthquakes(){
        
        DataManager.getEartquakes{ (EartquakesData) -> Void in
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(EartquakesData, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            
            if(err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            if let results: NSArray = jsonResult["features"] as? NSArray{
                if results.count != 0 {
                    for var i : Int = 0; i < results.count; ++i{
                        if let earthq : NSDictionary = results[i] as? NSDictionary {
                            if let geometry : NSDictionary = earthq["geometry"] as? NSDictionary{
                                let point : NSArray = geometry["coordinates"] as NSArray
                                let objectGeo = Geometry(lat: point[1] as Double, long: point[0] as Double)
                                
                                if let properties : NSDictionary = earthq["properties"] as? NSDictionary{
                                    let mag : Double = properties["mag"] as Double
                                    let place : String = properties["place"] as String
                                    let timeMili : String = self.getDate(properties["time"] as NSTimeInterval) as String
                                    let eq : Earthquake = Earthquake(magnitude: mag, place: place, time:timeMili,point: objectGeo,color: "")
                                    self.data.append(eq)
                                }
                            }
                        }
                    }
                }else{
                    println("There is no earthquakes, thanks god!")
                    
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        }
        
    }
    
    
    func onRefresh(sender: UIRefreshControl!) {
        if self.data.count != 0 {
            self.data.removeAll(keepCapacity: false)
        }
        if reachability.isReachable(){
            getEarthquakes()
        }else{
            getEarthQuakesFromFile()
            println("You are working with no internet")
        }
    }
    
    func getDate(time : NSTimeInterval) -> String{
        let date : NSDate = NSDate(timeIntervalSince1970:time/1000)
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        formatter.timeStyle = .ShortStyle
        return formatter.stringFromDate(date)
    }
    
    func getEarthQuakesFromFile(){
        DataManager.getEarthquakesFromFileWithSuccess{(EartquakesData) -> Void in
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(EartquakesData, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            
            if(err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            if let results: NSArray = jsonResult["features"] as? NSArray{
                if results.count != 0 {
                    for var i : Int = 0; i < results.count; ++i{
                        if let earthq : NSDictionary = results[i] as? NSDictionary {
                            if let geometry : NSDictionary = earthq["geometry"] as? NSDictionary{
                                let point : NSArray = geometry["coordinates"] as NSArray
                                let objectGeo = Geometry(lat: point[1] as Double, long: point[0] as Double)
                                
                                if let properties : NSDictionary = earthq["properties"] as? NSDictionary{
                                    let mag : Double = properties["mag"] as Double
                                    let place : String = properties["place"] as String
                                    let timeMili : String = self.getDate(properties["time"] as NSTimeInterval) as String
                                    let eq : Earthquake = Earthquake(magnitude: mag, place: place, time:timeMili,point: objectGeo,color: "")
                                    self.data.append(eq)
                                }
                            }
                        }
                    }
                }else{
                    println("There is no earthquakes, thanks god!")
                    
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        }
    }
}
