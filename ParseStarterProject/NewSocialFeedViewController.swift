//
//  NewSocialFeedViewController.swift
//  Harbr
//
//  Created by Flavio Lici on 9/20/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import AVFoundation
import Parse


class NewSocialFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var previewView: UIView!
    
    @IBOutlet var mapUpDown: UIButton!
    var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var timelineData: NSMutableArray! = NSMutableArray()
    
    @IBOutlet var myTabel: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightConstraint.constant = self.view.frame.height * (3/5)
        myTabel.delegate = self
        myTabel.dataSource = self
        


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
    }
    
    @IBAction func moveViewUp(sender: UIButton) {
        UIView.animateWithDuration(1.0, animations: {
            self.heightConstraint.constant = self.view.frame.height
        })
        self.view.layoutIfNeeded()
        mapUpDown.setImage(UIImage(named: "MenuDown1.png"), forState: .Normal)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myPostsIdentifier", forIndexPath: indexPath) as! MyPicturesTableViewCell
        
        let post = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        cell.userInteractionEnabled = false
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.imagePosted.clipsToBounds = true
        cell.imagePosted.contentMode = UIViewContentMode.ScaleAspectFill
        
        cell.points.text = post.objectForKey("Points") as? String
        
        if post.objectForKey("imageFile") != nil {
            post.objectForKey("imageFile")!.getDataInBackgroundWithBlock({
                (data: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    let downloadedImage = UIImage(data: data!)
                    cell.imagePosted.image = downloadedImage
                    cell.imagePosted.contentMode = UIViewContentMode.ScaleAspectFill
                }
            })
        }
        
        if post.objectForKey("eventType") != nil {
            post.objectForKey("eventType")!.getDataInBackgroundWithBlock({
                (data: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    let downloadedImage = UIImage(data: data!)
                    cell.eventType.image = downloadedImage
                    cell.eventType.contentMode = UIViewContentMode.ScaleAspectFill
                }
            })
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if timelineData.count > 0 {
            return timelineData.count
        } else {
            return 0
        }
    }
    

    
    
    override func viewWillAppear(animated: Bool) {
        
        PFUser.currentUser()?.fetchInBackground()
        loadData()
        
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
                previewLayer?.session.sessionPreset = AVCaptureSessionPreset1920x1080
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                previewView.layer.addSublayer(previewLayer)
                
                captureSession!.startRunning()
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        timelineData.removeAllObjects()
        
        var findTimelineData = PFQuery(className: "NewSocialFeed")
        findTimelineData.whereKey("picOwner", equalTo: PFUser.currentUser()!.username!)
        
        findTimelineData.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    self.timelineData.addObject(object)
                }
                
                let array: NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = array.mutableCopy() as? NSMutableArray
                dispatch_async(dispatch_get_main_queue()) {
                    self.myTabel.reloadData()
                }
            }
        })
    }


    
}
