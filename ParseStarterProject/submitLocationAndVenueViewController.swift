//
//  submitLocationAndVenueViewController.swift
//  
//
//  Created by Flavio Lici on 8/23/15.
//
//

import UIKit
import MapKit
import CoreLocation

class submitLocationAndVenueViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, MKMapViewDelegate {
    
    @IBOutlet var eventLocation: UITextField!
    
    @IBOutlet var eventVenue: UITextField!
    
    
    var eventName: String!
    
    var eventType: String!
    
    var eventDescription: String!
    
    var eventDate: String!
    
    var eventTime: String!
    
    var eventImage: UIImage!
    
    @IBOutlet var border1: UILabel!
    
    @IBOutlet var border2: UILabel!
    
    var locationToSend: String!
    
    var venueToSend: String!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet var myMap: MKMapView!
    
    @IBOutlet var showMapButton: UIButton!
    
    var mapItem: MKMapItem!
    
    var userLocationFromLocationManager: CLLocation!
    
    var eventLat: Double!
    
    var eventLon: Double!
    
    
    @IBOutlet var orangeOutlet: UIButton!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        println("Did Open")
        border1.alpha = 0
        border2.alpha = 0
        eventLocation.delegate = self
        eventVenue.delegate = self
        myMap.alpha = 0
        locationManager.delegate = self
        showMapButton.clipsToBounds = true
        showMapButton.layer.cornerRadius = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() == .Restricted {
            orangeOutlet.alpha = 0
        }
        
        println("Did finish loading")

       
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation: CLLocation = locations[0] as! CLLocation
        
        userLocationFromLocationManager = userLocation
        
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        
        var latDelta: CLLocationDegrees = 0.01
        var lonDelta: CLLocationDegrees = 0.01
        
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    
    @IBAction func showOnMap(sender: UIButton) {
        if !eventLocation.text.isEmpty {
            showMapButton.alpha = 0
            border1.alpha = 0.35
            border2.alpha = 0.35
            
            
            
            myMap.showsUserLocation = true
            var userLocation = myMap.userLocation
            var locationAllowed = [CLLocationManager.locationServicesEnabled()]
            var address: String!
            
            if eventLocation.text == "  Current Location" {
                address = locationToSend
            } else {
                address = eventLocation.text
            }
            var nameOfEvent: String = eventName
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: {
                (placemarks: [AnyObject]!, error: NSError!) -> Void in
                
                if let placemark = placemarks?[0] as? CLPlacemark {
                    self.mapItem = MKMapItem(placemark: placemark as? MKPlacemark)
                    self.mapItem.name = "\(self.eventLocation)"
                    self.myMap.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude), MKCoordinateSpanMake(0.400, 0.400)), animated: true)
                    func locationManager(_manager: CLLocationManager!, didFailWithError: NSError!) {
                        if error != nil {
                            self.displayAlert("Location Settings Disabled", message: "Please enable location settings to see current location")
                            
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
                    newAnnotation.title = "\(nameOfEvent)"
                    newAnnotation.subtitle = "\(address)"
                    
                    
                    
                    self.myMap.addAnnotation(newAnnotation)
                    
                }
            })

            UIView.animateWithDuration(0.8, animations: {
                self.myMap.alpha = 1
            })
            
            
        } else {
            displayAlert("Error", message: "Please enter an event location")
        }
    }

    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func userCurrentLocation(sender: UIButton) {
        
        var userLocation: CLLocation = userLocationFromLocationManager
        eventLat = userLocation.coordinate.latitude as Double
        eventLon = userLocation.coordinate.longitude as Double
        
        var geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation, completionHandler: {
            (placemarks, errors) in
            
            if errors == nil && placemarks.count > 0 {
                var placemark: CLPlacemark = (placemarks.last as? CLPlacemark)!
                self.eventLat = placemark.location.coordinate.latitude
                self.eventLon = placemark.location.coordinate.longitude
                self.locationToSend = ("\(placemark.subThoroughfare), \(placemark.thoroughfare), \(placemark.locality)")
                
                self.eventLocation.text = "  Current Location"
                self.eventLocation.textColor = self.UIColorFromRGB("ffaa57", alpha: 1)
            } else {
                println("There was an error")
            }
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "finalFuckingSegue" {
            var svc = segue.destinationViewController as! uploadEventToSocialsViewController
            
            svc.eventName = eventName
            svc.eventDescription = eventDescription
            svc.eventType = eventType
            svc.eventImage = eventImage
            svc.eventTime = eventTime
            svc.eventLocation = locationToSend
            svc.eventDate = eventDate
            
            if eventLat != nil {
                svc.eventLat = eventLat
            }
            
            if eventLon != nil {
               svc.eventLon = eventLon
            }
            
            
            
            if venueToSend != nil {
                svc.eventVenue = venueToSend
            }
            
            
        }
    }
    
    @IBAction func goToFinalSegue(sender: UIButton) {
        if eventLocation.text != "  Current Location" {
            locationToSend = eventLocation.text
            
            var address = eventLocation.text
            
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: {
                (placemarks, errors) in
                
                if errors == nil && placemarks.count > 0 {
                    var placemark: CLPlacemark = (placemarks.last as? CLPlacemark)!
                    self.locationToSend = "\(placemark.subThoroughfare) \(placemark.thoroughfare), \(placemark.locality), \(placemark.postalCode)"
                    println("Should work")
                    self.eventLon = placemark.location.coordinate.longitude
                    self.eventLat = placemark.location.coordinate.latitude
                    println("eventLon: \(self.eventLon)")
                    println("eventLat: \(self.eventLat)")
                    
                    if !self.eventVenue.text.isEmpty {
                        self.venueToSend = self.eventVenue.text
                    }
                    
                    self.performSegueWithIdentifier("finalFuckingSegue", sender: self)
                    
                    
                    
                } else {
                    println("There was an error")
                }
            })
            
            
        } else {
            if !self.eventVenue.text.isEmpty {
                self.venueToSend = self.eventVenue.text
                self.performSegueWithIdentifier("finalFuckingSegue", sender: self)
            }
        }
        
        
        
        
        
    }
    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        var scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    

}
