//
//  MyAnnotation.swift
//  Earthquake
//
//  Created by Humberto Morales on 3/11/15.
//  Copyright (c) 2015 Humberto Morales. All rights reserved.
//

import UIKit
import MapKit

func == (left: PinColor, right: PinColor) -> Bool{
    return left.rawValue == right.rawValue }

enum PinColor : String {
    case Red = "Red"
    case Green = "Green"
    case Blue = "Blue"
    
    func toPinColor() -> MKPinAnnotationColor{
        switch self{
    case .Red :
        return .Red
    case .Green :
        return .Green
    default:
        return .Red
        }
    }
}

class MyAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var title: String!
    var subtitle: String!
    var pinColor: PinColor!
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, pinColor: PinColor){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.pinColor = pinColor
        super.init()
    }
    
    convenience init(coordinate: CLLocationCoordinate2D, title: String,subtitle: String){
        self.init(coordinate: coordinate, title: title, subtitle: subtitle, pinColor: .Blue)
    }

}
