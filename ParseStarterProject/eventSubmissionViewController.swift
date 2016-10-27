//
//  eventSubmissionViewController.swift
//  
//
//  Created by Flavio Lici on 6/29/15.
//
//

import UIKit
import Parse
import Social

class eventSubmissionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    
    var isPosted: Bool = false
    
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet var address: UITextField!
    
    
    var dateSubmitted: Bool = false
    
    var venueNameToPost: String!
    
    
    var adressToPass: String!
    
    var eventType: String = ""

    @IBOutlet var descriptionField: UITextView!
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    var placesId: String!
    
    var locationManager = CLLocationManager()
    
    var userAdress: String!
    
    var userLocationFromLocationManager: CLLocation!
    
    var eventTypeUpdated: Bool = false
    
    var updatedDate: String!
    var updatedTime: String!
    
    @IBOutlet var dateandtimebutton: UIButton!
    
    @IBOutlet var eventTypeButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.eventName.delegate = self
        self.address.delegate = self
        self.descriptionField.delegate = self
        
        imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
        imageToPost.clipsToBounds = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        


    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewDidAppear(animated: Bool) {
//        date.text = updatedDate
//        time.text = updatedTime
//        
//        
//        
//    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.tabBarController?.tabBar.hidden = true
        UIApplication.sharedApplication().statusBarHidden = true
        self.navigationController?.navigationBarHidden = true
        if dateSubmitted == true {
            UIView.animateWithDuration(0.8, animations: {
                self.dateandtimebutton.userInteractionEnabled = false
                self.dateandtimebutton.titleLabel!.textColor = UIColor.whiteColor()
                self.dateandtimebutton.backgroundColor = self.UIColorFromRGB("61ab4e", alpha: 1.0)
            })
        }
        
        if eventTypeUpdated == true {
            UIView.animateWithDuration(0.8, animations: {
                self.eventTypeButton.userInteractionEnabled = false
                self.eventTypeButton.titleLabel?.textColor = UIColor.whiteColor()
                self.eventTypeButton.backgroundColor = self.UIColorFromRGB("61ab4e", alpha: 1.0)
            })
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
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation: CLLocation = locations[0] as! CLLocation
        
        userLocationFromLocationManager = userLocation
        
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        
        var latDelta: CLLocationDegrees = 0.01
        var lonDelta: CLLocationDegrees = 0.01
        
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        
    }
    
    
    
    @IBAction func submitPost(sender: UIButton) {
        if !eventName.text.isEmpty && !descriptionField.text.isEmpty && !address.text.isEmpty && updatedDate != nil && updatedTime != nil {
            var post: PFObject = PFObject(className: "eventPosts")
            post["eventOwner"] = PFUser.currentUser()!.username
            post["eventName"] = eventName.text
            post["description"] = descriptionField.text
            
            if address.text == "Current Location" {
                post["location"] = userAdress
            } else if !address.text.isEmpty {
                post["location"] = address.text
            } else {
                displayAlert("Error", message: "Please enter a location")
            }
            
            if !eventType.isEmpty {
                post["eventType"] = eventType
            } else {
                post["eventType"] = "#Aint Got No Type"
            }
            
            if !venueNameToPost.isEmpty {
                post["venueName"] = venueNameToPost
            }
            
            if placesId != nil {
                post["venueId"] = "69"
            }
            
            if updatedDate != nil {
            
                post["date"] = updatedDate
            }
            post["rsvpList"] = [PFUser.currentUser()!.username!] as [String]
            post["eventTime"] = updatedTime
            
            PFUser.currentUser()!.objectForKey("eventsHosting")!.addObject(eventName.text)
            
            
           
            
            if imageToPost.image != nil && isPosted == true {
                let imageData = imageToPost.image
                let imageFile: PFFile = PFFile(name: "image.png", data: UIImageJPEGRepresentation(imageData, 0.8))
                post["imageFIle"] = imageFile
            } else {
                displayAlert("Error", message: "Image Could not be posted!")
            }
            
            if PFUser.currentUser()!.objectForKey("Points") == nil {
                PFUser.currentUser()!.setObject(10, forKey: "Points")
            } else {
                var currentPoints = PFUser.currentUser()!.objectForKey("Points") as? Int
                var newScore: Int = currentPoints! + 10
                PFUser.currentUser()!.setObject(newScore, forKey: "Points")
            }
            PFUser.currentUser()!.save()
            post.saveInBackgroundWithBlock({
                (succeeded: Bool, error: NSError?) -> Void in
                
                if error == nil {
                    if PFUser.currentUser()!.objectForKey("eventsAttending") == nil {
                        PFUser.currentUser()!.setObject(post.objectId!, forKey: "eventsAttending")
                    } else {
                        PFUser.currentUser()!.objectForKey("eventsAttending")!.addObject(post.objectId!)
                    }
                } else {
                    self.displayAlert("Alert", message: "There was an error posting your event")
                }
                
            })
            

            self.imageToPost.image = nil
  
            self.eventName.text = ""
            self.descriptionField.text = ""
            
            self.performSegueWithIdentifier("eventSubmitted", sender: self)
        } else {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Enter all fields please"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        
    }
    
    
    @IBAction func postCameraImage(sender: UIButton) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
        
    }

    @IBAction func uploadImageFromLibrary(sender: UIButton) {
    
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        isPosted = true
        
   
        
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
    

    
    @IBAction func useCurrentLocation(sender: UIButton) {
        
        var userLocation: CLLocation = userLocationFromLocationManager
        
        var geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation, completionHandler: {
            (placemarks, errors) in
            
            if errors == nil && placemarks.count > 0 {
                var placemark: CLPlacemark = (placemarks.last as? CLPlacemark)!
                self.userAdress = placemark.thoroughfare
                self.address.text = "  Current Location"
                self.address.textColor = self.UIColorFromRGB("ffaa57", alpha: 1)
            }
        })
    }
    
    
    @IBAction func shareToFacebook(sender: UIButton) {
        var shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        if eventName.text.isEmpty || updatedDate == nil || updatedTime == nil {
            self.displayAlert("Error", message: "Please fill in all of the fields")
        } else {
            
        }
        
        if imageToPost.image != nil {
            shareToFacebook.addImage(imageToPost.image)
        } else {
            displayAlert("Error", message: "Please upload an image")
        }
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
    }
    
    @IBAction func shareToTwitter(sender: UIButton) {
        var shareToTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        if eventName.text.isEmpty || updatedTime == nil || updatedDate == nil {
            displayAlert("Error", message: "Please fill in all of the fields")
        } else {
        }
        
        if imageToPost.image != nil {
            shareToTwitter.addImage(imageToPost.image)
        } else {
            displayAlert("Error", message: "Please upload an image")
        }
        
        self.presentViewController(shareToTwitter, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseVenue" {
            var svc = segue.destinationViewController as! GooglePlacePickerViewController
            svc.locationToSearch = adressToPass
        }
    }
    

}
