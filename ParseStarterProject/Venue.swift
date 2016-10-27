//
//  Venue.swift
//  Harbr
//
//  Created by Flavio Lici on 8/11/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import CoreLocation

class Venue: NSObject {
    
    let name:String!
    let location:CLLocation!
    let distanceFromUser:CLLocationDistance!
    
    init(name: String, location: CLLocation, distanceFromUser: Double) {
        self.name = name
        self.location = location
        self.distanceFromUser = distanceFromUser
    }
}