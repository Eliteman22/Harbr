//
//  UploadEventImageViewController.swift
//  
//
//  Created by Flavio Lici on 8/23/15.
//
//

import UIKit

class UploadEventImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    @IBOutlet var imageToPost: UIImageView!
    
    var eventName: String!
    
    var eventType: String!
    
    var eventDescription: String!
    
    var eventDate: String!
    
    var eventTime: String!
    
    var imageToSend: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
        imageToPost.clipsToBounds = true
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBarHidden = true
        
        println(eventName)
        println(eventType)
        println(eventDescription)
        println(eventDate)
        println(eventTime)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func uploadFromCamera(sender: UIButton) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadFromLibrary(sender: UIButton) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        imageToSend = image
        
        
        
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func toNextController(sender: UIButton) {
        if imageToPost.image != nil {
            self.performSegueWithIdentifier("imageToLocation", sender: self)
        } else {
            displayAlert("Error", message: "Please enter a picture")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "imageToLocation" {
            var svc = segue.destinationViewController as! submitLocationAndVenueViewController
            
            svc.eventName = eventName
            svc.eventType = eventType
            svc.eventDescription = eventDescription
            svc.eventDate = eventDate
            svc.eventTime = eventTime
            svc.eventImage = imageToSend
            
            println("It worked")
        }
    }
    

}
