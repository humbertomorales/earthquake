//
//  DataManager.swift
//  Earthquake
//
//  Created by Humberto Morales on 3/11/15.
//  Copyright (c) 2015 Humberto Morales. All rights reserved.
//

import Foundation

struct Earthquake {
    let magnitude : Double
    let place : String
    let time : String
    let point : Geometry
    let color : String
}

struct Geometry {
    let lat : Double
    let long : Double
}

let urlPath = "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson"

class DataManager {

    class func getEartquakes(success: ((EartquakesData : NSData!) -> Void)){
        loadDataFromURL(NSURL(string: urlPath)!,completion:{(data, error) -> Void in
            if let urlData = data {
                success(EartquakesData: urlData)
            }
        })
    }
    
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            }else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.humberto", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data:nil, error: statusError)
                }else{
                    completion(data:data, error: nil)
                    dispatch_async(dispatch_get_main_queue(), {
                        if self.writeToFile(data) {
                            println("wrote to file")
                        }
                    })
                }
            }
        })
        loadDataTask.resume()
    }
    
    class func getEarthquakesFromFileWithSuccess(success: ((data: NSData) -> Void)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let filePath = NSTemporaryDirectory() + "cacheFile.json"
            
            var readError:NSError?
            if let data = NSData(contentsOfFile:filePath,
                options: NSDataReadingOptions.DataReadingUncached,
                error:&readError) {
                    success(data: data)
            }
        })
    }
    
    class func writeToFile(data : NSData)-> Bool{
        var error:NSError?
        let path = NSTemporaryDirectory() + "cacheFile.json"
        
        let succeeded = data.writeToFile(path, atomically: true)
        
        if (succeeded){
            let readString = NSString(contentsOfFile: path,
            encoding: NSUTF8StringEncoding, error: nil) as String
//            println("The file contains: \(readString)")
            return true
        } else {
            if let theError = error{
                println("Could not write. Error = \(theError)")
            }
            return false
        }
    }
}
