//
//  MoreInfoViewController.swift
//  
//
//  Created by Flavio Lici on 7/2/15.
//
//

import UIKit
import MapKit
import CoreLocation
import Parse
import Foundation
import MessageUI



class MoreInfoViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var myMap: MKMapView!
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var commentFIeld: UITextField!
    
    @IBOutlet var rsvpList: UILabel!
    
    @IBOutlet var peopleAttending: UILabel!
    
    var eventTypeToCheck: String!
    
    @IBOutlet var eventOwnerPicture: UIImageView!
    
    @IBOutlet var myScrollView: UIScrollView!
    
    var eventOwner: String!
    
    var mapItem: MKMapItem!
    
    
    var count: Int = Int()
    
    var locationManager: CLLocationManager?
    
    var listOfRsvpd: [String]!
    
    @IBOutlet var dayOfEvent: UILabel!
    
    
    @IBOutlet var Time: UILabel!
    
    
    @IBOutlet var backgroundImage: UIImageView!
    

    
    
    @IBOutlet var eventType: UILabel!
    
    var usedUsers = [String]()
    
    var numUsedUsers: Int = 1
    
   
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func goBack()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet var host: UILabel!
    
    
    var eventName: String!
    var eventLocation: String!
    var objectId: String!
    
    @IBOutlet var eventDescription: UILabel!
    
    

    
    @IBOutlet var imageOfEvent: UIImageView!
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    

    override func viewDidLoad() {
       
        imageOfEvent.clipsToBounds = true
        
        self.navigationItem.title = "\(eventName)"
      
        super.viewDidLoad()
        

        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "FLW Script", size: 30)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        var pickChosen: String!
        
        myScrollView.contentSize.height = 1269
        myScrollView.contentSize.width = view.frame.width
        
//        guest1.contentMode = UIViewContentMode.ScaleAspectFill
//        guest1.clipsToBounds = true
//        guest1.layer.cornerRadius = guest1.frame.height/2
//        guest2.contentMode = UIViewContentMode.ScaleAspectFill
//        guest2.clipsToBounds = true
//        guest2.layer.cornerRadius = guest1.frame.height/2
//        guest3.contentMode = UIViewContentMode.ScaleAspectFill
//        guest3.clipsToBounds = true
//        guest3.layer.cornerRadius = guest1.frame.height/2
//        guest4.contentMode = UIViewContentMode.ScaleAspectFill
//        guest4.clipsToBounds = true
//        guest4.layer.cornerRadius = guest1.frame.height/2
        
        
        let query = PFQuery(className: "eventPosts")
        query.whereKey("objectId", equalTo: objectId)
        
        query.findObjectsInBackgroundWithBlock({
            (objects, error) -> Void in
            
            
            if error == nil {
                for object in objects! {
                    self.eventDescription.text = object.objectForKey("description") as? String
                    
                    if object.objectForKey("eventTime") != nil {
                        self.Time.text = object.objectForKey("eventTime") as? String
                    } else {
                        self.Time.text = "Unknown"
                    }
                

                    if object.objectForKey("date") != nil {
                        var eventDay = object.objectForKey("date") as? String
                        self.dayOfEvent.text = "  \(eventDay!)"
                    } else {
                        self.dayOfEvent.text = ""
                    }
                    
                    if object.objectForKey("rsvpList") != nil {
                        var rsvpList = object.objectForKey("rsvpList") as! [String]
                        self.listOfRsvpd = rsvpList
                        var userCount = rsvpList.count
                        self.peopleAttending.text = "\(userCount) People Attending"
                    } else {
                        self.peopleAttending.text = "0 People Attending"
                        self.listOfRsvpd = []
                    }
                    
                    if object.objectForKey("eventType") != nil {
                        self.eventType.text = object.objectForKey("eventType") as? String
                        self.eventTypeToCheck = object.objectForKey("eventType") as? String
                    
                    } else {
                        self.eventType.text = "#Ain't Got No Type"
                        self.eventTypeToCheck = "#Ain't Got No Type"
                    }
                    
                    if let downloadedImage: UIImage = UIImage(data: (object.objectForKey("imageFIle")?.getData()!)!) {
                        self.imageOfEvent.image = downloadedImage as UIImage
                        self.imageOfEvent.contentMode = UIViewContentMode.ScaleAspectFill
                        
                    } else {
                        self.imageOfEvent.image = UIImage(named: "placeholder.jpg")
                    }
                    
                    if self.eventTypeToCheck == "#Bar" {
                        self.backgroundImage.image = UIImage(named: "bar.png")
                    } else if self.eventTypeToCheck == "#Party" {
                        self.backgroundImage.image = UIImage(named: "party.png")
                    } else if self.eventTypeToCheck == "#School" {
                        self.backgroundImage.image = UIImage(named: "school.png")
                    } else if self.eventTypeToCheck == "#Club" {
                        self.backgroundImage.image = UIImage(named: "club.png")
                    } else if self.eventTypeToCheck == "#Sports" {
                        self.backgroundImage.image = UIImage(named: "sports.png")
                    } else if self.eventTypeToCheck == "#Educational" {
                        self.backgroundImage.image = UIImage(named: "educational.png")
                    } else if self.eventTypeToCheck == "#Movement" {
                        self.backgroundImage.image = UIImage(named: "movement.png")
                    } else if self.eventTypeToCheck == "#Awareness" {
                        self.backgroundImage.image = UIImage(named: "awareness.png")
                    } else if self.eventTypeToCheck == "#Recreational" {
                        self.backgroundImage.image = UIImage(named: "recreational.png")
                    } else if self.eventTypeToCheck == "Hackathon" {
                        self.backgroundImage.image = UIImage(named: "hackathon.png")
                    } else if self.eventTypeToCheck == "#Orgy" {
                        self.backgroundImage.image = UIImage(named: "orgy.png")
                    } else {
                        self.backgroundImage.image = UIImage(named: "other.png")
                    }
                    
                }
            }
            
            
        })
        
        
//    if listOfRsvpd.count == 0 {
//        
//        guest1.alpha = 0
//        guest1.userInteractionEnabled = false
//        guest2.alpha = 0
//        guest2.userInteractionEnabled = false
//        guest3.alpha = 0
//        guest3.userInteractionEnabled = false
//        guest4.alpha = 0
//        guest4.userInteractionEnabled = false
//    } else if listOfRsvpd.count == 1 {
//            
//            name1.text = listOfRsvpd[0]
//            let nameToSearch = listOfRsvpd[0]
//            
//            var userQuery = PFUser.query()
//            userQuery?.whereKey("username", equalTo: nameToSearch)
//            userQuery?.findObjectsInBackgroundWithBlock({
//                
//                (objects: [AnyObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    for object in objects! {
//                        if let downloadedImage: UIImage = UIImage(data: (object.objectForKey("imageFIle")?.getData()!)!) {
//                            self.guest1.setImage(downloadedImage, forState: .Normal)
//                        } else {
//                            self.guest1.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal)
//                            
//                        }
//
//                    }
//                }
//            })
//        
//            
//            guest2.alpha = 0
//            guest2.userInteractionEnabled = false
//            guest3.alpha = 0
//            guest3.userInteractionEnabled = false
//            guest4.alpha = 0
//            guest4.userInteractionEnabled = false
//        
//        } else if listOfRsvpd.count == 2 {
//            name1.text = listOfRsvpd[0]
//            let nameToSearch = listOfRsvpd[0]
//            
//            var userQuery = PFUser.query()
//            userQuery?.whereKey("username", equalTo: nameToSearch)
//            userQuery?.findObjectsInBackgroundWithBlock({
//                
//                (objects: [AnyObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    for object in objects! {
//                        if let downloadedImage: UIImage = UIImage(data: (object.objectForKey("imageFIle")?.getData()!)!) {
//                            self.guest1.setImage(downloadedImage, forState: .Normal)
//                        } else {
//                            self.guest1.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal)
//                            
//                        }
//                        
//                    }
//                }
//            })
//            
//            name2.text = listOfRsvpd[1]
//            let nameToSearch2 = listOfRsvpd[1]
//            
//            var userQuery2 = PFUser.query()
//            userQuery2?.whereKey("username", equalTo: nameToSearch2)
//            userQuery2?.findObjectsInBackgroundWithBlock({
//                
//                (objects: [AnyObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    for object in objects! {
//                        if let downloadedImage: UIImage = UIImage(data: (object.objectForKey("imageFIle")?.getData()!)!) {
//                            self.guest2.setImage(downloadedImage, forState: .Normal)
//                        } else {
//                            self.guest2.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal)
//                            
//                        }
//                        
//                    }
//                }
//            })
//            
//            guest3.alpha = 0
//            guest3.userInteractionEnabled = false
//            guest4.alpha = 0
//            guest4.userInteractionEnabled = false
//
//        
//        } else if listOfRsvpd.count == 3 {
//            
//            name1.text = listOfRsvpd[0]
//            let nameToSearch = listOfRsvpd[0]
//            
//            var userQuery = PFUser.query()
//            userQuery?.whereKey("username", equalTo: nameToSearch)
//            userQuery?.findObjectsInBackgroundWithBlock({
//                
//                (objects: [AnyObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    for object in objects! {
//                        if let downloadedImage: UIImage = UIImage(data: (object.objectForKey("imageFIle")?.getData()!)!) {
//                            self.guest1.setImage(downloadedImage, forState: .Normal)
//                        } else {
//                            self.guest1.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal)
//                            
//                        }
//                        
//                    }
//                }
//            })
//            
//            name2.text = listOfRsvpd[1]
//            let nameToSearch2 = listOfRsvpd[1]
//            
//            var userQuery2 = PFUser.query()
//            userQuery2?.whereKey("username", equalTo: nameToSearch2)
//            userQuery2?.findObjectsInBackgroundWithBlock({
//                
//                (objects: [AnyObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    for object in objects! {
//                        if let downloadedImage: UIImage = UIImage(data: (object.objectForKey("imageFIle")?.getData()!)!) {
//                            self.guest2.setImage(downloadedImage, forState: .Normal)
//                        } else {
//                            self.guest2.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal)
//                            
//                        }
//                        
//                    }
//                }
//            })
//            
//            name3.text = listOfRsvpd[2]
//            let nameToSearch3 = listOfRsvpd[2]
//            
//            var userQuery3 = PFUser.query()
//            userQuery3?.whereKey("username", equalTo: nameToSearch3)
//            userQuery3?.findObjectsInBackgroundWithBlock({
//                
//                (objects: [AnyObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    for object in objects! {
//                        if let downloadedImage: UIImage = UIImage(data: (object.objectForKey("imageFIle")?.getData()!)!) {
//                            self.guest3.setImage(downloadedImage, forState: .Normal)
//                        } else {
//                            self.guest3.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal)
//                            
//                        }
//                        
//                    }
//                }
//            })
//            
//            guest4.alpha = 0
//            guest4.userInteractionEnabled = false
//        
//        } else {
//            
//            name1.text = listOfRsvpd[0]
//            let nameToSearch = listOfRsvpd[0]
//            
//            var userQuery = PFUser.query()
//            userQuery?.whereKey("username", equalTo: nameToSearch)
//            userQuery?.findObjectsInBackgroundWithBlock({
//                
//                (objects: [AnyObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    for object in objects! {
//                        if let downloadedImage: UIImage = UIImage(data: (object.objectForKey("imageFIle")?.getData()!)!) {
//                            self.guest1.setImage(downloadedImage, forState: .Normal)
//                        } else {
//                            self.guest1.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal)
//                            
//                        }
//                        
//                    }
//                }
//            })
//            
//            name2.text = listOfRsvpd[1]
//            let nameToSearch2 = listOfRsvpd[1]
//            
//            var userQuery2 = PFUser.query()
//            userQuery2?.whereKey("username", equalTo: nameToSearch2)
//            userQuery2?.findObjectsInBackgroundWithBlock({
//                
//                (objects: [AnyObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    for object in objects! {
//                        if let downloadedImage: UIImage = UIImage(data: (object.objectForKey("imageFIle")?.getData()!)!) {
//                            self.guest2.setImage(downloadedImage, forState: .Normal)
//                        } else {
//                            self.guest2.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal)
//                            
//                        }
//                        
//                    }
//                }
//            })
//            
//            name3.text = listOfRsvpd[2]
//            let nameToSearch3 = listOfRsvpd[2]
//            
//            var userQuery3 = PFUser.query()
//            userQuery3?.whereKey("username", equalTo: nameToSearch3)
//            userQuery3?.findObjectsInBackgroundWithBlock({
//                
//                (objects: [AnyObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    for object in objects! {
//                        if let downloadedImage: UIImage = UIImage(data: (object.objectForKey("imageFIle")?.getData()!)!) {
//                            self.guest3.setImage(downloadedImage, forState: .Normal)
//                        } else {
//                            self.guest3.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal)
//                            
//                        }
//                        
//                    }
//                }
//            })
//            
//            name3.text = listOfRsvpd[3]
//            let nameToSearch4 = listOfRsvpd[3]
//            
//            var userQuery4 = PFUser.query()
//            userQuery4?.whereKey("username", equalTo: nameToSearch4)
//            userQuery4?.findObjectsInBackgroundWithBlock({
//                
//                (objects: [AnyObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    for object in objects! {
//                        if let downloadedImage: UIImage = UIImage(data: (object.objectForKey("imageFIle")?.getData()!)!) {
//                            self.guest4.setImage(downloadedImage, forState: .Normal)
//                        } else {
//                            self.guest4.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal)
//                            
//                        }
//                        
//                    }
//                }
//            })
//        
//      }


        myMap.showsUserLocation = true
        var userLocation = myMap.userLocation
        var locationAllowed = [CLLocationManager.locationServicesEnabled()]
        var address: String = eventLocation
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
                        self.alert("Location Settings Disabled", message: "Please enable location settings to see current location")
                        
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
        
        if eventOwner != nil {
            host.text = eventOwner
        } else {
            host.text = "No Owner"
        }
        
        var findEventOwner = PFUser.query()!
        
        findEventOwner.whereKey("username", equalTo: eventOwner)

        findEventOwner.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    if object.objectForKey("ProfilePic") != nil {
                        object.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock({
                            
                            (data: NSData?, error: NSError?) -> Void in
                            
                            let downloadedImage = UIImage(data: data!)
                            self.eventOwnerPicture.image = downloadedImage
                        })
                    } else {
                        self.eventOwnerPicture.image = UIImage(named: "placeholder.jpg")
                    }
                }
            }
        })

        self.eventOwnerPicture.contentMode = UIViewContentMode.ScaleAspectFill
        self.eventOwnerPicture.clipsToBounds = true
        self.eventOwnerPicture.layer.cornerRadius = self.eventOwnerPicture.frame.height/2
        
        println(eventType.text!)
        

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
        
        return true
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
    
    func alert(tite: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func rsvp(sender: UIButton) {
        
        count = 0
        
        var query = PFQuery(className: "eventPosts")
        var eventObjectId = objectId
        var eventObjectName = eventName
        query.whereKey("objectId", equalTo: objectId)
        
        query.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            
            if error == nil {
                for object in objects! {
                    let usersWhoRsvpd = object.objectForKey("rsvpList") as? [String]
                    if usersWhoRsvpd != nil {
                        for user in usersWhoRsvpd! {
                            if user == PFUser.currentUser()!.username! {
                                self.count++
                            }
                        }
                        
                        if self.count == 0 {
                            
                            var submitAlert = UIAlertController(title: "Confirm", message: "Please confirm you would like to RSVP", preferredStyle: UIAlertControllerStyle.Alert)
                            submitAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: {
                                
                                (action: UIAlertAction!) in
                                if object.objectForKey("rsvpList") != nil {
                                    object.addObject(PFUser.currentUser()!.username!, forKey: "rsvpList")
                                    object.saveInBackground()
                                } else {
                                    object.setObject([PFUser.currentUser()!.username!], forKey: "rsvpList")
                                    object.saveInBackground()
                                }
                                
                                if PFUser.currentUser()!.objectForKey("eventsAttending") != nil {
                                    PFUser.currentUser()!.objectForKey("eventsAttending")!.addObject(eventObjectId)
                                } else {
                                    PFUser.currentUser()!.setObject([eventObjectId], forKey: "eventsAttending")
                                }
                                
                                if PFUser.currentUser()!.objectForKey("eventsAttendingName") != nil {
                                    PFUser.currentUser()?.objectForKey("eventsAttendingName")!.addObject(eventObjectName!)
                                } else {
                                    PFUser.currentUser()!.setObject([eventObjectName!], forKey: "eventsAttendingName")
                                }
                                PFUser.currentUser()!.saveInBackground()
                                self.displayAlert("Congrats", message: "You have RSVP'd")
                                
                            }))
                            submitAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(submitAlert, animated: true, completion: nil)
                            
                            
                        } else {
                            self.displayAlert("Alert", message: "You have already rsvpd")
                        }
                        
                        
                    } else {
                        self.displayAlert("Error", message: "There was an error while rsvping")
                    }
                    
                }
            } else {
                self.displayAlert("Error", message: "There was an error while rsvping")
            }
            
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "moreInfoToGroupChat" {
            var svc = segue.destinationViewController as! GroupChatViewController
            svc.objectId = objectId
            svc.objectName = eventName
        }
        
        if segue.identifier == "moreInfoToRSVP" {
            var svc = segue.destinationViewController as! RsvpListTableViewController
            svc.objectId = objectId
            svc.objectName = eventName
        }
        
        if segue.identifier == "moreInfoToComment" {
            var svc = segue.destinationViewController as! CommentsViewController
            svc.objectId = objectId
            svc.eventName = eventName
            svc.eventOwner = eventOwner
        }
        
        if segue.identifier == "getDirectionsSegue" {
            var svc = segue.destinationViewController as! googleMapsDirectionsViewController
          
        }
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.backgroundImage = nil
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func isAFollower(followCheck: String) -> Bool {
        var isFollower = false
        
        var userFollowing = PFUser.currentUser()!.objectForKey("Following") as? [String]
        for following in userFollowing! {
            if following as String == followCheck {
                isFollower = true
            }
        }
        
        return isFollower
    }
    
    @IBAction func getDirections(sender: UIButton) {
        var launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        let options = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsShowsTrafficKey: true]
        
        mapItem.openInMapsWithLaunchOptions(options as [NSObject : AnyObject])
        
    }
    
    
    @IBAction func reportButton(sender: UIButton) {
        var picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject("Complaint")
        picker.setToRecipients(["media@harbrapp.com"])
        picker.setMessageBody("I would like to report the event, \(eventName), hosted by \(eventOwner)", isHTML: true)
        
        presentViewController(picker, animated: true, completion: nil)
        
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
