//
//  LocalFeedViewController.swift
//  
//
//  Created by Flavio Lici on 9/24/15.
//
//

import UIKit
import Parse
import CoreLocation
import MapKit

class LocalFeedViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var nextImage: UIImageView!
    
    @IBOutlet var currentImage: UIImageView!

    
  
    @IBOutlet var eventTypePic: UIButton!
    @IBOutlet var myLocationLabel: UILabel!
    
    var myLocation: String!
    var imagesArray: [UIImage]!
    
    var eventTypeNamesArray = [String]()
    
    var eventTypeImagesArray = [UIImage]()
    
    @IBOutlet var nameOfEventType: UILabel!
    
    var locationManager = CLLocationManager()
    
    @IBOutlet var provressView: UIProgressView!
    
    var arrayCounter: Int = 0
    
    var totalItems: Float!
    
    var timelineData: NSMutableArray! = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        println("Is working")
        
        
        
  

        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        currentImage.addGestureRecognizer(gesture)
        
        currentImage.userInteractionEnabled = true
        println("isworking 2")
        
        

        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation: CLLocation = locations[0] as! CLLocation
        
        println("searching for location")
        var latitude = userLocation.coordinate.latitude
        
        var longitude = userLocation.coordinate.longitude
        
        var latDelta: CLLocationDegrees = 0.01
        var lonDelta: CLLocationDegrees = 0.01
        
        var course = userLocation.course
        
        var speed = userLocation.speed
        
        
        
        var altitude = userLocation.altitude
        
        
        
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        
        var geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation, completionHandler:  {
            placemarks, error in
            
            if error == nil && placemarks.count > 0 {
                var placemark = (placemarks.last as? CLPlacemark)!
                
                self.myLocation = placemark.locality
                self.myLocationLabel.text = self.myLocation
                
                self.locationManager.stopUpdatingLocation()
                
                
                if !self.myLocationLabel.text!.isEmpty {
                    println("Got Location")
                    self.loadData()
                }
            }
        })
        
        println(myLocation)
        
    
        
    }
    
    func loadData() {
        timelineData.removeAllObjects()
        
        var findTimelineData = PFQuery(className: "NewSocialFeed")
        println(self.myLocationLabel.text)
        findTimelineData.whereKey("Location", equalTo: myLocationLabel.text!)
        
        findTimelineData.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    self.timelineData.addObject(object)
                }
                println(self.timelineData)
                    let array: NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                    self.timelineData = array.mutableCopy() as? NSMutableArray
                
                if self.timelineData.count > 0 {
                    println("isWorking 3")
                    for object in self.timelineData {
                        if object.objectForKey("imageFile") != nil {
                                println("working 4")
                           
                            object.objectForKey("imageFile")?.getDataInBackgroundWithBlock({
                                (data: NSData?, error: NSError?) -> Void in
                                println("about to append")
                                if error == nil {
                                    let downloadedImage = UIImage(data: data!)
                                    self.imagesArray.append(downloadedImage!)
                                    println("Appended")
                                } else {
                                    println("\(error)")
                                    println("not working!!!!!")
                                }
                            })
                        }
                        
                        if object.objectForKey("eventTypeImage") != nil {
                            println("working 5")
                            object.objectForKey("eventTypeImage")!.getDataInBackgroundWithBlock({
                                (data: NSData?, error: NSError?) -> Void in
                                
                                if error == nil {
                                    let downloadedImage = UIImage(data: data!)
                                    self.eventTypeImagesArray.append(downloadedImage!)
                                }
                            })
                        }
                        
                        if object.objectForKey("eventType") != nil {
                            var eventType = object.objectForKey("eventType") as? String
                            self.eventTypeNamesArray.append(eventType!)
                        }
                    }
                    
                    self.currentImage.image = self.imagesArray[0] as UIImage
                    self.currentImage.contentMode = UIViewContentMode.ScaleAspectFill
                    self.nextImage.contentMode = UIViewContentMode.ScaleAspectFill
                    self.nextImage.image = self.imagesArray[1] as UIImage
                    self.eventTypePic.setImage(self.eventTypeImagesArray[0], forState: .Normal)
                    self.nameOfEventType.text = self.eventTypeNamesArray[0] as String
                    
                    self.arrayCounter += 1
                }

            }
        })
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected != "" {
                if acceptedOrRejected == "accepted" {
                    swipeRight()
                } else {
                    swipeLeft()
                }
                
                
            }
            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            
            
        }
        
        
        
    }
    
    func swipeRight() {
        var photoObject = self.timelineData.objectAtIndex(arrayCounter) as! PFObject
        var points = photoObject.objectForKey("Points") as! Int
        
        photoObject.setObject(points + 1, forKey: "Points")
        photoObject.saveInBackground()
        
        arrayCounter++
        
        arrayCounter++
        
        totalItems = Float(imagesArray.count)
        
        var newFraction = Float(arrayCounter) / totalItems
        
        dispatch_async(dispatch_get_main_queue()) {
            self.provressView.setProgress(Float(newFraction), animated: true)
        }
        
        
        currentImage.image = imagesArray[arrayCounter] as UIImage
        nextImage.image = imagesArray[arrayCounter + 1] as UIImage
        eventTypePic.setImage(eventTypeImagesArray[arrayCounter], forState: .Normal)
        nameOfEventType.text = eventTypeNamesArray[arrayCounter] as String
        
        
    }
    
    func swipeLeft() {
        var photoObject = self.timelineData.objectAtIndex(arrayCounter) as! PFObject
        
        if photoObject.objectForKey("leftSwipes") != nil {
            photoObject.addObject("1", forKey: "leftSwipes")
        } else {
            photoObject.setObject(["1"], forKey: "leftSwipes")
        }
        
        if photoObject.objectForKey("leftSwipes")?.count > 5 {
            photoObject.deleteInBackground()
        }
        
        arrayCounter++
        
        totalItems = Float(imagesArray.count)
        
        var newFraction = Float(arrayCounter) / totalItems
        
        dispatch_async(dispatch_get_main_queue()) {
            self.provressView.setProgress(Float(newFraction), animated: true)
        }
        
        
        
        currentImage.image = imagesArray[arrayCounter] as UIImage
        nextImage.image = imagesArray[arrayCounter + 1] as UIImage
        eventTypePic.setImage(eventTypeImagesArray[arrayCounter], forState: .Normal)
        nameOfEventType.text = eventTypeNamesArray[arrayCounter] as String
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGlobalEventType" {
            var svc = segue.destinationViewController as! GlobalEventTypeTableViewController
            svc.eventType = eventTypeNamesArray[arrayCounter]
        }
    }
}
