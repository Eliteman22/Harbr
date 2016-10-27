//
//  SocialUploadViewController.swift
//  
//
//  Created by Flavio Lici on 7/1/15.
//
//

import UIKit
import Parse
import Social
import MapKit

class SocialUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIDocumentInteractionControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var comments: UITextField!
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    var locationManager = CLLocationManager()
    
    @IBOutlet var nightLabel: UILabel!
    
    var userImage: UIImage!
    
    var currentDate: String!
    
    var imageHasBeenSent: UIImage!
    
    @IBOutlet var image1: UIImageView!
    
    @IBOutlet var image2: UIImageView!
    
    @IBOutlet var image3: UIImageView!
    
    @IBOutlet var image4: UIImageView!
    
    @IBOutlet var image5: UIImageView!
    
    @IBOutlet var image6: UIImageView!
    
    var dateToPost: String!
    
    
    @IBOutlet var filterView: UIImageView!
    
    @IBOutlet var horizontalScroll: UIScrollView!
    
    
    
    private var documentController: UIDocumentInteractionController!
    
    @IBOutlet var cameraUpload: UIButton!
    var activityIndication = UIActivityIndicatorView()
    
    var counter = 1
    
    var isPosted: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventName.delegate = self
        self.comments.delegate = self
        isPosted = false
        
        horizontalScroll.frame.size.height = 146
        horizontalScroll.frame.size.width = 640
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        
        image1.image = imageHasBeenSent
        image1.contentMode = UIViewContentMode.ScaleAspectFill
        image1.clipsToBounds = true
        image2.image = imageHasBeenSent
        image2.contentMode = UIViewContentMode.ScaleAspectFill
        image2.clipsToBounds = true
        image3.image = imageHasBeenSent
        image3.contentMode = UIViewContentMode.ScaleAspectFill
        image3.clipsToBounds = true
        image4.image = imageHasBeenSent
        image4.contentMode = UIViewContentMode.ScaleAspectFill
        image4.clipsToBounds = true
        image5.image = imageHasBeenSent
        image5.contentMode = UIViewContentMode.ScaleAspectFill
        image5.clipsToBounds = true
        image6.image = imageHasBeenSent
        image6.contentMode = UIViewContentMode.ScaleAspectFill
        image6.clipsToBounds = true
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        currentDate = dateFormatter.stringFromDate(NSDate())
        
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateStyle = .ShortStyle
        
        let currentMonth = dateFormatter1.stringFromDate(NSDate())
        
        let dateFormatterTime = NSDateFormatter()
        dateFormatterTime.timeStyle = .ShortStyle
        
        let currentTime = dateFormatterTime.stringFromDate(NSDate())
        
        dateToPost = "\(currentMonth), \(currentTime)"
        
        horizontalScroll.backgroundColor = UIColorFromRGB("222222", alpha: 1.0)
        
        if checkIfDay(currentDate) {
            nightLabel.backgroundColor = UIColor.whiteColor()
        }
        
        self.navigationController?.navigationBarHidden = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        imageToPost.image = imageHasBeenSent
        imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
        imageToPost.clipsToBounds = true
        
        if PFUser.currentUser()!.objectForKey("ProfilePic") != nil {
            
            PFUser.currentUser()?.objectForKey("ProfilePic")?.getDataInBackgroundWithBlock({
            (data: NSData?, error: NSError?) -> Void in
            
            if error == nil {
            
            let downloadedImage: UIImage = UIImage(data: data!)!
            self.userImage = downloadedImage
            }
        })
            
        
            
        } else {
            userImage = UIImage(named: "placeholder.jpg")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    func checkIfDay(time: String) -> Bool {
        
        var fullName = time
        let fullNameArr = fullName.componentsSeparatedByString(":")
        
        var firstName: String = fullNameArr[0]
        var lastName: String = fullNameArr[1]
        
        if (firstName.toInt()! > 6) && (firstName.toInt()! <= 19) {
            return true
        } else {
            return false
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation: CLLocation = locations[0] as! CLLocation
        
        
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
                
                self.eventName.text = "\(placemark.locality)"
                println("\(placemark.locality)")
                
                self.locationManager.stopUpdatingLocation()
            }
        })
        
        locationManager.stopUpdatingLocation()
        
    }
    
    

    
    @IBAction func postImage(sender: UIButton) {
        
        activityIndication = UIActivityIndicatorView(frame: self.view.frame)
        activityIndication.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndication.center = self.view.center
        activityIndication.hidesWhenStopped = true
        activityIndication.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndication)
        activityIndication.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var post = PFObject(className: "SocialFeed")
        
        
        if !comments.text.isEmpty {
            post["comment"] = comments.text
        }
        
        var newImage: UIImage!
        var newImage2: UIImage!
        if filterView.image != nil {
        
        var bottomImage = imageToPost.image
        var topImage = filterView.image
        
        var size = CGSize(width: CGImageGetWidth(bottomImage?.CGImage), height: CGImageGetHeight(bottomImage?.CGImage))
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            println(self.view.frame.width)
        bottomImage!.drawInRect(areaSize)
        
        topImage!.drawInRect(areaSize, blendMode: kCGBlendModeNormal, alpha: 0.8)
        
        newImage
            = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        newImage2 = compositeImage(imageToPost.image!, image2: filterView.image!)
            
        }
        
        
        post["userId"] = PFUser.currentUser()!.objectId!
        post["username"] = PFUser.currentUser()!.username!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        post["timePosted"] = dateToPost
        post["eventName"] = eventName.text
        if userImage != nil {
            let imageData = userImage
            
            let imageFile: PFFile = PFFile(name: "userImage.png", data: UIImageJPEGRepresentation(imageData, 0.5))
            
            if userImage != nil {
                post["userImage"] = imageFile
            
                
            } else {
                displayAlert("Error", message: "There was an error uploading your profile picture")
            }
        }
        post["Views"] = []
        
        var imageData: UIImage!
        
    
        if filterView.image == nil {
            imageData = imageToPost.image!
        } else {
            imageData = newImage
        }
        
        let imageFile: PFFile = PFFile(name: "image.png", data: UIImageJPEGRepresentation(imageData, 0.7))
        
        
        if imageToPost.image != nil {
            post["imageFile"] = imageFile
            
        } else {
            displayAlert("Error", message: "Please enter an image")
        }
        
        
        post.saveInBackgroundWithBlock( {
            (success, error) -> Void in
            
            self.activityIndication.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error != nil {
                self.displayAlert("Error", message: "Could not display image please try again later")
            } else {
                self.imageToPost.image = nil
                self.comments.text = nil
                self.eventName.text = nil
                
                
                if PFUser.currentUser()!.objectForKey("Points") == nil {
                    PFUser.currentUser()!.setObject(5, forKey: "Points")
                } else {
                    var currentPoints = PFUser.currentUser()!.objectForKey("Points") as? Int
                    var newScore: Int = currentPoints! + 5
                    PFUser.currentUser()!.setObject(newScore, forKey: "Points")
                }
                
                
                PFUser.currentUser()!.saveInBackground()
                self.performSegueWithIdentifier("backToSocialFeed", sender: self)
                self.displayAlert("Congrats", message: "Your post was succesful")
                
            }
        })
        
        
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
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    @IBAction func shareToFacebook(sender: UIButton) {
        var shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        
        let newImage = compositeImage(imageToPost.image!, image2: filterView.image!)
        if eventName.text != nil {
            shareToFacebook.setInitialText(eventName.text)
        
            
        } else {
            displayAlert("Alert", message: "Enter an event name")
        }
        
        if imageToPost.image != nil {
            shareToFacebook.addImage(newImage)
        } else {
            displayAlert("Alert", message: "You must submit a photo")
        }
        
        if PFUser.currentUser()!.objectForKey("Points") == nil {
            PFUser.currentUser()!.setObject(5, forKey: "Points")
        } else {
            var currentPoints = PFUser.currentUser()!.objectForKey("Points") as? Int
            var newScore: Int = currentPoints! + 5
            PFUser.currentUser()!.setObject(newScore, forKey: "Points")
        }
        
        
        PFUser.currentUser()!.saveInBackground()
        
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
        
    }
    
    
    @IBAction func shareToInstagram(sender: UIButton) {
        let instagramUrl = NSURL(string: "instagram:://app")
        
        let newImage = compositeImage(imageToPost.image!, image2: filterView.image!)
        
        if imageToPost.image != nil {
            if (UIApplication.sharedApplication().canOpenURL(instagramUrl!)) {
                let imageData = UIImageJPEGRepresentation(newImage, 0.9)
                
                let captionString = "\(eventName.text)"
                    
             
                
                let writePath = NSTemporaryDirectory().stringByAppendingPathComponent("instagram.igo")
                
                if (!imageData.writeToFile(writePath, atomically: true)) {
                    displayAlert("Error", message: "Failed to post")
                } else {
                    let fileURL = NSURL(fileURLWithPath: writePath)
                    self.documentController = UIDocumentInteractionController(URL: fileURL!)
                    self.documentController.delegate = self
                    self.documentController.UTI = "com.instagram.exclusivegram"
                    self.documentController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption")
                    
                    if PFUser.currentUser()!.objectForKey("Points") == nil {
                        PFUser.currentUser()!.setObject(5, forKey: "Points")
                    } else {
                        var currentPoints = PFUser.currentUser()!.objectForKey("Points") as? Int
                        var newScore: Int = currentPoints! + 5
                        PFUser.currentUser()!.setObject(newScore, forKey: "Points")
                    }
                    
                    
                    PFUser.currentUser()!.saveInBackground()
                    
                    self.documentController.presentOpenInMenuFromRect(self.view.frame, inView: self.view, animated: true)
                    
                }
            } else {
                displayAlert("Error", message: "Instagram not available")
            }
        } else {
            displayAlert("Alert", message: "Please enter an image")
        }
        
    }
    
    @IBAction func filter1Set(sender: UIButton) {
        filterView.image = sender.imageView?.image
        filterView.alpha = 0.7
    }
    
    @IBAction func filter2Set(sender: UIButton) {
        filterView.image = sender.imageView?.image
        filterView.alpha = 0.7
    }
    
    @IBAction func filter3Set(sender: UIButton) {
        filterView.image = sender.imageView?.image
        filterView.alpha = 0.7
    }
    
    @IBAction func filter4Set(sender: UIButton) {
        filterView.image = sender.imageView?.image
        filterView.alpha = 0.7
    }
    
    @IBAction func filter5Set(sender: UIButton) {
        filterView.image = sender.imageView?.image
        filterView.alpha = 0.7
    }
    
    @IBAction func filterDefault(sender: UIButton) {
        filterView.image = nil
    
    }
    
    
    
    
    
    @IBAction func shareToTwitter(sender: UIButton) {
        
        let newImage = compositeImage(imageToPost.image!, image2: filterView.image!)
        
        var shareToTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)

        
        if imageToPost.image != nil {
            shareToTwitter.addImage(newImage)
        } else {
            displayAlert("Error", message: "Please upload an image")
        }
        if PFUser.currentUser()!.objectForKey("Points") == nil {
            PFUser.currentUser()!.setObject(5, forKey: "Points")
        } else {
            var currentPoints = PFUser.currentUser()!.objectForKey("Points") as? Int
            var newScore: Int = currentPoints! + 5
            PFUser.currentUser()!.setObject(newScore, forKey: "Points")
        }
        
        
        PFUser.currentUser()!.saveInBackground()
        
        
        self.presentViewController(shareToTwitter, animated: true, completion: nil)
        
    }
    
    func compositeImage(image1: UIImage, image2: UIImage) -> UIImage {
        var bounds1 = CGRectMake(0, 0, image1.size.width, image1.size.height)
        var bounds2 = CGRectMake(0, 0, image2.size.width, image2.size.height)
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        var ctx = CGBitmapContextCreate(nil,
            CGImageGetWidth(image1.CGImage),
            CGImageGetHeight(image1.CGImage),
            CGImageGetBitsPerComponent(image1.CGImage),
            CGImageGetBytesPerRow(image1.CGImage),
            CGImageGetColorSpace(image1.CGImage),
            bitmapInfo)!
        var ctx2 = CGBitmapContextCreate(nil,
            CGImageGetWidth(image2.CGImage),
            CGImageGetHeight(image2.CGImage),
            CGImageGetBitsPerComponent(image2.CGImage),
            CGImageGetBytesPerRow(image2.CGImage),
            CGImageGetColorSpace(image2.CGImage),
            bitmapInfo)!
        CGContextDrawImage(ctx, bounds1, image1.CGImage)
        CGContextSetBlendMode(ctx, kCGBlendModeNormal) // one image over the other
        CGContextDrawImage(ctx2, bounds2, image2.CGImage)
        return UIImage(CGImage: CGBitmapContextCreateImage(ctx))!
    }
    
    func maskImage(image: UIImage, withMask maskImage: UIImage) -> UIImage {
        
        let maskRef = maskImage.CGImage
        
        let mask = CGImageMaskCreate(
            Int(self.view.frame.width),
            260,
            CGImageGetBitsPerComponent(maskRef),
            CGImageGetBitsPerPixel(maskRef),
            CGImageGetBytesPerRow(maskRef),
            CGImageGetDataProvider(maskRef),
            nil,
            false)
        
        let masked = CGImageCreateWithMask(image.CGImage, mask)
        let maskedImage = UIImage(CGImage: masked)!
        
        // No need to release. Core Foundation objects are automatically memory managed.
        
        return maskedImage
        
    }

}
