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
                }
            }
        })
        loadDataTask.resume()
    }
    
    class func getEarthquakesFromFileWithSuccess(success: ((data: NSData) -> Void)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let filePath = NSBundle.mainBundle().pathForResource("cacheFile",ofType:"json")
            
            var readError:NSError?
            if let data = NSData(contentsOfFile:filePath!,
                options: NSDataReadingOptions.DataReadingUncached,
                error:&readError) {
                    success(data: data)
            }
        })
    }
}
