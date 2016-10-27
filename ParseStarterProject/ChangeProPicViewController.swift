//
//  ChangeProPicViewController.swift
//  
//
//  Created by Flavio Lici on 9/5/15.
//
//

import UIKit
import Parse

class ChangeProPicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var proPic: UIImageView!
    
    @IBOutlet var finishButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishButton.alpha = 0
        finishButton.userInteractionEnabled = false
        
        PFUser.currentUser()?.fetchInBackground()
        
        proPic.clipsToBounds = true
        proPic.contentMode = UIViewContentMode.ScaleAspectFill
        
        if PFUser.currentUser()?.objectForKey("ProfilePic") != nil {
            let downloadedImage: UIImage = UIImage(data: PFUser.currentUser()!.objectForKey("ProfilePic")!.getData()!)!
            proPic.image = downloadedImage
        } else {
            proPic.image = UIImage(named: "placeholder.jpg")
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        UIView.animateWithDuration(0.8, animations: {
            self.proPic.image = image
            self.finishButton.alpha = 1
            self.finishButton.userInteractionEnabled = true
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePicture(sender: UIButton) {
        var image = UIImagePickerController()
        image.delegate = self
        let alertController = UIAlertController(title: "Where would you like to upload from", message: "Choose: ", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .Default, handler: {
            (action) in
            image.sourceType = UIImagePickerControllerSourceType.Camera
            image.allowsEditing = true
            self.presentViewController(image, animated: true, completion: nil)
            
            
        }))
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: {
            (action) in
            
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            image.allowsEditing = true
            self.presentViewController(image, animated: true, completion: nil)
            
            
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    @IBAction func updatePic(sender: UIButton) {
        if proPic.image != nil {
            let imageData = proPic.image
            let imageFile: PFFile = PFFile(name: "propic.png", data: UIImageJPEGRepresentation(imageData, 0.8))
            PFUser.currentUser()?.setObject(imageFile, forKey: "ProfilePic")
            PFUser.currentUser()?.saveInBackground()
            self.performSegueWithIdentifier("proPicChanged", sender: self)
        } else {
            displayAlert("Error", message: "Please enter an image")
        }
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
}
