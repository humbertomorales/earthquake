//
//  DetailEQTableViewController.swift
//  Earthquake
//
//  Created by Humberto Morales on 3/11/15.
//  Copyright (c) 2015 Humberto Morales. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class DetailEQTableViewController: UITableViewController, MKMapViewDelegate {

    @IBOutlet weak var labelMag: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var eq :Earthquake!
    var color : UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.delegate=self
        
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        
        self.labelMag.text = "Magnitud: "+eq.magnitude.description
        self.labelDate.text = "Date: "+eq.time
        self.labelLocation.text = "Place: "+eq.place
        
        let location = CLLocationCoordinate2D(
            latitude: eq.point.lat,
            longitude: eq.point.long
        )
        
        setCenterOfMapToLocation(location)
        
        addPinToMapView(location,color: color)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    func setCenterOfMapToLocation(location: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    func addPinToMapView(location: CLLocationCoordinate2D, color: UIColor){
        var annotation = MyAnnotation(coordinate: location, title: "Magnitud:"+eq.magnitude.description, subtitle: "")
        self.map.addAnnotation(annotation)
        setCenterOfMapToLocation(location)
    }
    
    
    func mapView(mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!{
        
        if annotation is MyAnnotation == false{
            return nil
        }
        
        let senderAnnotation = annotation as MyAnnotation
        let pinReusableIdentifier = senderAnnotation.pinColor.rawValue
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(
            pinReusableIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: senderAnnotation,
                reuseIdentifier: pinReusableIdentifier)
            annotationView!.canShowCallout = true
        }
        
        if senderAnnotation.pinColor == .Blue{
            let pinImage = UIImage(named:"BluePin")
            annotationView!.image = pinImage
        } else {
            annotationView!.pinColor = senderAnnotation.pinColor.toPinColor()
        }
        
        return annotationView
    }
}
