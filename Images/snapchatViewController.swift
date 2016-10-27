//
//  snapchatViewController.swift
//  Harbr
//
//  Created by Flavio Lici on 9/21/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import MapKit
import Parse
import Social

class snapchatViewController: UIViewController, CLLocationManagerDelegate, UIDocumentInteractionControllerDelegate {

    @IBOutlet var previewView: UIView!
    
    @IBOutlet var capturedImage: UIImageView!
    
    @IBOutlet var takePic: UIButton!
    
    @IBOutlet var exitSymbol: UIButton!
    
    @IBOutlet var backArrow: UIButton!
    
    private var documentController: UIDocumentInteractionController!
    
    @IBOutlet var cameraSwitch: UIButton!
    
    @IBOutlet var swipeView: UIView!
    
    @IBOutlet var eventImage: UIImageView!
    
    @IBOutlet var typeName: UILabel!
    
    @IBOutlet var nextImage: UIButton!

    @IBOutlet var previewImage: UIButton!
    
    var locationManager = CLLocationManager()
    
    @IBOutlet var saveToPhone: UIButton!
    
    @IBOutlet var saveView: UIView!
    
    @IBOutlet var blackLayer: UIImageView!
    
    var myLocation: String!
        
    var eventImageCounter = 0
    
    let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
    var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var eventTypes: [UIImage!] = [UIImage]()
    
    
    @IBOutlet var exitShare: UIButton!
    
    
    @IBOutlet var myScroll: UIScrollView!
    
    var eventTypeNames: [String]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveView.alpha = 0
        blackLayer.alpha = 0
        exitShare.alpha = 0
        exitShare.userInteractionEnabled = false
        saveView.layer.cornerRadius = 10
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        previewImage.alpha = 0
        previewImage.userInteractionEnabled = false
        nextImage.alpha = 0
        nextImage.userInteractionEnabled = false
        eventImage.alpha = 0
        typeName.alpha = 0
        saveToPhone.alpha = 0
        saveToPhone.userInteractionEnabled = false
  
        eventTypes = [UIImage(named: "AwarenessIcon.png"), UIImage(named: "BarIcon.png"), UIImage(named: "EducationalIcon.png"), UIImage(named: "partyIcon.png"), UIImage(named: "SchoolIcon.png"), UIImage(named: "SportsIcon.png")]
        eventTypeNames = ["Awareness", "Bar", "Educational", "Party", "School", "Sports"]
        
        
        exitSymbol.alpha = 0
        exitSymbol.userInteractionEnabled = false
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = true
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        var error: NSError?
        var input = AVCaptureDeviceInput(device: backCamera, error: &error)
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.session.sessionPreset = AVCaptureSessionPresetiFrame1280x720
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                previewView.layer.addSublayer(previewLayer)
                
                captureSession!.startRunning()
            }
        }

    }
    
    
    
    @IBAction func captureImage(sender: UIButton) {
        
        if takePic.imageView?.image == UIImage(named: "SendPic.png") {
            var pic = PFObject(className: "NewSocialFeed")
            
            if myLocation != nil {
                pic["Location"] = myLocation
            }
            
            if !typeName.text!.isEmpty {
                pic["eventType"] = typeName.text
            }
            
            
            
            if capturedImage.image != nil {
                let imageFile: PFFile = PFFile(name: "image.png", data: UIImageJPEGRepresentation(capturedImage.image, 0.8))
                pic["imageFile"] = imageFile
                
            } else {
                displayAlert("Error", message: "Please enter an image")
            }
            
            if eventImage.image != nil {
                let imageFile = PFFile(name: "typeImage.png", data: UIImageJPEGRepresentation(eventImage.image, 0.8))
                pic["eventTypeImage"] = imageFile
            } else {
                displayAlert("Error", message: "Please choose the event type")
            }
            
            if PFUser.currentUser()?.username != nil {
                pic["picOwner"] = PFUser.currentUser()?.username
            }
            
            pic["Points"] = 0
            
            pic.saveInBackground()
            
            displayAlert("Congrats", message: "Your picture was posted")

            capturedImage.image = nil
            exitSymbol.alpha = 0
            exitSymbol.userInteractionEnabled = false
            self.takePic.setImage(UIImage(named: "TakePic.png"), forState: .Normal)
            backArrow.alpha = 1
            backArrow.userInteractionEnabled = true
            cameraSwitch.alpha = 1
            cameraSwitch.userInteractionEnabled = true
            previewImage.alpha = 0
            previewImage.userInteractionEnabled = false
            nextImage.alpha = 0
            nextImage.userInteractionEnabled = false
            eventImage.alpha = 0
            typeName.alpha = 0
            saveToPhone.alpha = 0
            saveToPhone.userInteractionEnabled = false
            
        } else {
            if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
                videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
                stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                    if (sampleBuffer != nil) {
                        var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                        var dataProvider = CGDataProviderCreateWithCFData(imageData)
                        var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                        
                        var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
                        self.capturedImage.image = image
                        
                        self.takePic.setImage(UIImage(named: "SendPic.png"), forState: .Normal)
                        
                        self.exitSymbol.alpha = 1
                        self.exitSymbol.userInteractionEnabled = true
                        
                        
                    }
                })
            }
            
            if backCamera!.position == AVCaptureDevicePosition.Front {
                capturedImage.transform = CGAffineTransformMakeScale(-1, 1)
            }
            backArrow.alpha = 0
            backArrow.userInteractionEnabled = false
            cameraSwitch.alpha = 0
            cameraSwitch.userInteractionEnabled = false
            previewImage.alpha = 0.4
            previewImage.userInteractionEnabled = true
            nextImage.alpha = 0.4
            nextImage.userInteractionEnabled = true
            eventImage.alpha = 1
            typeName.alpha = 1
            saveToPhone.alpha = 1
            saveToPhone.userInteractionEnabled = true
            
            
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
                
                self.myLocation = placemark.locality
                
                self.locationManager.stopUpdatingLocation()
            }
        })
        
        locationManager.stopUpdatingLocation()
        
    }

    @IBAction func close(sender: UIButton) {
        capturedImage.image = nil
        exitSymbol.alpha = 0
        exitSymbol.userInteractionEnabled = false
        self.takePic.setImage(UIImage(named: "TakePic.png"), forState: .Normal)
        backArrow.alpha = 1
        backArrow.userInteractionEnabled = true
        cameraSwitch.alpha = 1
        cameraSwitch.userInteractionEnabled = true
        previewImage.alpha = 0
        previewImage.userInteractionEnabled = false
        nextImage.alpha = 0
        nextImage.userInteractionEnabled = false
        eventImage.alpha = 0
        typeName.alpha = 0
        saveToPhone.alpha = 0
        saveToPhone.userInteractionEnabled = false
        
        
    }
    
    @IBAction func switchCamera(sender: UIButton) {
        let currentCameraInput: AVCaptureInput = captureSession!.inputs[0] as! AVCaptureInput
        captureSession!.removeInput(currentCameraInput)
        
        let newCamera: AVCaptureDevice?
        if(backCamera!.position == AVCaptureDevicePosition.Back){
            println("Setting new camera with Front")
            newCamera = self.cameraWithPosition(AVCaptureDevicePosition.Front)
        } else {
            println("Setting new camera with Back")
            newCamera = self.cameraWithPosition(AVCaptureDevicePosition.Back)
        }
        
        let newVideoInput = AVCaptureDeviceInput(device: newCamera!, error: nil)
        if(newVideoInput != nil) {
            captureSession!.addInput(newVideoInput)
        } else {
            println("Error creating capture device input")
        }
        
        captureSession!.commitConfiguration()
        backCamera = newCamera
        
    }
    
    func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice {
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if(device.position == position){
                return device as! AVCaptureDevice
            }
        }
        return AVCaptureDevice()
    }
    
    func swipeRight(recognizer : UISwipeGestureRecognizer) {
        if eventImageCounter > 0 {
            eventImageCounter--
            eventImage.image = eventTypes[eventImageCounter]
            typeName.text = eventTypeNames[eventImageCounter]
            if eventImageCounter >= 1 {
                previewImage.setImage(eventTypes[eventImageCounter - 1], forState: .Normal)
            } else {
                previewImage.setImage(nil, forState: .Normal)
            }
            if eventImageCounter <= 4 {
                nextImage.setImage(eventTypes[eventImageCounter + 1], forState: .Normal)
            } else {
                nextImage.setImage(nil, forState: .Normal)
            }
        }

    }
    
    func swipeLeft(recognizer: UISwipeGestureRecognizer) {
        if eventImageCounter < 5 {
            eventImageCounter++
            eventImage.image = eventTypes[eventImageCounter]
            typeName.text = eventTypeNames[eventImageCounter]
            if eventImageCounter <= 4 {
                nextImage.setImage(eventTypes[eventImageCounter + 1], forState: .Normal)
            } else {
                nextImage.setImage(nil, forState: .Normal)
            }
            if eventImageCounter >= 1 {
                previewImage.setImage(eventTypes[eventImageCounter - 1], forState: .Normal)
            } else {
                previewImage.setImage(nil, forState: .Normal)
            }
        }

    }
    
    
    @IBAction func previewImageGo(sender: UIButton) {
        if eventImageCounter > 0 {
            eventImageCounter--
            eventImage.image = eventTypes[eventImageCounter]
            typeName.text = eventTypeNames[eventImageCounter]
            if eventImageCounter >= 1 {
                previewImage.setImage(eventTypes[eventImageCounter - 1], forState: .Normal)
            } else {
                previewImage.setImage(nil, forState: .Normal)
            }
            if eventImageCounter <= 4 {
                nextImage.setImage(eventTypes[eventImageCounter + 1], forState: .Normal)
            } else {
                nextImage.setImage(nil, forState: .Normal)
            }
        }
    }
    
    @IBAction func nextImageGo(sender: UIButton) {
        if eventImageCounter < 5 {
            eventImageCounter++
            eventImage.image = eventTypes[eventImageCounter]
            typeName.text = eventTypeNames[eventImageCounter]
            if eventImageCounter <= 4 {
                nextImage.setImage(eventTypes[eventImageCounter + 1], forState: .Normal)
            } else {
                nextImage.setImage(nil, forState: .Normal)
            }
            if eventImageCounter >= 1 {
                previewImage.setImage(eventTypes[eventImageCounter - 1], forState: .Normal)
            } else {
                previewImage.setImage(nil, forState: .Normal)
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func sharePhoto(sender: UIButton) {
        UIView.animateWithDuration(0.5, animations: {
            self.saveView.alpha = 1
            self.exitShare.alpha = 1
            self.exitShare.userInteractionEnabled = true
            self.cameraSwitch.alpha = 0
            self.cameraSwitch.userInteractionEnabled = false
            self.backArrow.alpha = 0
            self.takePic.userInteractionEnabled = false
            self.takePic.alpha = 0
            self.takePic.userInteractionEnabled = false
            self.eventImage.alpha = 0
            self.nextImage.alpha = 0
            self.nextImage.userInteractionEnabled = false
            self.previewImage.alpha = 0
            self.previewImage.userInteractionEnabled = false
            self.typeName.alpha = 0
            self.blackLayer.alpha = 0.8
            self.exitSymbol.alpha = 0
            self.exitSymbol.userInteractionEnabled = false
        })
    }
    
    
    @IBAction func shareToFacebook(sender: UIButton) {
        var shareToTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        
        
        if capturedImage.image != nil {
            shareToTwitter.addImage(capturedImage.image)
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
    
    @IBAction func shareToInstagram(sender: UIButton) {
        
        let instagramUrl = NSURL(string: "instagram:://app")

        
        if capturedImage.image != nil {
            if (UIApplication.sharedApplication().canOpenURL(instagramUrl!)) {
                let imageData = UIImageJPEGRepresentation(capturedImage.image, 0.9)
                
                
                
                
                
                let writePath = NSTemporaryDirectory().stringByAppendingPathComponent("instagram.igo")
                
                if (!imageData.writeToFile(writePath, atomically: true)) {
                    displayAlert("Error", message: "Failed to post")
                } else {
                    let fileURL = NSURL(fileURLWithPath: writePath)
                    self.documentController = UIDocumentInteractionController(URL: fileURL!)
                    self.documentController.delegate = self
                    self.documentController.UTI = "com.instagram.exclusivegram"
                
                    
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

    @IBAction func shareToTwitter(sender: UIButton) {
      
        
        var shareToTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        
        if capturedImage.image != nil {
            shareToTwitter.addImage(capturedImage.image)
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
    
    @IBAction func closeShareScreen(sender: UIButton) {
        self.saveView.alpha = 0
        self.exitShare.alpha = 0
        self.exitShare.userInteractionEnabled = false
        self.cameraSwitch.alpha = 1
        self.cameraSwitch.userInteractionEnabled = true
        self.backArrow.alpha = 0
        self.takePic.userInteractionEnabled = false
        self.takePic.alpha = 1
        self.takePic.userInteractionEnabled = true
        self.eventImage.alpha = 1
        self.nextImage.alpha = 1
        self.nextImage.userInteractionEnabled = true
        self.previewImage.alpha = 1
        self.previewImage.userInteractionEnabled = true
        self.typeName.alpha = 1
        self.blackLayer.alpha = 0
        self.exitSymbol.alpha = 1
        self.exitSymbol.userInteractionEnabled = true
    }
    
}
