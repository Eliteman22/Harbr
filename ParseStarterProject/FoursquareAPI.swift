//
//  FoursquareAPI.swift
//  FoursquareVenues
//
//  Created by XD on 6/13/14.
//  Copyright (c) 2014 XD. All rights reserved.
//

import Foundation
import CoreLocation

protocol FoursquareAPIProtocol {
    func didRecieveVenues(results:[Venue])
}

var userQuery = ""

class FoursquareAPI: NSObject {
    
    let clientId = "2MI4MCT5SPQJBCYFDGX2NGPYLI5RCBSLB2LBVOOOXSUI00GQ"
    let clientSecret = "42MRCVIV0FJJPICEAGHSZMFWZ3MSXDIVT5SRUPWA5E5MPOQM"
    let version = "20140613"
    
    let radiusInMeters = 10000
    let categoryId = "4bf58dd8d48988d1e0931735"
    
    let data = NSMutableData()
    var delegate: FoursquareAPIProtocol?
    
    
    
    func searchForCofeeShopsAtLocation(userLocation: CLLocation) {
        let urlPath = "https://api.foursquare.com/v2/venues/search?ll=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&categoryId=\(categoryId)&radius=\(radiusInMeters)&client_id=\(clientId)&query=\(userQuery)&client_secret=\(clientSecret)&v=\(version)"
        let url = NSURL(string: urlPath)
        let request = NSURLRequest(URL: url!)
        
        let session: NSURLSession = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            let strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            let json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as! NSDictionary
            
            if((err) != nil) {
                println(err!.localizedDescription)
            }
            else {
                var venues = [Venue]()
                
                if json.count>0 {
                    let response: NSDictionary = json["response"] as! NSDictionary
                    let allVenues: [NSDictionary] = response["venues"] as! [NSDictionary]

                    for venue:NSDictionary in allVenues {
                        var venueName:String = venue["name"] as! String
                        
                        var location:NSDictionary = venue["location"] as! NSDictionary
                        var venueLocation:CLLocation = CLLocation(latitude: location["lat"] as! Double, longitude: location["lng"] as! Double)
                        
                        venues.append(Venue(name: venueName, location: venueLocation, distanceFromUser: venueLocation.distanceFromLocation(userLocation)))
                    }
                }
                
                self.delegate?.didRecieveVenues(venues)
            }
        })
        
        task.resume()
    }
}