//
//  GooglePlacePickerViewController.swift
//  
//
//  Created by Flavio Lici on 8/11/15.
//
//

import UIKit

import MapKit
import CoreLocation

class GooglePlacePickerViewController: UIViewController {
    
    var latitudeToSearch: String!
    var longitudeToSearch: String!
    
    var locationToSearch: String!
    
    var idForGooglePlaces: String = ""
    
    var mapItem: MKMapItem!
    
    var nameOfVenue: String!
    
    var vicinity: String!
    
    var locationManager: CLLocationManager?
    
    @IBOutlet var venueName: UILabel!
    
    @IBOutlet var venueVicinity: UILabel!
    
    
    
    @IBOutlet var myMap: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMap.showsUserLocation = true
        var userLocation = myMap.userLocation
        var locationAllowed = [CLLocationManager.locationServicesEnabled()]
        var address: String = locationToSearch
        
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {
            (placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.mapItem = MKMapItem(placemark: placemark as? MKPlacemark)
                self.mapItem.name = "Event Venue Display"
                self.myMap.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude), MKCoordinateSpanMake(0.400, 0.400)), animated: false)
                self.latitudeToSearch = String(stringInterpolationSegment: placemark.location.coordinate.latitude)
                self.longitudeToSearch = String(stringInterpolationSegment: placemark.location.coordinate.longitude)
                
                func locationManager(_manager: CLLocationManager!, didFailWithError: NSError!) {
                    
                    if error != nil {
                        self.displayAlert("Location Settings Disabled", message: "Please enable to see your current location")
                    } else {
                        let currentLocation = MKPointAnnotation()
                        currentLocation.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                        currentLocation.title = "Current Location"
                        self.myMap.addAnnotation(currentLocation)
                    }
                    
                }
                
                var selfCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
                var locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude)
                let loc = CLLocation(latitude: placemark.location.coordinate.latitude, longitude: placemark.location.coordinate.longitude)
                let locSelf = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: placemark.location.coordinate.latitude, longitude: placemark.location.coordinate.longitude)
                
                urlLocation = "\(self.latitudeToSearch),\(self.longitudeToSearch)"
                
                let sharedInstance = RestApiManager.self
                
                RestApiManager.sharedInstance.getRandomUser {
                    
                    json in
                    
                    println(json)
                    
                }
                
                newAnnotation.title = self.nameOfVenue
                newAnnotation.subtitle = self.vicinity
                
                self.myMap.addAnnotation(newAnnotation)
                
            }
        })
        
        if nameOfVenue != nil {
            venueName.text = nameOfVenue
        } else {
            venueName.text = "Name Not Found"
        }
        
        if vicinity != nil {
            venueVicinity.text = vicinity
        } else {
            venueVicinity.text = "Vicinity Not Found"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
        
        return true
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func submitInfo(sender: UIButton) {
        
        performSegueWithIdentifier("venueChosen", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "venueChosen" {
            var svc = segue.destinationViewController as! eventSubmissionViewController
            if idForGooglePlaces != "" && nameOfVenue != nil{
                svc.placesId = idForGooglePlaces
                
                svc.venueNameToPost = nameOfVenue
            }
        }
    }

}
